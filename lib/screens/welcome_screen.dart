import 'package:flutter/material.dart';
import 'login/login screen/login_screen.dart';
import 'login/sign_up screen/sign_up_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var height = mediaQuery.size.height;
    var width = mediaQuery.size.width;
    var brightness = mediaQuery.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.green.shade900 : Colors.green.shade100,
      body: Container(
        padding: EdgeInsets.all(width * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Welcome Image
            Image.asset(
              'assets/images/welcome-back.png',
              height: height * 0.4,
              width: width * 0.8,
            ),
            // Title and Subtitle
            Column(
              children: [
                Text(
                  'Welcome to AgriConnect',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: isDarkMode ? Colors.white : Colors.green.shade800,
                        fontWeight: FontWeight.bold,
                        fontSize: width * 0.08,
                      ),
                ),
                SizedBox(height: height * 0.02),
                Text(
                  'Empowering farmers, connecting consumers!',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: isDarkMode ? Colors.grey.shade300 : Colors.green.shade700,
                        fontSize: width * 0.05,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            // Buttons for Login/Sign Up
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Navigate to LoginScreen using simple Navigator
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.green.shade700),
                      padding: EdgeInsets.symmetric(vertical: height * 0.02),
                    ),
                    child: Text(
                      'LOGIN',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.green.shade800,
                        fontWeight: FontWeight.bold,
                        fontSize: width * 0.045,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: width * 0.05),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to SignUpScreen using simple Navigator
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade800,
                      padding: EdgeInsets.symmetric(vertical: height * 0.02),
                    ),
                    child: Text(
                      'SIGN UP',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: width * 0.045,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
