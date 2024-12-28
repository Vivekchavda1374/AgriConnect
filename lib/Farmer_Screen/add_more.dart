import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class AddMoreScreen extends StatefulWidget {
  const AddMoreScreen({super.key});

  @override
  _AddMoreScreenState createState() => _AddMoreScreenState();
}

class _AddMoreScreenState extends State<AddMoreScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cropNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  final _cropDescriptionController = TextEditingController();

  DateTime? _harvestDate;
  String? _selectedCategory;
  Uint8List? _imageData;

  final List<String> _categories = [
    'Vegetables',
    'Fruits',
    'Dairy',
    'Grains',
    'Flowers',
    'Beans',
  ];

  final _encryptionKey = encrypt.Key.fromLength(32); // Key for AES encryption

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Your Crop to Mandi'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(
                    'Crop Name', _cropNameController, Icons.agriculture),
                _buildCategoryDropdown(),
                _buildTextField(
                    'Quantity', _quantityController, Icons.bar_chart,
                    isNumeric: true),
                _buildTextField(
                    'Price', _priceController, Icons.monetization_on,
                    isNumeric: true),
                _buildDatePicker(context),
                _buildTextField('Crop Description', _cropDescriptionController,
                    Icons.description,
                    maxLines: 5),
                _buildImagePicker(),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: _selectedCategory,
        items: _categories
            .map((category) =>
                DropdownMenuItem(value: category, child: Text(category)))
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedCategory = value;
          });
        },
        decoration: const InputDecoration(
          labelText: 'Select Category',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.category),
        ),
        validator: (value) => value == null ? 'Please select a category' : null,
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, IconData icon,
      {bool isNumeric = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
        maxLines: maxLines,
        validator: (value) => value!.isEmpty ? 'Please enter $label' : null,
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Row(
      children: [
        Text(_harvestDate == null
            ? 'Harvest Date: Not Set'
            : 'Harvest Date: ${_harvestDate?.toLocal().toString().split(' ')[0]}'),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () => _selectDate(context),
          child: const Text('Pick Date'),
        ),
      ],
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _pickImage,
          child: const Text('Upload Image'),
        ),
        if (_imageData != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.memory(
              _imageData!,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _saveCrop,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        ),
        child: const Text(
          'Add Crop',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _harvestDate) {
      setState(() {
        _harvestDate = pickedDate;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageData = bytes;
      });
    }
  }

  Future<void> _saveCrop() async {
    if (_formKey.currentState?.validate() ?? false) {
      String? encryptedImage;

      // Encrypt the image data if available
      if (_imageData != null) {
        try {
          final encrypter = encrypt.Encrypter(encrypt.AES(_encryptionKey));
          final iv = encrypt.IV.fromLength(16); // Random IV for encryption
          final encrypted = encrypter.encryptBytes(_imageData!, iv: iv);

          encryptedImage = base64Encode(encrypted.bytes);
        } catch (e) {
          _showSnackBar('Image encryption failed: $e');
          return;
        }
      }

      // Prepare crop data
      final cropData = {
        'cropName': _cropNameController.text,
        'category': _selectedCategory,
        'quantity': _quantityController.text,
        'price': _priceController.text,
        'harvestDate': _harvestDate?.toIso8601String(),
        'cropDescription': _cropDescriptionController.text,
        'encryptedImage': encryptedImage ?? '',
        'timestamp': FieldValue.serverTimestamp(),
      };

      // Replace this with the current farmer's ID
      const farmerId =
          "SvEArqH9fSnsbgPwFVcr"; 

      try {
        // Add crop to the farmer's `crops` subcollection
        await FirebaseFirestore.instance
            .collection('farmer')
            .doc(farmerId)
            .collection('crops')
            .add(cropData);

        _showSnackBar('Crop added successfully!');

        // Reset the form after successful submission
        _formKey.currentState?.reset();
        setState(() {
          _harvestDate = null;
          _selectedCategory = null;
          _imageData = null;
        });
      } catch (e) {
        _showSnackBar('Error saving crop: $e');
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
