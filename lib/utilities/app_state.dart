// TODO: Extract Timer from this file to make it less of a monolith

import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:flutter/material.dart';
import 'package:leaf_n_lit/utilities/user_stats.dart';
import 'dart:async';

enum SessionState {
  active,
  inactive,
  paused
}

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    // Listen to auth state changes
    FirebaseAuth.instance.userChanges().listen((user) {
      _loggedIn = user != null;
      notifyListeners();
    });
  }

  // Firebase Auth State (I believe this is being used in library.dart)
  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  // App-wide State fields
  int stopwatchHours = 1;
  int stopwatchMinutes = 45; 
  int totalSeconds = 0;
  int initialSeconds = 0;
  SessionState sessionState = SessionState.inactive;


  // Timer related fields
  Timer? _sessionTimer;

  // Start the Timer
  void startSession() {
    sessionState = SessionState.active;
    notifyListeners();
    // Cancel any existing timers
    _sessionTimer?.cancel();

    // Convert stopwatchHours and stopwatchMinutes to seconds:
    totalSeconds = convertHoursMinutestoSeconds(stopwatchHours, stopwatchMinutes);
    initialSeconds = convertHoursMinutestoSeconds(stopwatchHours, stopwatchMinutes);

    // Create timer
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      print('Timer ticked');

      if(totalSeconds <= 60) { // Timer is finished because we add 60 at the start
        _sessionTimer?.cancel(); // Cancel timer
        _onSessionComplete(); // handle session completion
      } else {
        stopwatchHours = totalSeconds ~/ 3600;
        print("stopwatchHours: $stopwatchHours");

        stopwatchMinutes = (totalSeconds % 3600) ~/ 60; 
        print("stopwatchMinutes: $stopwatchMinutes");

        print("Seconds left: $totalSeconds");
        totalSeconds -= 1; // Decrement total seconds
        notifyListeners(); // Notify UI of changes
      }
    });
  } // End of Timer

  // Pause the session
  void pauseSession() {
    sessionState = SessionState.paused;
    notifyListeners();
    // TODO: Find a way to pause session without completely cancelling
  } // pauseSession() end

  // Resume the session after pausing
  void resumeSession() {
    sessionState = SessionState.active;
    notifyListeners();
  } // resumeSession() end

  // Stop the session
  void stopSession() {
    sessionState = SessionState.inactive;
    _sessionTimer?.cancel();
    stopwatchHours = 0;
    stopwatchMinutes = 0;
    UserStats.updateTotalSecondsRead(initialSeconds);
    notifyListeners();
  } // stopSession() end

  // Handle the end of a session
  void _onSessionComplete() {
    // TODO: Handle when the session ends
    print("Session Complete!");
    stopwatchHours = 0;
    stopwatchMinutes = 0;
    sessionState = SessionState.inactive;
    notifyListeners();
  } // _onSessionComplete() end

  // Convert hours and minutes to seconds
  int convertHoursMinutestoSeconds (int hours, int minutes) {
    if(hours == 0 && minutes == 0) { // early return if there's not time on the clock
      return 0;
    }

    int hoursToSeconds = hours * 3600;
    int minutesToSeconds = minutes * 60;
    return hoursToSeconds + minutesToSeconds + 59; //Adding 59 seconds to not truncate immediatedly
  } // convertHoursMinutesToSeconds() end

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
}
