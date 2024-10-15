// services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Listen to authentication state changes
  Stream<User?> get authStateChanges => FirebaseAuth.instance.authStateChanges();

  // TODO: Implement the sign up with email and password method
}