// This widget is being used in session.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:leaf_n_lit/utilities/app_state.dart';

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
          child: const Text('Start Session'),
        );

      case SessionState.active:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                appState.stopSession();
              },
              child: const Icon(Icons.replay),
            ),
            ElevatedButton(
              onPressed: () {
                appState.pauseSession();
              },
              child: const Icon(Icons.pause),
            ),
            ElevatedButton(
              onPressed: () {
                appState.stopSession();
              },
              child: const Icon(Icons.close),
            ),
            
          ],
        );

      case SessionState.paused:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                appState.stopSession();
              },
              child: const Icon(Icons.replay),
            ),
            ElevatedButton(
              onPressed: () {
                appState.resumeSession();
              },
              child: const Icon(Icons.play_arrow),
            ),
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