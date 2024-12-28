
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../sign_up screen/sign_up_screen.dart';

class LoginFooterWidget extends StatelessWidget {
  const LoginFooterWidget({super.key});

  void _googleSignIn() {
    // Simulate a Google sign-in action.
    // Replace this function with your actual Google sign-in logic.
    print("Redirecting to Google sign-in...");
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
              Icons.account_circle, // Placeholder icon (replace with Google icon if needed)
              color: Colors.brown,
            ),
            label: const Text('Sign in with Google'),
            onPressed: _googleSignIn, // Calls the Google sign-in function
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
