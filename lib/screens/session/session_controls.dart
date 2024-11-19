// This widget is being used in session.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:leaf_n_lit/utilities/app_state.dart';
import 'package:leaf_n_lit/utilities/user_stats.dart';

class SessionControls extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    ApplicationState appState = Provider.of<ApplicationState>(context);


    switch(appState.sessionState) {
      case SessionState.inactive:
        return ElevatedButton(
          onPressed: () {
            if(appState.stopwatchHours == 0 && appState.stopwatchMinutes == 0) 
            {
              print("Start session input invalid");
              return;
            } 
            else 
            {
              appState.startSession(); 
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 81, 152, 60),
          ),
          child: const Text(
            'Start Session',
            style: TextStyle(
              color: Colors.white,
            )
          ),
        );

      case SessionState.active:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                appState.pauseSession();
              },
              child: const Icon(Icons.pause),
            ),

            SizedBox(width: 16),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 255, 95, 71),
              ),
              onPressed: () async {
                int secondsRead = appState.initialSeconds - appState.totalSeconds;
                print("Initial seconds: ${appState.initialSeconds}");
                print("Total seconds: ${appState.totalSeconds}");
                print("Seconds read: $secondsRead");

                appState.stopSession();

                // Using await as to not call all 3 methods simultaneously and cause a race condition
                await UserStats.setTotalSecondsRead(secondsRead);
                await UserStats.setNumberOfSessions();
                await UserStats.setAvgLengthOfSessions();

              },
              child: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
            
          ],
        );

      case SessionState.paused:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                appState.resumeSession();
              },
              child: const Icon(Icons.play_arrow),
            ),

            const SizedBox(width: 16),

            ElevatedButton(
              onPressed: () {
                appState.stopSession();
              },
              child: const Icon(Icons.close),
            ),
            
          ],
        );
      }
    }
  }