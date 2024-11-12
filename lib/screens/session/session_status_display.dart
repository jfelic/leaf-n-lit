// This widget is being used in session.dart
// Text display based on state of session to inform the user

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:leaf_n_lit/utilities/app_state.dart';

class SessionStatusDisplay extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    ApplicationState appState = Provider.of<ApplicationState>(context);

    switch(appState.sessionState) {
      case SessionState.active:
        return const Text(
          "Session is active :)",
          style: TextStyle(fontWeight: FontWeight.bold),
        );

      case SessionState.inactive:
        return const Text(
          "No active session :(",
          style: TextStyle(fontWeight: FontWeight.bold),
        );

      case SessionState.paused:
        return const Text(
          "Session is paused...",
          style: TextStyle(fontWeight: FontWeight.bold),
        );
    }
  }
}