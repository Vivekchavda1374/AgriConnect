// import 'package:agriconnect/screens/login/sign_up%20screen/sign_up_controller.dart';
// import 'package:flutter/material.dart';
// import 'dart:math'; // For generating OTP

// class GenerateOtpScreen extends StatefulWidget {
//   const GenerateOtpScreen({super.key});

//   @override
//   _GenerateOtpScreenState createState() => _GenerateOtpScreenState();
// }

// class _GenerateOtpScreenState extends State<GenerateOtpScreen> {
//   final TextEditingController _emailController = TextEditingController();

//   // Variable to store the generated OTP
//   String? _generatedOtp;

//   // Function to generate OTP
//   String _generateOtp() {
//     final random = Random();
//     return (100000 + random.nextInt(900000)).toString(); // Generates a 6-digit OTP
//   }

//   // Function to simulate sending OTP to email (replace with actual email sending logic)
//   Future<void> _sendOtpToEmail(String email, String otp) async {
//     print('Sending OTP to $email: $otp');
//     // Example: You would use an email service (like SendGrid or Firebase Functions) to send the OTP here.
//   }

//   // Handle OTP generation and sending process
//   Future<void> _handleGenerateOtp() async {
//     final email = _emailController.text.trim();

//     if (email.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter your email address.')),
//       );
//       return;
//     }

//     // Generate OTP and send to email
//     _generatedOtp = _generateOtp();
//     await _sendOtpToEmail(email, _generatedOtp!);

//     // Show success message
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('OTP has been sent to your email!')),
//     );

//     // Navigate to OTP verification screen and pass OTP and email
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => OtpVerificationScreen(
//           email: email,
//           generatedOtp: _generatedOtp!,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Generate OTP")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             const Text(
//               'Enter your email address to receive an OTP:',
//               style: TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: _emailController,
//               decoration: const InputDecoration(
//                 labelText: 'Email Address',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _handleGenerateOtp,
//               child: const Text('Generate OTP'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class OtpVerificationScreen {
// }
