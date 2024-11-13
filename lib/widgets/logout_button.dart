// lib/widgets/logout_button.dart

import 'package:flutter/material.dart';
import 'package:leaf_n_lit/utilities/auth_service.dart';
import 'package:go_router/go_router.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.logout),
      onPressed: () async {
        // Create an instance of AuthService to call the signOut function
        AuthService authService = AuthService();
        await authService.signOut();
        // Redirect to login page after signing out
        GoRouter.of(context).go('/login');
      },
    );
  }
}
