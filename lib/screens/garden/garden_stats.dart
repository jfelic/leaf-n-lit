import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GardenLogic {
  // Constants for level progression
  static const int secondsPerSublevel = 300; // 5 minutes = 300 seconds
  static const int maxSublevel = 4; // 4 sublevels per level
  static const int maxLevel = 3; // Maximum number of levels
  static const int maxLevelCounter =
      11; // 0-11 for levelCounter (winning condition)

  /// Update the user's levelCounter, currentLevel, and currentSublevel
  static Future<void> updateGardenLogic() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("User is null, cannot update garden progress");
      return;
    }

    try {
      // Fetch the user's Firestore document
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        print("User document does not exist");
        return;
      }

      // Fetch the `userStats` map from the document
      final Map<String, dynamic> userStats =
          Map<String, dynamic>.from(userDoc.data()?['userStats'] ?? {});

      // Get the totalSecondsRead
      int totalSecondsRead = (userStats['totalSecondsRead'] ?? 0) as int;

      // Calculate the total number of sublevels completed
      int totalSublevelsCompleted = totalSecondsRead ~/ secondsPerSublevel;

      // Calculate the levelCounter (0-11, capped at maxLevelCounter)
      int levelCounter = totalSublevelsCompleted;
      if (levelCounter > maxLevelCounter) {
        levelCounter = maxLevelCounter; // Cap at the maximum
      }

      // Derive currentLevel and currentSublevel from levelCounter
      int currentLevel = (levelCounter ~/ maxSublevel) + 1; // 1-based level
      int currentSublevel = levelCounter % maxSublevel;

      // Ensure levels do not exceed maximums
      if (currentLevel > maxLevel) {
        currentLevel = maxLevel;
        currentSublevel = maxSublevel - 1; // Last sublevel in max level
      }

      // Get the current levelCounter from Firestore for comparison
      int storedLevelCounter =
          (userDoc.data()?['gardenStats']?['levelCounter'] ?? 0) as int;

      // Update Firestore only if levelCounter has changed
      if (levelCounter != storedLevelCounter) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'gardenStats': {
            'levelCounter': levelCounter,
            'currentLevel': currentLevel,
            'currentSublevel': currentSublevel,
            'hasWon':
                levelCounter == maxLevelCounter, // Indicate if the user has won
          }
        }, SetOptions(merge: true));

        print(
            "Garden progress updated: LevelCounter $levelCounter, Level $currentLevel, Sublevel $currentSublevel");
      } else {
        print("No changes to garden progress");
      }
    } catch (e) {
      print("Error updating garden progress: $e");
    }
  }
}
