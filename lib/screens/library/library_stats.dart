import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserLibraryStats {
  // Update the book count by a given increment
  static Future<void> updateBookCount(int increment) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("User is null, cannot update book count");
      return;
    }

    try {
      // Get the user's Firestore document
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      // Get or initialize userLibraryStats map
      Map<String, dynamic> userLibraryStats = Map<String, dynamic>.from(
          docSnapshot.data()?['userLibraryStats'] ?? {});

      // Get the current book count, defaulting to 0 if it doesn't exist
      int currentBookCount = (userLibraryStats['bookCount'] ?? 0) as int;

      // Calculate the updated book count
      int updatedBookCount = currentBookCount + increment;

      // Prevent bookCount from going negative
      if (updatedBookCount < 0) {
        print("Book count cannot be negative. Operation aborted.");
        return;
      }

      // Update the book count
      userLibraryStats['bookCount'] = updatedBookCount;

      // Save the updated map to Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'userLibraryStats': userLibraryStats,
      }, SetOptions(merge: true));

      print("Book count updated successfully: $updatedBookCount");
    } catch (e) {
      print("Error updating book count: $e");
    }
  }

  // Fetch the current book count
  static Future<int> getBookCount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("User is null, cannot fetch book count");
      return 0;
    }

    try {
      // Get the user's Firestore document
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      // Get the userLibraryStats map and retrieve the book count
      Map<String, dynamic> userLibraryStats = Map<String, dynamic>.from(
          docSnapshot.data()?['userLibraryStats'] ?? {});
      return (userLibraryStats['bookCount'] ?? 0) as int;
    } catch (e) {
      print("Error fetching book count: $e");
      return 0;
    }
  }
}
