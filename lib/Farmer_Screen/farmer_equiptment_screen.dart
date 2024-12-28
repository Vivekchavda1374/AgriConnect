import 'package:flutter/material.dart';

class FarmingEquipmentScreen extends StatelessWidget {
  const FarmingEquipmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Farming Equipment")),
      body: const Center(child: Text("Browse farming equipment")),
    );
  }
}
