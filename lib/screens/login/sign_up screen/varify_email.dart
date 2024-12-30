import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../Farmer_Screen/main.dart';


class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  // Function to check if the email is verified
  Future<void> _checkEmailVerified(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload(); // Reload user data to get the latest verification status
    if (user != null && user.emailVerified) {
      // If email is verified, navigate to the home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyFarmer ()), // Navigate to HomeScreen
      );
    } else {
      // Show a message if the email is not yet verified
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email not verified yet. Please check your inbox.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Periodically check if the email is verified
    Future.delayed(const Duration(seconds: 5), () {
      _checkEmailVerified(context);
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Verify Your Email')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'We have sent a verification link to your email.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'Please check your inbox and verify your email.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _checkEmailVerified(context),
              child: const Text('Check if Verified'),
            ),
          ],
        ),
      ),
    );
  }
}
