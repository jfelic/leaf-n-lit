import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Book> _books = [];
  bool _isLoading = false;
  String _errorMessage = '';
  Timer? _debounce;
  
  get apiKey => null;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<http.Response> makeApiCallWithDelay(String url) async {
    final response = await http.get(Uri.parse(url));
    await Future.delayed(Duration(seconds: 1)); // 1 second delay
    return response;
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchBooks(query);
    });
  }

  Future<void> _searchBooks(String query) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final String apiUrl =
          'https://www.googleapis.com/books/v1/volumes?q=${Uri.encodeComponent(query)}&key=$apiKey';
      final response = await makeApiCallWithDelay(apiUrl);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['items'] != null) {
          setState(() {
            _books = (data['items'] as List)
                .map<Book>((item) => Book.fromJson(item))
                .where((book) => book.isValid())
                .toList();
          });
        } else {
          setState(() {
            _errorMessage = 'No books found';
          });
        }
      } else {
        throw Exception('Failed to load books: ${response.statusCode}');
      }
    } catch (e) {
      print('Error searching books: $e');
      setState(() {
        _errorMessage = 'An error occurred while searching for books: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addToLibrary(Book book) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('books')
            .add({
          'isbn': book.isbn,
          'title': book.title,
          'author': book.author,
          'coverUrl': book.coverUrl,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${book.title} added to your library')),
        );
      }
    } catch (e) {
      print('Error adding book to library: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add book to library')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Books'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter book title, author, or ISBN',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      _onSearchChanged(_controller.text);
                    }
                  },
                ),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          if (_isLoading)
            CircularProgressIndicator()
          else if (_errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(_errorMessage, style: TextStyle(color: Colors.red)),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _books.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: CachedNetworkImage(
                        imageUrl: _books[index].coverUrl,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                      title: Text(_books[index].title),
                      subtitle: Text(_books[index].author),
                      trailing: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => _addToLibrary(_books[index]),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class Book {
  final String title;
  final String author;
  final String coverUrl;
  final String isbn;

  Book({
    required this.title,
    required this.author,
    required this.coverUrl,
    required this.isbn,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] ?? {};
    return Book(
      title: volumeInfo['title'] ?? 'Unknown Title',
      author: (volumeInfo['authors'] != null && volumeInfo['authors'] is List)
          ? (volumeInfo['authors'] as List).join(', ')
          : 'Unknown Author',
      coverUrl: volumeInfo['imageLinks']?['thumbnail'] ?? '',
      isbn: (volumeInfo['industryIdentifiers'] != null &&
              volumeInfo['industryIdentifiers'] is List)
          ? ((volumeInfo['industryIdentifiers'] as List).firstWhere(
                (identifier) => identifier['type'] == 'ISBN_13',
                orElse: () => {'identifier': 'Unknown ISBN'},
              )['identifier'] ??
              'Unknown ISBN')
          : 'Unknown ISBN',
    );
  }

  bool isValid() {
    return title != 'Unknown Title' &&
        author != 'Unknown Author' &&
        isbn != 'Unknown ISBN';
  }
}
