import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';

class LibraryPage extends StatefulWidget {
  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final TextEditingController _controller = TextEditingController();
  List<Book> _books = [];

  Future<void> _addBook(String query) async {
    // Replace this URL with a real API endpoint for fetching book data
    final String apiUrl =
        'https://www.googleapis.com/books/v1/volumes?q=$query';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['items'] != null) {
        setState(() {
          _books.addAll(
              data['items'].map<Book>((item) => Book.fromJson(item)).toList());
        });
      }
    } else {
      throw Exception('Failed to load books');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Library'),
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
                      _addBook(_controller.text);
                      _controller.clear();
                    }
                  },
                ),
              ),
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
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    title: Text(_books[index].title),
                    subtitle: Text(_books[index].author),
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

  Book({required this.title, required this.author, required this.coverUrl});

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
    );
  }
}
