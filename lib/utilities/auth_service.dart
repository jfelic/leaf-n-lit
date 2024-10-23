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

  // Login with email and password
  Future<UserCredential?> signInWithEmailAndPassword (String email, String password) async {
    try {
      // on success
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      return userCredential; // Return user credential if login is successful
    } on FirebaseAuthException catch (e) {
      // on error
      print("Failed with error code: ${e.code}");
      print(e.message);
      return null; // Return null if login fails
    }
  }
}