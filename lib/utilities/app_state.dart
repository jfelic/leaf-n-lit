import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  // Firebase Auth State
  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  // App-wide State
  int stopwatchHours = 1;
  int stopwatchMinutes = 45; 

  // Methods for Session
  // Update stopwatchHour based on user's session length
  void updateStopwatchHours(double newStopwatchHours) {
    stopwatchHours = newStopwatchHours.toInt();
    notifyListeners();
  }

  // Update stopwatchHour based on user's session length
  void updateStopwatchMinutes(double newStopwatchMinutes) {
    stopwatchMinutes = newStopwatchMinutes.toInt();
    notifyListeners();
  }


  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    FirebaseAuth.instance.userChanges().listen((user) {
      _loggedIn = user != null;
      notifyListeners();
    });
  }
}
