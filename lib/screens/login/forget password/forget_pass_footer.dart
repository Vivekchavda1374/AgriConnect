import 'package:flutter/material.dart';
import 'forget_password_mail.dart';
import 'footer_sheet_button.dart';

class ForgetPasswordScreen {
  static Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Forgot Password',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.green.shade800,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Select an option to reset your password.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 30.0),
            ForgetPasswordBtnWidget(
              onTap: () {
                Navigator.pop(context); // Close the modal first
                // Delay navigation to ensure modal is closed before navigation
                Future.delayed(Duration(milliseconds: 300), () {
                  if (context != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgetPasswordMailScreen(),
                      ),
                    );
                  }
                });
              },
              title: 'Email',
              subTitle: 'Reset via Email',
              btnIcon: Icons.mail_outline_rounded,
            ),
            const SizedBox(height: 20.0),
            ForgetPasswordBtnWidget(
              onTap: () {
                Navigator.pop(context); // Close the modal first
                // You can add phone reset logic here
              },
              title: 'Phone Number',
              subTitle: 'Reset via Phone',
              btnIcon: Icons.mobile_friendly_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
