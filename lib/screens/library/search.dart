import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  void _performSearch(String query) {
    // Implement your search logic here
    // This is a placeholder implementation
    setState(() {
      _searchResults = [
        {'title': 'Book 1', 'author': 'Author 1', 'isbn': '1234567890'},
        {'title': 'Book 2', 'author': 'Author 2', 'isbn': '0987654321'},
      ];
    });
  }

  void _addToLibrary(Map<String, dynamic> book) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('books')
        .add(book)
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Book added to your library')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Books')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search by title, author, or ISBN',
                suffixIcon: Icon(Icons.search),
              ),
              onSubmitted: _performSearch,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final book = _searchResults[index];
                return ListTile(
                  title: Text(book['title']),
                  subtitle: Text(book['author']),
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => _addToLibrary(book),
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
