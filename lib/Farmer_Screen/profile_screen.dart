import 'dart:io'; // For File handling
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker package
import 'farmer_equiptment_screen.dart';
import 'manage_crops_screen.dart';
import 'profile_widget.dart';  // Assuming this widget is for managing profile picture.
import 'update_profile_screen.dart';
import 'view_sale_screen.dart'; // Screen for farming equipment.

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profileImage; 
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path); // Update the profile image
      });
    }
  }

  // Method to handle logout functionality
  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("LOGOUT"),
          content: const Text("Are you sure, you want to Logout?"),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                // For now, we show a confirmation dialog, but this can be enhanced
                Fluttertoast.showToast(msg: "Logged out successfully!");
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false); // Navigate to login screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF7043), // Accent color
              ),
              child: const Text("Yes"),
            ),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("No"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(FontAwesomeIcons.angleLeft)),
        title: Text("Farmer Profile", style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {}, // Implement theme switch logic if necessary
            icon: Icon(isDark ? FontAwesomeIcons.sun : FontAwesomeIcons.moon),
          ),
        ],
        backgroundColor: const Color(0xFF4CAF50), // Primary color
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          color: const Color(0xFFF4F6F8), // Background color
          child: Column(
            children: [
              // -- IMAGE
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: _profileImage == null
                          ? const Image(image: AssetImage('assets/profile_image.png'))  
                          : Image.file(_profileImage!), 
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage, // Open image picker on click
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: const Color(0xFF4CAF50),
                        ),
                        child: const Icon(
                          FontAwesomeIcons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text("Vivek", style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.black)),
              // Text("Farmer Subheading", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black)),
              const SizedBox(height: 20),

              // -- BUTTON
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UpdateProfileScreen()),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50), // Primary color
                    shape: const StadiumBorder(),
                  ),
                  child: const Text("Edit Profile", style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),

              // -- MENU
              ProfileMenuWidget(
                title: "Manage Crops",
                icon: FontAwesomeIcons.seedling,
                onPress: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ManageCropsScreen()),
                ),
              ),
              ProfileMenuWidget(
                title: "View Sales",
                icon: FontAwesomeIcons.chartLine,
                onPress: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ViewSalesScreen()),
                ),
              ),
              ProfileMenuWidget(
                title: "Farming Equipment",
                icon: FontAwesomeIcons.cogs,
                onPress: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FarmingEquipmentScreen()),
                ),
              ),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(
                title: "Information",
                icon: FontAwesomeIcons.info,
                onPress: () {}, // Implement a screen for information
              ),
              ProfileMenuWidget(
                title: "Logout",
                icon: FontAwesomeIcons.signOutAlt,
                textColor: Colors.red,
                endIcon: false,
                onPress: _logout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
