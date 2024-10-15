import 'package:flutter/material.dart';
import 'widgets/nav_bar.dart'; // Import your custom nav bar widget
import 'package:leaf_n_lit/screens/library/library.dart'; // Import the Library Page

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leaf n\' Lit',
      theme: ThemeData(
        useMaterial3: true, // Enable Material 3
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Center(child: Text('Home')),
    Center(child: Text('Garden')),
    LibraryPage(), // Use LibraryPage instead of placeholder
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaf n\' Lit'),
      ),
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
