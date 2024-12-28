import 'package:flutter/material.dart';

class FormHeaderWidget extends StatelessWidget {
  final String image; // Path of the image
  final double imageHeight; // Height as a percentage of the screen height

  const FormHeaderWidget({
    super.key,
    required this.image,
    required this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // Get the screen size

    return Column(
      children: [
        Image.asset(
          image,
          height: size.height * imageHeight, // Set image height as percentage of screen height
        ),
        const SizedBox(height: 20), // Add space below the image if needed
      ],
    );
  }
}
