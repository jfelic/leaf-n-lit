// services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Listen to authentication state changes
  Stream<User?> get authStateChanges => FirebaseAuth.instance.authStateChanges();

  // TODO: Implement the sign up with email and password method
  createUserWithEmailAndPassword(String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password); 
    } on FirebaseAuthException catch (e) {
      print("Failed with error code: ${e.code}");
      print(e.message);
    }
  }
}