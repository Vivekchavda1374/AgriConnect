import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication
import '../sign_up screen/sign_up_screen.dart';

class LoginFooterWidget extends StatelessWidget {
  LoginFooterWidget({Key? key}) : super(key: key);

  // Initialize GoogleSignIn
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Function to handle Google sign-in
  Future<void> _googleSignInAction() async {
    try {
      // Attempt to sign in with Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        print('Google Sign-In cancelled');
        return;
      }

      // Obtain the authentication details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // If using Firebase for authentication, authenticate with Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase using the Google credentials
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;

      // Successfully signed in, you can now proceed with your app's logic
      print('Google Sign-In successful, user: ${user?.displayName}');
    } catch (e) {
      print('Error during Google Sign-In: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "OR",
          style: TextStyle(color: Colors.green),
        ),
        const SizedBox(height: 16),

        // Google Sign-In Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Icon(
              Icons.account_circle, // Placeholder icon (can replace with Google icon)
              color: Colors.brown,
            ),
            label: const Text('Sign in with Google'),
            onPressed: _googleSignInAction, // Calls the Google sign-in function
          ),
        ),
        const SizedBox(height: 16),

        // Sign-up text
        TextButton(
          onPressed: () {
            // Navigate to sign-up screen or perform other action
            print("Navigating to sign-up page...");
          },
          child: Text.rich(
            TextSpan(
              text: 'Don’t have an account? ',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.brown,
                  ),
              children: [
                TextSpan(
                  text: 'Sign up',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpScreen()),
                      );
                    },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
