import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LevelStats {
  static const int secondsPerSublevel = 20; // 5 minutes = 300 seconds
  static const int maxSublevel = 4; // 4 sublevels per level
  static const int maxLevel = 3; // Maximum number of levels
  static const int maxLevelCounter = 11; // 0-11 for levelCounter

  /// Fetch garden stats and return them as a map
  static Future<Map<String, dynamic>> getlevelStats() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("User is null, cannot fetch garden stats");
      return {
        'message': "Start reading to view your stats",
      };
    }

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        print("User document does not exist");
        return {
          'message': "Start reading to view your stats",
        };
      }

      final userStats =
          Map<String, dynamic>.from(userDoc.data()?['userStats'] ?? {});
      final totalSecondsRead = (userStats['totalSecondsRead'] ?? 0) as int;
      final numberOfSessions = (userStats['numberOfSessions'] ?? 0) as int;
      final bookCount =
          (userDoc.data()?['userLibraryStats']?['bookCount'] ?? 0) as int;

      // If no books and no seconds read, show the "Start reading" message
      if (totalSecondsRead == 0 && bookCount == 0) {
        return {
          'message': "Start reading to view your stats",
        };
      }

      // Safely calculate average session length as a double
      final avgLengthOfSessions = numberOfSessions > 0
          ? totalSecondsRead / numberOfSessions.toDouble()
          : 0.0;

      // Calculate levelCounter and levelsAchieved
      int totalSublevelsCompleted = totalSecondsRead ~/ secondsPerSublevel;
      int levelCounter = totalSublevelsCompleted > maxLevelCounter
          ? maxLevelCounter
          : totalSublevelsCompleted;
      int fullLevelsAchieved = levelCounter ~/ maxSublevel;

      // Save levelCounter and levelsAchieved to Firestore if they have changed
      final levelStats =
          Map<String, dynamic>.from(userDoc.data()?['levelStats'] ?? {});
      final storedLevelCounter = levelStats['levelCounter'] ?? 0;
      final storedLevelsAchieved = levelStats['levelsAchieved'] ?? 0;

      if (levelCounter != storedLevelCounter ||
          fullLevelsAchieved != storedLevelsAchieved) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'levelStats': {
            'levelCounter': levelCounter,
            'fullLevelsAchieved': fullLevelsAchieved,
          },
        }, SetOptions(merge: true));
      }

      return {
        'bookCount': bookCount,
        'totalSecondsRead': totalSecondsRead,
        'avgLengthOfSessions': avgLengthOfSessions,
        'numberOfSessions': numberOfSessions,
        'fullLevelsAchieved': fullLevelsAchieved,
        'levelCounter': levelCounter,
      };
    } catch (e) {
      print("Error fetching garden stats: $e");
      return {
        'message': "An error occurred. Please try again.",
      };
    }
  }
}
