import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:leaf_n_lit/screens/library/search.dart';

class LibraryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Library'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            //.doc(FirebaseAuth.instance.currentUser!.uid)
            //.collection('books')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final books = snapshot.data!.docs
              .map((doc) => Book.fromFirestore(doc))
              .toList();

          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: CachedNetworkImage(
                    imageUrl: books[index].coverUrl,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                  title: Text(books[index].title),
                  subtitle: Text(books[index].author),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SearchScreen()),
          );
        },
        child: const Icon(Icons.add),
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

  factory Book.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Book(
      title: data['title'] ?? 'Unknown Title',
      author: data['author'] ?? 'Unknown Author',
      coverUrl: data['coverUrl'] ?? '',
      isbn: data['isbn'] ?? 'Unknown ISBN',
    );
  }
}
