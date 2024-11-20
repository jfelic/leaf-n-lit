// lib/widgets/garden_game.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:leaf_n_lit/utilities/app_state.dart';

class GardenGame extends StatefulWidget {
  const GardenGame({Key? key}) : super(key: key);

  @override
  _GardenGameState createState() => _GardenGameState();
}

class _GardenGameState extends State<GardenGame> {
  int _currentStage = 0;
  int _fullLevelsAchieved = 0;

  @override
  void initState() {
    super.initState();
    _initializeGrowth();
  }

  void _initializeGrowth() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final levelStats =
          Map<String, dynamic>.from(docSnapshot.data()?['levelStats'] ?? {});
      setState(() {
        _currentStage = levelStats['levelCounter'] ?? 0;
        _fullLevelsAchieved = levelStats['fullLevelsAchieved'] ?? 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, child) {
        if (appState.sessionState == SessionState.active) {
          _updateGrowth(appState.totalSeconds);
        }

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildPlantSlot(0),
                  const SizedBox(width: 20),
                  _buildPlantSlot(1),
                  const SizedBox(width: 20),
                  _buildPlantSlot(2),
                ],
              ),
              const SizedBox(height: 20),
              if (_fullLevelsAchieved >= 3)
                const Text(
                  'You Win!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
            ],
          ),
        );
      },
    );
  }

  void _updateGrowth(int totalSecondsRead) {
    int newStage = totalSecondsRead ~/ 20;
    if (newStage > 11) {
      newStage = 11;
      _fullLevelsAchieved = (totalSecondsRead ~/ 20) ~/ 12;
    }
    if (newStage != _currentStage) {
      setState(() {
        _currentStage = newStage;
      });
      _saveProgress();
    }
  }

  void _saveProgress() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'levelStats': {
          'levelCounter': _currentStage,
          'fullLevelsAchieved': _fullLevelsAchieved,
        },
      }, SetOptions(merge: true));
    }
  }

  Widget _buildPlantSlot(int index) {
    return Container(
      width: 100,
      height: 150,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(8),
      ),
      child: _currentStage >= index * 4
          ? Image.asset('assets/level_images/${_currentStage - index * 4}.png')
          : const SizedBox.shrink(),
    );
  }
}
