import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageCropsScreen extends StatefulWidget {
  const ManageCropsScreen({super.key});

  @override
  _ManageCropsScreenState createState() => _ManageCropsScreenState();
}

class _ManageCropsScreenState extends State<ManageCropsScreen> {
  final String farmerId = "SvEArqH9fSnsbgPwFVcr"; // Replace with dynamic farmer ID

  // Function to read crops from Firestore
  Future<List<Map<String, dynamic>>> _fetchCrops() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('farmer')
          .doc(farmerId)
          .collection('crops')
          .get();

      return snapshot.docs.map((doc) {
        return {
          'id': doc.id, // Document ID
          'cropName': doc['cropName'],
          'category': doc['category'],
          'cropDescription': doc['cropDescription'],
          'harvestDate': doc['harvestDate'],
          'encryptedImage': doc['encryptedImage'],
          'price': doc['price'],
          'quantity': doc['quantity'],
          'timestamp': doc['timestamp'],
        };
      }).toList();
    } catch (e) {
      print('Error fetching crops: $e');
      return [];
    }
  }

  // Function to delete a crop from Firestore
  Future<void> _deleteCrop(String cropId) async {
    try {
      await FirebaseFirestore.instance
          .collection('farmer')
          .doc(farmerId)
          .collection('crops')
          .doc(cropId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Crop deleted successfully'),
      ));
      setState(() {}); // Refresh the list after deletion
    } catch (e) {
      print('Error deleting crop: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error deleting crop'),
      ));
    }
  }

  void _navigateToAddUpdateCrop(BuildContext context, {Map<String, dynamic>? crop}) {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddUpdateCropScreen(
          crop: crop,
          farmerId: farmerId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Crops"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to Add Crop screen
              _navigateToAddUpdateCrop(context);
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchCrops(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final crops = snapshot.data ?? [];
          if (crops.isEmpty) {
            return const Center(child: Text('No crops available.'));
          }

          return ListView.builder(
            itemCount: crops.length,
            itemBuilder: (context, index) {
              final crop = crops[index];
              return ListTile(
                title: Text(crop['cropName']),
                subtitle: Text(
                  'Category: ${crop['category']} | Quantity: ${crop['quantity']} | Price: ${crop['price']}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // Navigate to Edit Crop screen
                        _navigateToAddUpdateCrop(context, crop: crop);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        // Delete crop
                        _deleteCrop(crop['id']);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class AddUpdateCropScreen extends StatefulWidget {
  final Map<String, dynamic>? crop;
  final String farmerId;

  const AddUpdateCropScreen({super.key, this.crop, required this.farmerId});

  @override
  _AddUpdateCropScreenState createState() => _AddUpdateCropScreenState();
}

class _AddUpdateCropScreenState extends State<AddUpdateCropScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cropNameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _cropDescriptionController = TextEditingController();
  DateTime? _harvestDate;
  String? _encryptedImage;

  @override
  void initState() {
    super.initState();
    if (widget.crop != null) {
      _cropNameController.text = widget.crop!['cropName'];
      _categoryController.text = widget.crop!['category'];
      _quantityController.text = widget.crop!['quantity'];
      _priceController.text = widget.crop!['price'];
      _cropDescriptionController.text = widget.crop!['cropDescription'];
      _harvestDate = DateTime.parse(widget.crop!['harvestDate']);
      _encryptedImage = widget.crop!['encryptedImage'];
    }
  }

  // Function to save or update crop data
  Future<void> _saveCrop() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final cropData = {
          'cropName': _cropNameController.text,
          'category': _categoryController.text,
          'quantity': _quantityController.text,
          'price': _priceController.text,
          'cropDescription': _cropDescriptionController.text,
          'harvestDate': _harvestDate?.toIso8601String(),
          'encryptedImage': _encryptedImage ?? '',
          'timestamp': FieldValue.serverTimestamp(),
        };

        if (widget.crop == null) {
          // Add new crop
          await FirebaseFirestore.instance
              .collection('farmer')
              .doc(widget.farmerId)
              .collection('crops')
              .add(cropData);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Crop added successfully')),
          );
        } else {
          // Update existing crop
          await FirebaseFirestore.instance
              .collection('farmer')
              .doc(widget.farmerId)
              .collection('crops')
              .doc(widget.crop!['id'])
              .update(cropData);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Crop updated successfully')),
          );
        }

        Navigator.pop(context); // Return to previous screen
      } catch (e) {
        print('Error saving crop: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error saving crop')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.crop == null ? 'Add Crop' : 'Edit Crop'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _cropNameController,
                decoration: const InputDecoration(labelText: 'Crop Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a crop name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a quantity';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a price';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cropDescriptionController,
                decoration: const InputDecoration(labelText: 'Crop Description'),
                maxLines: 3,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a crop description';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: _saveCrop,
                child: Text(widget.crop == null ? 'Add Crop' : 'Update Crop'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
