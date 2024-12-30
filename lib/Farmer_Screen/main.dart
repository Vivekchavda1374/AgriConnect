import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'add_more.dart';
import 'home_screen.dart'; // Import your dashboard if needed
import '../firebase_options.dart'; // Import firebase_options.dart for platform-specific initialization

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with platform-specific options
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform, // Ensure you pass the correct options
    );
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  runApp(const MyFarmer());
}

class MyFarmer extends StatelessWidget {
  const MyFarmer({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Farmer App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: const Text('Welcome to Your Farm App'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to AddMoreScreen using Navigator.push
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddMoreScreen()),
            );
          },
          child: const Text('Add More Crops'),
        ),
      ),
    );
  }
}
