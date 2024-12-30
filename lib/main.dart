import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/login/login screen/login_screen.dart';
import 'screens/login/sign_up screen/sign_up_screen.dart';
import 'screens/splashScreen/splash_screen.dart';  
import 'Farmer_Screen/home_screen.dart';
import 'Farmer_Screen/add_more.dart';
import 'Farmer_Screen/farmer_desboard.dart';
import 'screens/welcome_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  // Initialize Firebase with platform-specific options
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
      
    );
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AgriConnect',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',  // SplashScreen will be the initial screen
      routes: {
        '/': (context) => const SplashScreen(),  // Set SplashScreen as the initial route
        '/welcome': (context) => const WelcomeScreen(),  // Navigate to WelcomeScreen after splash
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomePage(),
        '/addMore': (context) => const AddMoreScreen(),
        '/dashboard': (context) => const HomePage(),
      },
    );
  }
}
