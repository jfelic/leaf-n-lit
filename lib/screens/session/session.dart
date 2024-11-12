import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:leaf_n_lit/utilities/app_state.dart';
import 'package:leaf_n_lit/screens/session/session_controls.dart';
import 'package:leaf_n_lit/screens/session/session_status_display.dart';

class SessionPage extends StatefulWidget {
  const SessionPage({Key? key}) : super(key: key);

  @override
  State<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  @override
  Widget build(BuildContext context) {

    ApplicationState appState = Provider.of<ApplicationState>(context);

    int stopwatchMinutes = appState.stopwatchMinutes;
    int stopwatchHours = appState.stopwatchHours;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${stopwatchHours.toString().padLeft(2, '0')}:${stopwatchMinutes.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            SessionControls(), // custom widget in our widget directory

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showSessionSettingsModal(context);
                  },
                  child: const Text("Session Duration"),

                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    print("'Choose Plant' button pressed");
                  },
                  child: const Text("Choose Plant"),
                ),
              ],
            ),

            const SizedBox(height: 16),

            SessionStatusDisplay(),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.timer),
                  SizedBox(width: 8),
                  Text("Session Duration"),
                ]
              ),

            SizedBox(height: 16),

            // Hours
            Column(
              children: [
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 24.0),
                      child: Text("Hours"),
                    ),
                  ],
                ),

                const SizedBox(height: 1),

                Consumer<ApplicationState>(
                  builder: (context, appState, child) {
                    return Slider(
                      value: appState.stopwatchHours.toDouble(),
                      onChanged: (newStopwatchHours) {
                        appState.updateStopwatchHours(newStopwatchHours);
                      },
                      divisions: 3,
                      label: "${appState.stopwatchHours}",
                      max: 3.0,
                      min: 0.0,
                    );
                  },
                ),

                // Minutes
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 24.0),
                      child: Text("Minutes"),
                    ),
                  ],
                ),
                const SizedBox(height: 1),
                Consumer<ApplicationState>(
                  builder: (context, appState, child) {
                    return Slider(
                      value: appState.stopwatchMinutes.toDouble(),
                      onChanged: (newStopwatchMinutes) {
                        appState.updateStopwatchMinutes(newStopwatchMinutes);
                      },
                      divisions: 11, // 5-minute intervals
                      label: "${appState.stopwatchMinutes}",
                      max: 55.0,
                      min: 0.0,
                    );
                  }
                ),

                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Save"),
                ),
              ],
            ),
              const SizedBox(height: 50),
            ],
          ),
        );
      },
    );
  }
}