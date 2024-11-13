import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserLibraryStats {
  static Future<void> updateBookCount(int increment) async {
    // Use Firebase Auth to grab current user
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("user == null... returning");
      return;
    }

    try {
      // Get document snapshot first
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      // Then get the data from the snapshot
      int currentBookCount = (docSnapshot.data()?['bookCount'] ?? 0)
          as int; // or initialize it as 0 if it doesn't exist
      // Reference the user's document and attempt to update bookCount
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'bookCount': currentBookCount + increment,
      }, SetOptions(merge: true));

      print("Book count updated successfully");
    } catch (e) {
      print("Error updating book count: $e");
    }
  }
}
