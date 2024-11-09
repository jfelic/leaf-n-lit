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
  int totalSeconds = 0;
  bool isSessionActive = false;

  // Timer related fields
  Timer? _sessionTimer;

  // Start the Timer
  void startSession() {
    isSessionActive = true;
    // Cancel any existing timers
    _sessionTimer?.cancel();

    // Convert stopwatchHours and stopwatchMinutes to seconds:
    totalSeconds = convertHoursMinutestoSeconds(stopwatchHours, stopwatchMinutes);

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
    // TODO: Find a way to pause session without completely cancelling
  } // pauseSession() end

  // Stop the session
  void stopSession() {
    isSessionActive = false;
    _sessionTimer?.cancel();
    stopwatchHours = 0;
    stopwatchMinutes = 0;
    notifyListeners();
  } // stopSession() end

  // Handle the end of a session
  void _onSessionComplete() {
    // TODO: Handle when the session ends
    print("Session Complete!");
    stopwatchHours = 0;
    stopwatchMinutes = 0;
    isSessionActive = false;
    notifyListeners();
  } // _onSessionComplete() end

  // Convert hours and minutes to seconds
  int convertHoursMinutestoSeconds (int hours, int minutes) {
    if(hours == 0 && minutes == 0) { // early return if there's not time on the clock
      return 0;
    }

    int hoursToSeconds = hours * 3600;
    int minutesToSeconds = minutes * 60;

    print("Total seconds: ${hoursToSeconds + minutesToSeconds}");
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
