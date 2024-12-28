import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../login screen/login_screen.dart';

class SignUpFooterWidget extends StatelessWidget {
  const SignUpFooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("OR"),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              // Placeholder for Google Sign-In functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Google Sign-In not implemented yet.')),
              );
            },
            icon: const Image(
              image: AssetImage('assets/images/search.png'),
              width: 20.0,
            ),
            label: Text('Sign In with Google'.toUpperCase()),
          ),
        ),
        const SizedBox(height: 16.0), // Spacing for better layout
        Text.rich(
          TextSpan(
            text: 'You’ve an account? ',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.brown,
                ),
            children: [
              TextSpan(
                text: 'Login here...',
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
