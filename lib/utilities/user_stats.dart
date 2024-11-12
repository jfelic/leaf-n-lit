import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserStats {
  static Future<void> updateTotalSecondsRead(int seconds) async {
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
      int totalSecondsRead = (docSnapshot.data()?['totalSecondsRead'] ?? 0) as int; // or initialize it as 0 if it doesn't exist

      // Reference the user's document and attempt to add to totalSecondsRead
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'totalSecondsRead': totalSecondsRead + seconds,
      }, SetOptions(merge: true));
      
    } catch (e) {
      print("Error updating reading stats: $e");
    }
  }
}