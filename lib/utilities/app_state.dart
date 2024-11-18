// app_state.dart
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:flutter/material.dart';
import 'package:leaf_n_lit/utilities/user_stats.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:leaf_n_lit/main.dart';

enum SessionState {
  active,
  inactive,
  paused
}

class ApplicationState extends ChangeNotifier {
  Timer? _inactivityTimer;
  final int _sessionTimeout = 900; // 15 minutes in seconds

  ApplicationState() {
    print('ApplicationState initialized');
    FirebaseAuth.instance.userChanges().listen((user) {
      _loggedIn = user != null;
      print('Auth state changed - User logged in: $_loggedIn');
      if (_loggedIn) {
        print('Starting inactivity timer for logged in user');
        resetInactivityTimer();
      }
      notifyListeners();
    });
  }

  // Firebase Auth State
  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  // App-wide State fields
  int stopwatchHours = 0;
  int stopwatchMinutes = 0;
  int totalSeconds = 0;
  int initialSeconds = 0;
  SessionState sessionState = SessionState.inactive;

  // Timer related fields
  Timer? _sessionTimer;

  void resetInactivityTimer() {
    print('Resetting inactivity timer');
    _inactivityTimer?.cancel();
    if (_loggedIn) {
      print('Starting new inactivity timer for $_sessionTimeout seconds');
      _inactivityTimer = Timer(Duration(seconds: _sessionTimeout), () {
        print('Inactivity timer expired - logging out user');
        signOut();
      });
    } else {
      print('User not logged in - no inactivity timer started');
    }
  }

  // Start the Timer
  void startSession() {
    print('Starting reading session');
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
      if (totalSeconds <= 60) {
        print('Reading session timer finished');
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
  }

  // Pause the session
  void pauseSession() {
    print('Pausing reading session');
    sessionState = SessionState.paused;
    notifyListeners();
  }

  // Resume the session after pausing
  void resumeSession() {
    print('Resuming reading session');
    sessionState = SessionState.active;
    notifyListeners();
  }

  // Stop the session
  void stopSession() {
    print('Stopping reading session');
    sessionState = SessionState.inactive;
    _sessionTimer?.cancel();
    stopwatchHours = 0;
    stopwatchMinutes = 0;
    notifyListeners();
  }

  // Handle the end of a session
  void _onSessionComplete() {
    print("Reading session complete!");
    stopwatchHours = 0;
    stopwatchMinutes = 0;
    UserStats.updateTotalSecondsRead(initialSeconds);
    sessionState = SessionState.inactive;
    notifyListeners();
  }

  // Convert hours and minutes to seconds
  int convertHoursMinutestoSeconds(int hours, int minutes) {
    if (hours == 0 && minutes == 0) {
      return 0;
    }
    int hoursToSeconds = hours * 3600;
    int minutesToSeconds = minutes * 60;
    int totalSeconds = hoursToSeconds + minutesToSeconds + 59;
    print('Converting time: $hours hours and $minutes minutes to $totalSeconds seconds');
    return totalSeconds;
  }

  // Update stopwatchHour based on user's session length
  void updateStopwatchHours(double newStopwatchHours) {
    print('Updating stopwatch hours to: $newStopwatchHours');
    stopwatchHours = newStopwatchHours.toInt();
    notifyListeners();
  }

  // Update stopwatchHour based on user's session length
  void updateStopwatchMinutes(double newStopwatchMinutes) {
    print('Updating stopwatch minutes to: $newStopwatchMinutes');
    stopwatchMinutes = newStopwatchMinutes.toInt();
    notifyListeners();
  }

Future<void> signOut() async {
  print('Signing out user');
  _inactivityTimer?.cancel();
  await FirebaseAuth.instance.signOut();
  print('User signed out successfully');
  
  // Use the GoRouter.of method with the root navigator key
  if (rootNavigatorKey.currentContext != null) {
    print('Redirecting to login screen');
    GoRouter.of(rootNavigatorKey.currentContext!).go('/login');
  }
}

  @override
  void dispose() {
    print('Disposing ApplicationState');
    _inactivityTimer?.cancel();
    _sessionTimer?.cancel();
    super.dispose();
  }
}
