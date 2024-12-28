import 'package:flutter/material.dart';

class SeeMoreScreen extends StatelessWidget {
  final List<Map<String, dynamic>> cropsList;

  const SeeMoreScreen({super.key, required this.cropsList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: const Text('Your Crops'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: cropsList.isEmpty
            ? const Center(child: Text('No crops added yet!'))
            : ListView.builder(
                itemCount: cropsList.length,
                itemBuilder: (context, index) {
                  final crop = cropsList[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      leading: crop['image'] == null
                          ? const Icon(Icons.image, size: 50)
                          : Image.memory(crop['image']!, width: 50, height: 50, fit: BoxFit.cover),
                      title: Text(crop['cropName']),
                      subtitle: Text('Price: ${crop['price']} | Quantity: ${crop['quantity']}'),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        // Show more details if needed
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
