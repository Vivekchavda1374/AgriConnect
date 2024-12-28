import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class FarmerOTPScreen extends StatelessWidget {
  const FarmerOTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify OTP"),
        backgroundColor: Colors.green.shade800,
        centerTitle: true,
      ),
      body: Builder(
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    kToolbarHeight -
                    MediaQuery.of(context).padding.top,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.verified_user_rounded,
                      size: 100.0, color: Colors.green.shade700),
                  const SizedBox(height: 20.0),
                  Text(
                    "Enter OTP to Verify",
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 28.0,
                      color: Colors.green.shade900,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    "A 6-digit OTP has been sent to your registered email.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: 16.0),
                  ),
                  const SizedBox(height: 40.0),

                  // OTP Input Fields
                  OtpTextField(
                    mainAxisAlignment: MainAxisAlignment.center,
                    numberOfFields: 6,
                    borderColor: Colors.green.shade600,
                    fillColor: Colors.green.withOpacity(0.1),
                    filled: true,
                    showFieldAsBox: true,
                    fieldWidth: 45.0,
                    onSubmit: (code) {
                      print("OTP is => $code");
                    },
                  ),
                  const SizedBox(height: 20.0),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Add OTP verification logic
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade800,
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                      ),
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text(
                        'Verify OTP',
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20.0),

                  // Resend OTP
                  TextButton(
                    onPressed: () {
                      // Add resend OTP logic
                    },
                    child: Text(
                      "Resend OTP",
                      style: TextStyle(
                        color: Colors.green.shade900,
                        fontSize: 16.0,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
