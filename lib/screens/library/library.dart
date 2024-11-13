import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:leaf_n_lit/screens/library/library_stats.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:leaf_n_lit/utilities/app_state.dart';
import 'package:go_router/go_router.dart'; // Import this if you're using GoRouter for navigation

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  List<Map<String, dynamic>> books = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  void _loadBooks() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('books')
          .snapshots()
          .listen((snapshot) {
        setState(() {
          books = snapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
          isLoading = false;
        });
      }, onError: (error) {
        print("Error fetching books: $error");
        setState(() {
          isLoading = false;
        });
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateBookCount(int increment) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      try {
        await userRef.update({
          'bookCount': FieldValue.increment(increment),
        });
      } catch (e) {
        print('Error updating book countL $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('My Library'),
          ),
          body: _buildLibraryContent(appState),
          floatingActionButton: appState.loggedIn
              ? FloatingActionButton(
                  onPressed: () {
                    // Navigate to the add book page
                    context.push('/search'); // If using GoRouter
                    // Or use Navigator if not using GoRouter:
                    // Navigator.of(context).pushNamed('/search');
                  },
                  child: Icon(Icons.add),
                  tooltip: 'Add a book',
                )
              : null,
        );
      },
    );
  }

  Widget _buildLibraryContent(ApplicationState appState) {
    if (!appState.loggedIn) {
      return Center(child: Text('Please log in to view your library'));
    }

    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (books.isEmpty) {
      return Center(child: Text('No books in your library yet'));
    }

    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: ListTile(
            leading: CachedNetworkImage(
              imageUrl: book['coverUrl'] ?? '',
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              width: 50,
              fit: BoxFit.cover,
            ),
            title: Text(book['title'] ?? 'Untitled'),
            subtitle: Text(book['author'] ?? 'Unknown Author'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _deleteBook(book); // Method to delete a book from the library
              },
            ),
          ),
        );
      },
    );
  }

  // Method to delete a book from the library
  void _deleteBook(Map<String, dynamic> book) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && book['isbn'] != null) {
      try {
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('books')
            .where('isbn', isEqualTo: book['isbn'])
            .get();

        if (snapshot.docs.isNotEmpty) {
          await snapshot.docs.first.reference.delete();
          await UserLibraryStats.updateBookCount(-1);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('${book['title']} removed from your library')),
          );
        }
      } catch (e) {
        print('Error deleting book: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to remove book from library')),
        );
      }
    }
  }
}
