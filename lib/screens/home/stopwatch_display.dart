import 'dart:async';
import 'package:flutter/material.dart';

class StopwatchDisplay extends StatefulWidget {
  const StopwatchDisplay({super.key});

  @override
  _StopwatchDisplayState createState() => _StopwatchDisplayState();
}

class _StopwatchDisplayState extends State<StopwatchDisplay> {
  String hoursString = "00", minuteString = "00", secondString = "00";
  int hours = 0, minutes = 0, seconds = 0;
  bool isTimerRunning = false, isResetButtonVisible = false;
  Timer? _timer;

  void startTimer() {
    setState(() {
      isTimerRunning = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _startSecond();
    });
  }

  void pauseTimer() {
    _timer?.cancel();
    setState(() {
      isTimerRunning = false;
    });
    isResetButtonVisible = checkValues();
  }

  void resetTimer() {
    _timer?.cancel();
    setState(() {
      seconds = minutes = hours = 0;
      secondString = minuteString = hoursString = "00";
      isResetButtonVisible = false;
    });
  }

  bool checkValues() => seconds != 0 || minutes != 0 || hours != 0;

  void _startSecond() {
    setState(() {
      if (seconds < 59) {
        seconds++;
        secondString = seconds.toString().padLeft(2, '0');
      } else {
        _startMinute();
      }
    });
  }

  void _startMinute() {
    setState(() {
      if (minutes < 59) {
        seconds = 0;
        secondString = "00";
        minutes++;
        minuteString = minutes.toString().padLeft(2, '0');
      } else {
        _startHour();
      }
    });
  }

  void _startHour() {
    setState(() {
      seconds = minutes = 0;
      secondString = minuteString = "00";
      hours++;
      hoursString = hours.toString().padLeft(2, '0');
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "$hoursString:$minuteString:$secondString",
            style: const TextStyle(fontSize: 50, fontWeight: FontWeight.w500),
          ),
          ElevatedButton(
            onPressed: () {
              if (isTimerRunning) {
                pauseTimer();
              } else {
                startTimer();
              }
            },
            child: Text(isTimerRunning ? "Pause" : "Start"),
          ),
          if (isResetButtonVisible)
            ElevatedButton(
              onPressed: resetTimer,
              child: const Text("Reset"),
            ),
        ],
      ),
    );
  }
}
