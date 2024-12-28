import 'package:flutter/material.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Farmer icon image (Update with your actual image path)
          Image.asset(
            'assets/images/gardener.png',
            height: size.height * 0.2,
          ),
          const SizedBox(height: 16), // Added spacing for better layout
          Text(
            'Welcome Farmer!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.green.shade900,
                  fontWeight: FontWeight.bold,
                  fontSize: 24, // Ensure good readability
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8), // Small gap between title and subtitle
          Text(
            'Login to access your account and manage your crops.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.green.shade700,
                  fontSize: 16, // Ensure readability
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
