import 'package:flutter/material.dart';
import 'splash_screen_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final splashController = SplashScreenController();

  @override
  void initState() {
    super.initState();
    // Start the animation and then navigate to the WelcomeScreen after a delay
    splashController.startAnimation();

    // Navigate to the welcome screen after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, '/welcome');  // Navigate to WelcomeScreen
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade50,
        title: Text(
          'AgriConnect',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: Colors.green.shade900,
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.08,
              ),
        ),
      ),
      backgroundColor: Colors.green.shade50,
      body: Stack(
        children: [
          // Text Above Logo
          AnimatedBuilder(
            animation: splashController.animation,
            builder: (context, child) {
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 1600),
                top: splashController.animate ? screenHeight * 0.04 : -100,
                left: screenWidth * 0.1,
                right: screenWidth * 0.1,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 1600),
                  opacity: splashController.animate ? 1 : 0,
                  child: Text(
                    'Empowering Farmers Everyday',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.green.shade800,
                          fontWeight: FontWeight.w600,
                          fontSize: screenWidth * 0.05,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),

          // Farmer Icon (Logo) in the Top-Center
          AnimatedBuilder(
            animation: splashController.animation,
            builder: (context, child) {
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 1600),
                top: splashController.animate ? screenHeight * 0.08 : -80,
                left: screenWidth * 0.25,
                right: screenWidth * 0.25,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 1600),
                  opacity: splashController.animate ? 1 : 0,
                  child: Image.asset(
                    'assets/images/gardener.png',
                    width: screenWidth * 0.5,
                  ),
                ),
              );
            },
          ),

          // Text Below Logo
          AnimatedBuilder(
            animation: splashController.animation,
            builder: (context, child) {
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 1600),
                top: splashController.animate
                    ? screenHeight * 0.39
                    : screenHeight * 0.49,
                left: screenWidth * 0.1,
                right: screenWidth * 0.1,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 1600),
                  opacity: splashController.animate ? 1 : 0,
                  child: Text(
                    'Join Us in Transforming Agriculture',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w500,
                          fontSize: screenWidth * 0.045,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),

          // Field Image in the Center
          AnimatedBuilder(
            animation: splashController.animation,
            builder: (context, child) {
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 2000),
                top: splashController.animate
                    ? screenHeight * 0.4
                    : screenHeight * 0.5,
                left: 0,
                right: 0,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 2000),
                  opacity: splashController.animate ? 1 : 0,
                  child: Image.asset(
                    'assets/images/fields.png',
                    width: screenWidth * 0.5,
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),

          // Arrow right Button at the Bottom-Center
          AnimatedBuilder(
            animation: splashController.animation,
            builder: (context, child) {
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 2400),
                bottom: splashController.animate ? screenHeight * 0.1 : -80,
                left: screenWidth * 0.5 - (screenWidth * 0.075),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 2000),
                  opacity: splashController.animate ? 1 : 0,
                  child: InkWell(
                    onTap: () => Navigator.pushReplacementNamed(context, '/welcome'),
                    child: Container(
                      width: screenWidth * 0.15,
                      height: screenWidth * 0.15,
                      decoration: BoxDecoration(
                        color: Colors.green.shade800,
                        borderRadius: BorderRadius.circular(screenWidth * 0.075),
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: screenWidth * 0.1, // Adjust the size of the icon
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
