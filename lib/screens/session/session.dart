    // TODO: Create timer based on what the user inputs.
    // Can use Timer class I think
    
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
                Text(stopwatchMinutes >= 10
                  // If stopwatchMinutes >= 10: 
                  ? "${appState.stopwatchHours}:${appState.stopwatchMinutes}"
                  // else: 
                  : "$stopwatchHours:0$stopwatchMinutes"
                ),


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
                  const SizedBox(height: 100),
                ],
              ),
            );
          },
        );
      }
    }