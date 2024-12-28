import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Login using Firebase Authentication
  Future<bool> login(String email, String password) async {
    try {
      // Attempt to sign in with email and password
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save login details in SharedPreferences for auto-login
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', email); // Save email
      await prefs.setString('password', password); // Save password

      return true; // Login successful
    } on FirebaseAuthException catch (e) {
      // Handle authentication errors
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
      }
      return false; // Login failed
    }
  }

  // Optional: Log out the user
  Future<void> logout() async {
    await _auth.signOut();

    // Clear shared preferences when logging out
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
  }

  // Check if the user is logged in
  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('email');
    String? savedPassword = prefs.getString('password');

    if (savedEmail != null && savedPassword != null) {
      return true; // User is already logged in with saved credentials
    }

    return false;
  }

  // Auto-login user based on saved credentials
  Future<void> autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('email');
    String? savedPassword = prefs.getString('password');

    if (savedEmail != null && savedPassword != null) {
      // Try to sign in with saved credentials
      await _auth.signInWithEmailAndPassword(
        email: savedEmail,
        password: savedPassword,
      );
    }
  }
}
