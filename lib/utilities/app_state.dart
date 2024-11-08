import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'dart:async';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  // Firebase Auth State
  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  // App-wide State fields
  int stopwatchHours = 1;
  int stopwatchMinutes = 45; 

  // Timer related fields
  Timer? _sessionTimer;
  Duration _remainingTime = Duration.zero;

  Duration get remainingTime => _remainingTime;

  /* Methods for Timer */
  // Start the Timer
  void startSession() {
    final sessionDuration = Duration(hours: stopwatchHours, minutes: stopwatchMinutes);
    _remainingTime = sessionDuration;

    // Cancel any exitsting timers
    _sessionTimer?.cancel();

    // Timer will run every second
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer){
      // all of this happens every second:
      if(_remainingTime.inSeconds <= 0) { // if timer is done
        timer.cancel(); // Stop timer
        _onSessionComplete(); // Handle end of session
      } else { // timer not done yet
        _remainingTime -= const Duration(seconds: 1); // Decrement remaining time
        notifyListeners(); // Notify UI of changes
      }
    });
  }

  // Pause the session
  void pauseSession() {
    // TODO: Find a way to pause session without completely cancelling
  } // pauseSession() end

  // Stop the session
  void stopSession() {
    _sessionTimer?.cancel();
    _remainingTime = Duration.zero; // Reset remaining time
    notifyListeners();
  } // stopSession() end

  // Handle the end of a session
  // Private function
  void _onSessionComplete() {
    // TODO: Handle when the session ends
  } // _onSessionComplete() end

  /* End of methods for Timer */

  /* Methods for Session */
  // Update stopwatchHour based on user's session length
  void updateStopwatchHours(double newStopwatchHours) {
    stopwatchHours = newStopwatchHours.toInt();
    notifyListeners();
  } // updateStopwatchHours() end

  // Update stopwatchHour based on user's session length
  void updateStopwatchMinutes(double newStopwatchMinutes) {
    stopwatchMinutes = newStopwatchMinutes.toInt();
    notifyListeners();
  } // updateStopWatchMinutes() end

  /* End of methods for Session */


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
