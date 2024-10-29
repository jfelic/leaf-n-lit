import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SessionPage extends StatefulWidget {
  const SessionPage({Key? key}) : super(key: key);

  @override
  State<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                print("Start Session Pressed");
              },
              child: const Text('Start Session'),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showSessionSettingsModal(context);
                  },
                  child: const Text("Session Settings"),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    print("Choose Plant Pressed");
                  },
                  child: const Text("Choose Plant"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSessionSettingsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Session Settings',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.timer),
                title: const Text('Duration'),
                onTap: () {
                  // Handle duration setting
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 250),
            ],
          ),
        );
      },
    );
  }
}