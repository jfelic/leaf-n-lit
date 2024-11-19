import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserStats {
  /* GETTERS */

  // avgLengthOfSessions
  static Future<double> getAvgLengthOfSessions() async {
    final user = FirebaseAuth.instance.currentUser;
    
    if(user == null) {
      print("user == null... returning 0");
      return 0;
    }


      try {
        final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

        Map<String, dynamic> userStats = Map<String, dynamic>.from(
          docSnapshot.data()?['userStats'] ?? {}
      );
        double avgLengthOfSessions = (userStats["avgLengthOfSessions"] ?? 0) as double;

        return avgLengthOfSessions;
        
      } catch (e) {
        print("getAvgLengthOfSessions failed: $e... returning 0");
        return 0;
      }
  } // getAvgLengthOfSessions() end


/* SETTERS */

  static Future<void> setAvgLengthOfSessions() async {
    // get user
    final user = FirebaseAuth.instance.currentUser;
    if(user == null) {
      print("setAvgLengthOfSessions: user == null... returning");
      return;
    }

    try {
      // get doc snapshot
      final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

      Map<String, dynamic> userStats = Map<String, dynamic>.from(
        docSnapshot.data()?['userStats'] ?? {}
      );

      // Get numberOfSessions
      int numberOfSessions = userStats['numberOfSessions'] ?? 0;

      // Get totalSecondsRead
      int totalSecondsRead = userStats['totalSecondsRead'] ?? 0;

      // Set avgLengthOfSessions
      userStats['avgLengthOfSessions'] = (totalSecondsRead / numberOfSessions);

      // Update document with our updated map
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
            'userStats': userStats,
          });

    } catch (e) {
        print("setAvgLengthOfSessions failed: $e");
        return;
    }
  }

  // Update total seconds read
  static Future<void> setTotalSecondsRead(int seconds) async {
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
          .update({
            'userStats': userStats,
          });
      
    } catch (e) {
      print("Error updating reading stats: $e");
    }
  } // setTotalSecondsRead() end

  // Increment # of sessions by 1 
  static Future<void> setNumberOfSessions() async {
    // Use Firebase Auth to grab current user
    final user = FirebaseAuth.instance.currentUser;

    if(user == null) {
      print("user == null... returning"); 
      return;
    }


    try {
      // Get snapshot
      final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid) 
        .get();
      
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
        .update({
          'userStats': userStats,
        });
    } catch (e) {
      print("Error updating totalSessions: $e");
    }
  } // updateNumberOfSessions() end

  // static Future<void> storeSession(Session session) async {

  // }
}
/* 
  user fields
  totalSecondsRead:
  numberOfSessions:
  avgLengthOfSessions:
  streak:
  Session sessions: 
 */