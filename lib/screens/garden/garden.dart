import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:leaf_n_lit/widgets/statistics.dart';

class GardenPage extends StatefulWidget {
  @override
  _GardenPageState createState() => _GardenPageState();
}

class _GardenPageState extends State<GardenPage> {
  int totalSecondsRead = 0;
  int currentLevel = 1;
  int currentSublevel = 0;
  int levelsAchieved = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  /// Fetch user data from Firestore and check level progression
  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      final userData = await userRef.get();

      if (userData.exists) {
        setState(() {
          totalSecondsRead = userData.data()?['totalSecondsRead'] ?? 0;
          currentLevel = userData.data()?['currentLevel'] ?? 1;
          currentSublevel = userData.data()?['currentSublevel'] ?? 0;
          levelsAchieved = userData.data()?['levelsAchieved'] ?? 0;
        });
      }

      // Update level progress
      await _checkLevelProgress(userRef);
    }
  }

  // Check and update level progression
  Future<void> _checkLevelProgress(DocumentReference userRef) async {
    const int secondsPerSublevel = 300; // 5 minutes per sublevel
    const int maxSublevel = 4;
    const int maxLevel = 3;

    // Calculate total sublevels completed
    int sublevelsCompleted = totalSecondsRead ~/ secondsPerSublevel;

    // Determine new level and sublevel
    int newLevel = (sublevelsCompleted ~/ maxSublevel) + 1;
    int newSublevel = sublevelsCompleted % maxSublevel;

    // Cap at maximum level and sublevel
    if (newLevel > maxLevel) {
      newLevel = maxLevel;
      newSublevel = maxSublevel;
    }

    // Update Firestore only if levels have changed
    if (newLevel != currentLevel || newSublevel != currentSublevel) {
      setState(() {
        currentLevel = newLevel;
        currentSublevel = newSublevel;
        levelsAchieved = currentLevel - 1;
      });

      await userRef.update({
        'currentLevel': currentLevel,
        'currentSublevel': currentSublevel,
        'levelsAchieved': levelsAchieved,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Garden'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Level Progression Calculation Only',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StatisticsWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
