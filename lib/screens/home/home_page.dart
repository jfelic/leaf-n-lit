import 'dart:async'; // import for the timer function
import 'package:flutter/material.dart';
import 'package:leaf_n_lit/screens/library/library.dart';
import 'package:leaf_n_lit/widgets/nav_bar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  // Stopwatch-related variables
  String hoursString = "00", minuteString = "00", secondString = "00";
  int hours = 0, minutes = 0, seconds = 0;
  bool isTimerRunning = false, isResetButtonVisible = false;
  late Timer _timer;

  // list of pages with the stopwatch as the first screen
  final List<Widget> _pages = [
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Stopwatch display
          const Text(
            "00:00:00", // Initial display
            style: TextStyle(fontSize: 50, fontWeight: FontWeight.w500),
          ),
          ElevatedButton(
            onPressed: () {}, // Placeholder for the button
            child: const Text("Start"),
          ),
        ],
      ),
    ),
    const Center(child: Text('Home')),
    const Center(child: Text('Garden')),
    LibraryPage(),
  ];

  // Start the timer function
  void startTimer() {
    setState(() {
      isTimerRunning = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _startSecond();
    });
  }

  // pause the timer
  void pauseTimer() {
    _timer.cancel();
    setState(() {
      isTimerRunning = false;
    });
    isResetButtonVisible = checkValues();
  }

  // reset the timer
  void resetTimer() {
    _timer.cancel();
    setState(() {
      seconds = 0;
      minutes = 0;
      hours = 0;
      secondString = "00";
      minuteString = "00";
      hoursString = "00";
      isResetButtonVisible = false;
    });
  }

  // see if any value is > zero to show the reset button
  bool checkValues() {
    return seconds != 0 || minutes != 0 || hours != 0;
  }

  // handle the seconds increment
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

  // handle the minutes increment
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

  // Handle the hours increment
  void _startHour() {
    setState(() {
      seconds = 0;
      minutes = 0;
      secondString = "00";
      minuteString = "00";
      hours++;
      hoursString = hours.toString().padLeft(2, '0');
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: _selectedIndex == 0
          ? _buildStopwatch() // Show the stopwatch when index is 0
          : _pages[_selectedIndex],
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  // Stopwatch UI builder
  Widget _buildStopwatch() {
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
          isResetButtonVisible
              ? ElevatedButton(
                  onPressed: resetTimer,
                  child: const Text("Reset"),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

