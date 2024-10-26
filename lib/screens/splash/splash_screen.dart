import 'package:flutter/material.dart'; // Import Flutter's core material library for UI components.
import 'package:go_router/go_router.dart'; // Import GoRouter for navigation.

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState(); // Create the state for SplashScreen.
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller; // Controller for managing the animation.
  late Animation<Color?> _animation; // The animation that controls the background color change.

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController with a duration of 2 seconds.
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Define a color transition animation (ColorTween) from light green to green.
    _animation = ColorTween(
      begin: Colors.lightGreen,
      end: Colors.green,
    ).animate(_controller);

    _controller.forward(); // Start the animation.

    // Use a delay to automatically navigate to the Home Page after 3 seconds.
    Future.delayed(const Duration(seconds: 5), () {
      // Use GoRouter to navigate to the home screen
      context.go('/home');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/leaf_n_lit_logo.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20.0),
            const Text(
              "Leaf n' Lit",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 69, 126, 212),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: _animation.value, // Set the background color to match the animation.
    );
  }
}




