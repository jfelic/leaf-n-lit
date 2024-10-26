import 'package:flutter/material.dart';
import 'package:leaf_n_lit/utilities/auth_service.dart';
import 'package:go_router/go_router.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  // Create text controllers to retrieve the text entered by the user
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  } // dispose()

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            
            // Name
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'First Name',
              ),
              obscureText: false,
              keyboardType: TextInputType.text,
              maxLength: 35,
              controller: nameController,
            ),

            // const SizedBox(height: 16.0),

            // Email
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
              obscureText: false,
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
            ),

            const SizedBox(height: 16.0),

            // Password
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
              obscureText: true,
              controller: passwordController,
            ),

            const SizedBox(height: 16.0),

            // Confirm Password
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Confirm Password',
              ),
              obscureText: true,
              controller: confirmPasswordController,
            ),

            const SizedBox(height: 16.0),

            // Register button
            ElevatedButton(
              onPressed: registerPressed,
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }

  void registerPressed() async {
    // TODO: Implement registration logic with Firebase Auth
    // - Display an error message if something goes wrong
    print('Register button pressed');
    String email = emailController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    if(password != confirmPassword) {
      print('Passwords do not match');
      return;
    }

    AuthService authService = AuthService();

    // await the result of the createUserWithEmailAndPassword method
    String? createUserWithEmailAndPasswordResult = await authService.createUserWithEmailAndPassword(email, password);

    if(createUserWithEmailAndPasswordResult == null) {
      // Registration was successful
      GoRouter.of(context).go('/home');
    } else {
      // Registration failed
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Registration Failed'),
          content: Text(createUserWithEmailAndPasswordResult),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}