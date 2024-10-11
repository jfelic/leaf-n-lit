import 'package:flutter/material.dart';

class RegistrationScreen extends StatelessWidget {

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
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'First Name',
              ),
              obscureText: false,
              keyboardType: TextInputType.text,
              maxLength: 35,
            ),

            // const SizedBox(height: 16.0),

            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
              obscureText: false,
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 16.0),

            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
              obscureText: true,
            ),

            const SizedBox(height: 16.0),

            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Confirm Password',
              ),
              obscureText: true,
            ),

            const SizedBox(height: 16.0),

            ElevatedButton(
              onPressed: () {
                // Handle registration logic
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}