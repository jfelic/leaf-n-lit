import 'package:flutter/material.dart';
import 'package:leaf_n_lit/screens/garden/garden_stats.dart';
import 'package:leaf_n_lit/widgets/garden_game.dart'; // Import the GardenGame widget

class GardenPage extends StatefulWidget {
  const GardenPage({Key? key}) : super(key: key);

  @override
  _GardenPageState createState() => _GardenPageState();
}

class _GardenPageState extends State<GardenPage> {
  late Future<Map<String, dynamic>> levelStats;

  @override
  void initState() {
    super.initState();
    levelStats = LevelStats.getlevelStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Garden"),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: levelStats,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError || !snapshot.hasData) {
            return const Center(
              child: Text("An error occurred. Please try again."),
            );
          }

          final stats = snapshot.data!;
          if (stats.containsKey('message')) {
            return Center(
              child: Text(
                stats['message'],
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }

          // Extract stats
          final bookCount = stats['bookCount'] as int;
          final totalSecondsRead = stats['totalSecondsRead'] as int;
          final avgLengthOfSessions = stats['avgLengthOfSessions'] as double;
          final numberOfSessions = stats['numberOfSessions'] as int;
          final fullLevelsAchieved = stats['fullLevelsAchieved'] as int;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildStatItem("Total Books Read", bookCount.toString()),
              _buildStatItem("Total Number of Seconds Read", totalSecondsRead.toString()),
              _buildStatItem("Average Length of Session", "${avgLengthOfSessions.toStringAsFixed(2)} seconds"),
              _buildStatItem("Total Number of Sessions", numberOfSessions.toString()),
              _buildStatItem("Plants Reaching Highest Sublevel", fullLevelsAchieved.toString()),
              const SizedBox(height: 20),
              const GardenGame(), // Add the GardenGame widget here to display the garden
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return ListTile(
      title: Text(label),
      trailing: Text(value),
    );
  }
}

