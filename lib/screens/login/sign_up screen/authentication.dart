import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign up with email and password
  Future<void> signUpWithEmailAndPassword({
    required BuildContext context, // Added context for Navigator
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      // Create a new user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // After sign-up, update the user profile with full name and phone number (optional)
      User? user = userCredential.user;
      if (user != null) {
        await user.updateDisplayName(fullName);
      }

      // Navigate to the next screen or return to the previous one
      Navigator.pushNamed(context, '/welcome');

    } on FirebaseAuthException catch (e) {
      // Handle errors here
      if (e.code == 'email-already-in-use') {
        throw 'This email is already registered.';
      } else {
        throw e.message ?? 'An error occurred. Please try again.';
      }
    }
  }
}
