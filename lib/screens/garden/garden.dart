import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GardenPage extends StatefulWidget {
  @override
  _GardenPageState createState() => _GardenPageState();
}

class _GardenPageState extends State<GardenPage> {
  int totalBooks = 0;
  int totalSecondsRead = 0;
  int numberOfSessions = 0;
  int levelsAchieved = 0;
  int currentLevel = 1;
  int currentSublevel = 0;
  double averageSessionLength = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      final userData = await userRef.get();

      if (userData.exists) {
        setState(() {
          totalBooks = userData.data()?['totalBooksInLibrary'] ?? 0;
          totalSecondsRead = userData.data()?['totalSecondsRead'] ?? 0;
          numberOfSessions = userData.data()?['numberOfSessions'] ?? 0;
          levelsAchieved = userData.data()?['levelsAchieved'] ?? 0;
          currentLevel = userData.data()?['currentLevel'] ?? 1;
          currentSublevel = userData.data()?['currentSublevel'] ?? 0;
          averageSessionLength =
              numberOfSessions > 0 ? totalSecondsRead / numberOfSessions : 0;
        });
      }
      await checkLevelProgress();
    }
  }

  /// Function to check and update level progress
  Future<void> checkLevelProgress() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      // Each sublevel requires 5 minutes (300 seconds) of reading
      const int secondsPerSublevel = 300;
      const int maxSublevel = 4;
      const int maxLevel = 3;

      int newLevel = currentLevel;
      int newSublevel = currentSublevel;

      // Calculate the total sublevels completed
      int sublevelsCompleted = totalSecondsRead ~/ secondsPerSublevel;

      // Update the current level and sublevel based on reading time
      newLevel = 1 + sublevelsCompleted ~/ maxSublevel;
      newSublevel = sublevelsCompleted % maxSublevel;

      // Cap at the maximum level (win condition)
      if (newLevel > maxLevel) {
        newLevel = maxLevel;
        newSublevel = maxSublevel;
      }

      // Check if there's a change in the level or sublevel
      if (newLevel != currentLevel || newSublevel != currentSublevel) {
        setState(() {
          currentLevel = newLevel;
          currentSublevel = newSublevel;
        });

        // Update Firestore with the new level and sublevel
        await userRef.update({
          'currentLevel': currentLevel,
          'currentSublevel': currentSublevel,
          'levelsAchieved': currentLevel - 1 // Count fully grown plants
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Garden'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildPlantSection(),
            SizedBox(height: 20),
            _buildStatistics(),
          ],
        ),
      ),
    );
  }

  // Method to display the plant growth levels
  Widget _buildPlantSection() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildPlantPlaceholder(
              level: 1, sublevel: levelsAchieved >= 1 ? 4 : 0),
          _buildPlantPlaceholder(
              level: 2, sublevel: levelsAchieved >= 2 ? 4 : 0),
          _buildPlantPlaceholder(
              level: 3, sublevel: levelsAchieved >= 3 ? 4 : 0),
        ],
      ),
    );
  }

  Widget _buildPlantPlaceholder({required int level, required int sublevel}) {
    String label = "Level $level, Sublevel $sublevel";
    return Container(
      width: 100,
      height: 150,
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.green, width: 2),
      ),
      child: Center(
        child: Text(label, textAlign: TextAlign.center),
      ),
    );
  }

  // Method to display user statistics
  Widget _buildStatistics() {
    return Expanded(
      child: ListView(
        children: [
          _buildStatItem('Total Books in Library', totalBooks),
          _buildStatItem('Total Seconds Read', totalSecondsRead),
          _buildStatItem('Number of Sessions', numberOfSessions),
          _buildStatItem('Average Session Length',
              averageSessionLength.toStringAsFixed(2) + ' seconds'),
          _buildStatItem('Levels Achieved', levelsAchieved),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, dynamic value) {
    return ListTile(
      title: Text(label),
      trailing: Text(value.toString()),
    );
  }
}
