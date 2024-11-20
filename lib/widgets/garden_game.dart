// lib/widgets/garden_game.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class GardenGame extends StatefulWidget {
  const GardenGame({Key? key}) : super(key: key);

  @override
  _GardenGameState createState() => _GardenGameState();
}

class _GardenGameState extends State<GardenGame> {
  Timer? _growthTimer;
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

      _startGrowthTimer();
    }
  }

  void _startGrowthTimer() {
    _growthTimer = Timer.periodic(const Duration(seconds: 20), (timer) {
      setState(() {
        if (_currentStage < 11) {
          _currentStage++;
        } else {
          _currentStage = 0;
          _fullLevelsAchieved++;
        }
      });
      _saveProgress();
    });
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

  @override
  void dispose() {
    _growthTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
