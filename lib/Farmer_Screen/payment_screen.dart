import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: const Text('Payment Page'),
      ),
      body: const Center(
        child: Text('Manage your payments here', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
