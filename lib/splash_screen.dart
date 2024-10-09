// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart'; // Import Flutter's core material library for UI components.

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  // The SplashScreen is a StatefulWidget because we want to manage animation states.
  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState(); // Create the state for SplashScreen.
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  // This class manages the state of the SplashScreen, including animations.
  late AnimationController _controller; // Controller for managing the animation.
  late Animation<Color?> _animation; // The animation that controls the background color change.

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController with a duration of 2 seconds.
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // Sets the length of the animation.
      vsync: this, // The vsync parameter prevents offscreen animations to save resources.
    );

    // Define a color transition animation (ColorTween) from light green to green.
    _animation = ColorTween(
      begin: Colors.lightGreen, // Start color is light green.
      end: Colors.green, // End color is dark green.
    ).animate(_controller); // Attach the animation to the controller.

    _controller.forward(); // Start the animation.

    // Use a delay to automatically navigate to the Home Page after 3 seconds.
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/home'); // Navigate to the home screen after 3 seconds.
    });
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is removed to prevent memory leaks.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build the UI for the Splash screen.
    return Scaffold(
      body: Center(
        // Center the content of the screen.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Vertically center the children.
          children: [
            // A simple placeholder for a book logo using a Container widget.
            Container(
              height: 100, // set height of the container.
              width: 100, // set width of the container.
              decoration: const BoxDecoration(
                shape: BoxShape.rectangle, // use a rectangular box shape.
                color: Colors.white, // set the box color to white.
              ),
              child: const Center(
                child: Icon(
                  Icons.book, // simple book icon from the default flutter icons.
                  size: 60, // size of the icon.
                  color: Colors.green, // color of the book icon.
                ),
              ),
            ),
            const SizedBox(height: 20.0), // Add space between the book icon and text.

            // Display the name of your app under the icon.
            Text(
              'Leaf & Lit', // Text label for the app.
              style: TextStyle(
                fontSize: 24.0, // Font size set to 24.
                fontWeight: FontWeight.bold, // Make the text bold.
                color: _animation.value, // Set text color to follow the animation's current color.
              ),
            ),
          ],
        ),
      ),
      backgroundColor: _animation.value, // Set the background color of the Scaffold to match the animation.
    );
  }
}



