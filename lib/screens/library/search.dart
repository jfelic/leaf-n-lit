import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Book> _books = [];

  Future<void> _searchBooks(String query) async {
    final String apiUrl =
        'https://www.googleapis.com/books/v1/volumes?q=$query';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['items'] != null) {
        setState(() {
          _books =
              data['items'].map<Book>((item) => Book.fromJson(item)).toList();
        });
      }
    } else {
      throw Exception('Failed to load books');
    }
  }

  Future<void> _addToLibrary(Book book) async {
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
                      _searchBooks(_controller.text);
                    }
                  },
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  _searchBooks(value);
                }
              },
            ),
          ),
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

  Book(
      {required this.title,
      required this.author,
      required this.coverUrl,
      required this.isbn});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['volumeInfo']['title'] ?? 'Unknown Title',
      author: (json['volumeInfo']['authors'] != null &&
              json['volumeInfo']['authors'].isNotEmpty)
          ? json['volumeInfo']['authors'][0]
          : 'Unknown Author',
      coverUrl: (json['volumeInfo']['imageLinks'] != null)
          ? json['volumeInfo']['imageLinks']['thumbnail']
          : '',
      isbn: (json['volumeInfo']['industryIdentifiers'] != null &&
              json['volumeInfo']['industryIdentifiers'].isNotEmpty)
          ? json['volumeInfo']['industryIdentifiers'][0]['identifier']
          : 'Unknown ISBN',
    );
  }
}
