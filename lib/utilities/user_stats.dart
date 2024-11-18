import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserStats {

  // Update total seconds read
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
      
      // Get userStats Map or create a new one
      // and cast the map properly
      Map<String, dynamic> userStats = Map<String, dynamic>.from(
          docSnapshot.data()?['userStats'] ?? {}
      );

      // grab value of totalSecondsRead within the userStats map
      int totalSecondsRead = (userStats['totalSecondsRead'] ?? 0) as int;

      // update our map 
      userStats['totalSecondsRead'] = totalSecondsRead + seconds;

      // Update document with our updated map
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
            'userStats': userStats,
          }, SetOptions(merge: true));
      
    } catch (e) {
      print("Error updating reading stats: $e");
    }
  } // updateTotalSecondsRead() end

  // Increment # of sessions by 1 
  static Future<void> updateNumberOfSessions() async {
    // Use Firebase Auth to grab current user
    final user = FirebaseAuth.instance.currentUser;

    if(user == null) {
      print("user == null... returning"); 
      return;
    }


    try {
      // Get snapshot
      final docSnapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      
      Map<String, dynamic> userStats = Map<String, dynamic>.from (
        docSnapshot.data()?['userStats'] ?? {}
      );

      // get value of numberOfSessions
      int numberOfSessions = (userStats['numberOfSessions'] ?? 0) as int;

      // update our Map
      userStats['numberOfSessions'] = numberOfSessions + 1;
      
      // Update document with our updated map
      await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set({
          'userStats': userStats,
        }, SetOptions(merge: true));
    } catch (e) {
      print("Error updating totalSessions: $e");
    }
  } // updateNumberOfSessions() end

  // static Future<void> storeSession(Session session) async {

  // }

  // Update average length of user's sessions
  static Future<void> updateAvgLengthOfSessions() async {

  } // updateAvgLengthOfSessions() end
}

/*
  Session struct
  length:
  date:
  pagesRead:
*/

/* 
  user fields
  totalSecondsRead:
  numberOfSessions:
  avgLengthOfSessions:
  streak:
  sessions: 
 */