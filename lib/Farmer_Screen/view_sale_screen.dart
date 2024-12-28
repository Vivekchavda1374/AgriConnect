import 'package:flutter/material.dart';

class ViewSalesScreen extends StatelessWidget {
  const ViewSalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("View Sales")),
      body: const Center(child: Text("View your sales here")),
    );
  }
}
