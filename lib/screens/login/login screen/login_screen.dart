
import 'package:flutter/material.dart';

import 'login_footer.dart';
import 'login_form.dart';
import 'login_header.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.green.shade50,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0), // Adjusted for cleaner layout
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LoginHeaderWidget(),
                const SizedBox(height: 20), // Add spacing for better flow
                const LoginForm(),
                const SizedBox(height: 20), // Add spacing
                LoginFooterWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
