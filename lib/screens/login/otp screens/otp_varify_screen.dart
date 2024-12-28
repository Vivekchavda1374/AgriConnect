import 'package:flutter/material.dart';

class FarmerOtpVerificationScreen extends StatefulWidget {
  final String email;
  final String generatedOtp;

  const FarmerOtpVerificationScreen({
    super.key,
    required this.email,
    required this.generatedOtp,
  });

  @override
  _FarmerOtpVerificationScreenState createState() =>
      _FarmerOtpVerificationScreenState();
}

class _FarmerOtpVerificationScreenState
    extends State<FarmerOtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  String? _enteredOtp;

  // Function to verify OTP
  void _verifyOtp() {
    _enteredOtp = _otpController.text.trim();

    if (_enteredOtp == widget.generatedOtp) {
      // OTP is correct, proceed to the Home screen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'OTP verified successfully! You can now proceed.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
      // Navigate to Home screen (replace with your home screen widget)
      // Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (context) => const HomeScreen()),
      // );
    } else {
      // OTP is incorrect
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Invalid OTP. Please try again.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Function to simulate resend OTP action
  void _resendOtp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'OTP has been resent to your email.',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
    );
    // Here you can implement logic to resend the OTP via email
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
        backgroundColor: Colors.green, // Green for farming theme
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'We have sent an OTP to your email address:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              widget.email,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Enter the OTP below to verify your account:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter OTP',
                hintText: 'Enter 6-digit OTP',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock), // Icon for security
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verifyOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Farmer-friendly color
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Verify OTP'),
            ),
            const SizedBox(height: 20),
            // Resend OTP button
            TextButton(
              onPressed: _resendOtp,
              child: const Text(
                'Resend OTP',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
