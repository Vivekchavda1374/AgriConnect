import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_more.dart'; // Import your AddMoreScreen

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _FarmerProductListScreenState();
}

class _FarmerProductListScreenState extends State<ProductListScreen> {
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _filteredProducts = [];
  bool _isLoading = true;

  final String farmerId = "SvEArqH9fSnsbgPwFVcr"; // Replace with dynamic farmer ID
  String? _selectedCategory;
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('farmer')
          .doc(farmerId)
          .collection('crops')
          .get();

      final products = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'name': data['cropName'],
          'price': data['price'],
          'quantity': data['quantity'],
          'category': data['category'],
          'imageUrl': data['encryptedImage'],
          'harvestDate': data['harvestDate'],
        };
      }).toList();

      final categories = products
          .map((product) => product['category'] as String)
          .toSet()
          .toList();

      setState(() {
        _products = products;
        _filteredProducts = products;
        _categories = categories;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching products: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterByCategory(String? category) {
    setState(() {
      _selectedCategory = category;
      if (category == null) {
        _filteredProducts = _products;
      } else {
        _filteredProducts = _products
            .where((product) => product['category'] == category)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Crops', style: const TextStyle(fontSize: 22)),
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to Add More Crops Screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddMoreScreen()),
              );
            },
            icon: const Icon(Icons.add, size: 28),
          ),
        ],
      ),
      body: Column(
        children: [
          // Dropdown for filtering crops by category
          if (_categories.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: DropdownButton<String>(
                value: _selectedCategory,
                hint: const Text('Filter by Crop Type', style: TextStyle(fontSize: 18)),
                isExpanded: true,
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text('All Crops', style: TextStyle(fontSize: 18)),
                  ),
                  ..._categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category, style: const TextStyle(fontSize: 18)),
                    );
                  }).toList(),
                ],
                onChanged: _filterByCategory,
              ),
            ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredProducts.isEmpty
                    ? const Center(
                        child: Text(
                          'No crops to display',
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: _filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = _filteredProducts[index];
                          return _productCard(product);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _productCard(Map<String, dynamic> product) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Crop Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product['imageUrl'] ?? '',
                fit: BoxFit.cover,
                width: 80,
                height: 80,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 50, color: Colors.grey);
                },
              ),
            ),
            const SizedBox(width: 12),
            // Crop Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'] ?? 'Unknown Crop',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹${product['price']} / kg',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  ),
                  Text(
                    'Quantity: ${product['quantity']} kg',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
