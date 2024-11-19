import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leaf_n_lit/utilities/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // Image.asset('assets/tree.png'),
 
            const SizedBox(height: 16.0),

            // Enter email
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 16.0),

            // Enter password
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),

            const SizedBox(height: 20.0),

            // Login button
            ElevatedButton(
              onPressed: () { loginPressed(context); },
              child: const Text('Login'),
            ),

            const SizedBox(height: 20.0),

            // Don't have an account? Create one
            TextButton(
            onPressed:()  {
              GoRouter.of(context).push('/register');
            }, 
            child: RichText(text: TextSpan(
              text: "Don't have an account? ",
              style: GoogleFonts.breeSerif(color: Colors.black),
              children: const <TextSpan>[
                TextSpan(
                  text: 'Register',
                  style: TextStyle(color: Color.fromARGB(255, 55, 126, 57)),
                    ),
                  ],
                ),
              )
            ),

            // Display error message
            Center(
              child: Text(
                _errorMessage ?? '',
                style: const TextStyle(color: Colors.red),
              )
            ),

            const SizedBox(height: 16.0),

            // TODO: Implement 'Forgot Password' functionality
          ],
        ),
      ),
    );
  }

  void loginPressed (BuildContext context) async {
    String email = emailController.text;
    String password = passwordController.text;

    AuthService authService = AuthService();

    String? signInWithEmailAndPasswordResponse = await authService.signInWithEmailAndPassword(email, password);

    if(signInWithEmailAndPasswordResponse == null) {
      // Login was successful
      GoRouter.of(context).go('/home');
    } else {
      // Login was unsuccessful
      setState(() {
        _errorMessage = signInWithEmailAndPasswordResponse;
      });
    }
  }
}