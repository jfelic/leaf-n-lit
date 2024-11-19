import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StatisticsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(
        child: Text('User not logged in'),
      );
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        // If the document does not exist or data is null
        if (!snapshot.data!.exists || snapshot.data!.data() == null) {
          return const Center(
            child: Text(
              'Start reading to view your stats',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          );
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;

        // Handle missing fields gracefully
        int totalBooks = userData['bookCount'] ?? 0;
        int totalSecondsRead = userData['totalSecondsRead'] ?? 0;
        int numberOfSessions = userData['numberOfSessions'] ?? 0;
        double averageSessionLength =
            numberOfSessions > 0 ? totalSecondsRead / numberOfSessions : 0;
        int levelsAchieved = userData['levelsAchieved'] ?? 0;

        // If all fields are zero (user hasn't started reading)
        if (totalBooks == 0 &&
            totalSecondsRead == 0 &&
            numberOfSessions == 0 &&
            levelsAchieved == 0) {
          return const Center(
            child: Text(
              'Start reading to view your stats',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          );
        }

        return ListView(
          children: [
            _buildStatItem('Total Books in Library', totalBooks),
            _buildStatItem('Total Seconds Read', totalSecondsRead),
            _buildStatItem('Number of Sessions', numberOfSessions),
            _buildStatItem('Average Session Length',
                '${averageSessionLength.toStringAsFixed(2)} seconds'),
            _buildStatItem('Levels Achieved', levelsAchieved),
          ],
        );
      },
    );
  }

  Widget _buildStatItem(String label, dynamic value) {
    return ListTile(
      title: Text(label),
      trailing: Text(value.toString()),
    );
  }
}
