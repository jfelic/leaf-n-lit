import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leaf_n_lit/utilities/auth_service.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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

            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),

            SizedBox(height: 16.0),

            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),

            SizedBox(height: 20.0),

            ElevatedButton(
              onPressed: () { loginPressed(context); },
              child: Text('Login'),
            ),

            const SizedBox(height: 20.0),

            TextButton(
            onPressed:()  {
              GoRouter.of(context).push('/register');
            }, 
            child: Text("Or, create an account",
            style: TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
               )
              ),
            ),
          ],
        ),
      ),
    );
  }

  void loginPressed(BuildContext context) {
    String email = emailController.text;
    String password = passwordController.text;

    AuthService authService = AuthService();
    authService.signInWithEmailAndPassword(email, password);

    GoRouter.of(context).go('/home');
  }
}