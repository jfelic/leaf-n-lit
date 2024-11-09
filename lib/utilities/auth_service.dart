// services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  /* Stream<User?> authStateChanges => FirebaseAuth.instance.authStateChanges();
  - authStateChanges() listens to authentication state changes like login and logout.
  - You can use this stream to update the UI on your screen when the user logs in or logs out
  - I think this will eventually be changed to userChanges() rather than authStateChanges()...
    but for now this will do.
  */
  Stream<User?> get authStateChanges => FirebaseAuth.instance.authStateChanges();

  // Create account with email and password
  Future<String?> createUserWithEmailAndPassword(String email, String password) async {
    try { // If the operation is successful, the user will be signed in and the user's information will be returned in the UserCredential object which we can use.
      // UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password); 
      
      // We could perform additional tasks here, like storing userCrenetials in our database.

      return null; // Return user credential to caller
    
    } on FirebaseAuthException catch (e) { // Error handling
      if (e.code == "weak-password") {
        return "The password provided is too weak.";
      } else if (e.code == "email-already-in-use") {
        return "An account already exists for that email.";
      } else {
        print("Login error code: ${e.code}");
        print("Login error: ${e.message}");

        return e.message;
      }
    } catch (e) { // Catch any other generic error
        return e.toString();
    }
  }
  
  // Login with email and password
  Future<String?> signInWithEmailAndPassword (String email, String password) async {
    try { // Success
      // UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

      return null; // Return null if login is successful

    } on FirebaseAuthException catch (e) { // Error handling
      if(e.code == "user-not-found" || e.code == "wrong-password" || e.code == "invalid-credential") {
        return "Invalid email or password";
      } else {

        print("Login error code: ${e.code}");
        print("Login error: ${e.message}");

        return e.message;
      }
    } catch (e) { // Catch any other generic error
      return e.toString();
    }
  }
}