import 'package:flutter/material.dart';

import 'sign_up_footer_screen.dart';
import 'sign_up_form_screen.dart';
import 'sign_up_header_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: const Column(
              children: [
                // Header with an image (you can adjust imageHeight as needed)
                FormHeaderWidget(
                  image: 'assets/images/welcome-back.png', // Ensure the image path is correct
                  imageHeight: 0.15, // Adjust image height (percentage of screen height)
                ),
                // SignUp Form Widget
                SignUpFormWidget(),
                // Footer with Google Sign-in and sign-up link
                SignUpFooterWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
