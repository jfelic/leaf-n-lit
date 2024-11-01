  import 'package:flutter/material.dart';
  import 'package:go_router/go_router.dart';
  import 'package:provider/provider.dart';
  import 'package:leaf_n_lit/screens/home/stopwatch_display.dart';
  import 'package:leaf_n_lit/utilities/app_state.dart';

  class SessionPage extends StatefulWidget {
    const SessionPage({Key? key}) : super(key: key);

    @override
    State<SessionPage> createState() => _SessionPageState();
  }

  class _SessionPageState extends State<SessionPage> {
    @override
    Widget build(BuildContext context) {

      ApplicationState appState = Provider.of<ApplicationState>(context);

      return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${appState.stopwatchHours}"),

              const SizedBox(height: 16),

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
                    child: const Text("Session Duration"),
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
                ListTile(
                  leading: const Icon(Icons.timer),
                  title: const Text('Session Duration'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),

                const SizedBox(height: 16),

              // Hours
              Column(
                children: [
                  Text("Hours"),

                  const SizedBox(height: 16),

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
                  Text("Minutes"),
                  Consumer<ApplicationState>(
                    builder: (context, appState, child) {
                      return Slider(
                        value: appState.stopwatchMinutes.toDouble(),
                        onChanged: (newStopwatchMinutes) {
                          appState.updateStopwatchMinutes(newStopwatchMinutes);
                        },
                        divisions: 12, // 5-minute intervals
                        label: "${appState.stopwatchMinutes}",
                        max: 60,
                        min: 0,
                      );
                    }
                  ),
                ],
              ),
                const SizedBox(height: 100),
              ],
            ),
          );
        },
      );
    }
  }