import 'package:agri_connect/Farmer_Screen/notifiaction_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:geolocator/geolocator.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import 'add_more.dart';
import 'product_screen.dart';
import 'profile_screen.dart';

const OPENWEATHER_API_KEY = "674b1cecb8b42f23388b30322a2953e9";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);
  Weather? _weather;
  String? _errorMessage;

  List<Map<String, dynamic>> yourProducts = [];
  List<Map<String, dynamic>> sellerProducts = [];
  List<Map<String, dynamic>> sellerMachineProducts = [];

  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  @override
  void initState() {
    super.initState();
    _fetchWeather();
    _fetchCrops();
    _fetchSellerCrops();
    _fetchSellerMachine();
  }

  Future<void> _fetchCrops() async {
    try {
      final cropsSnapshot = await FirebaseFirestore.instance
          .collection('farmer')
          .doc("SvEArqH9fSnsbgPwFVcr")
          .collection('crops')
          .get();

      List<Map<String, dynamic>> fetchedCrops = cropsSnapshot.docs.map((doc) {
        return {
          'cropName': doc['cropName'] ?? 'Unknown Crop',
          'encryptedImage': doc['encryptedImage'] ?? '',
          'price': doc['price'] ?? '0',
          'cropDescription': doc['cropDescription'] ?? '0',
          'category': doc['category'] ?? '0',
          'quantity': doc['quantity'] ?? '0',
          'timestamp': doc['timestamp'] ?? '',
          'harvestDate': doc['harvestDate'] ?? '',
        };
      }).toList();

      setState(() {
        yourProducts = fetchedCrops;
      });
    } catch (e) {
      setState(() {
        yourProducts = [];
      });
    }
  }

  Future<void> _fetchSellerCrops() async {
    try {
      final sellerCropsSnapshot = await FirebaseFirestore.instance
          .collection('seller')
          .doc('DEj50uZRGx13YxYf5wT4')
          .collection('seeds')
          .get();

      List<Map<String, dynamic>> fetchedSellerCrops = sellerCropsSnapshot.docs.map((doc) {
        return {
          'encryptedImage': doc['encryptedImage'] ?? '',
          'seedName': doc['seedName'] ?? 'Unknown Seed',
          'price': doc['price'] ?? '0',
          'quantity': doc['quantity'] ?? '0',
          'location': doc['location'] ?? 'Unknown Location',
          'isNegotiable': doc['isNegotiable'] ?? false,
          'timestamp': doc['timestamp'] ?? '',
        };
      }).toList();

      setState(() {
        sellerProducts = fetchedSellerCrops;
      });
    } catch (e) {
      setState(() {
        sellerProducts = [];
      });
    }
  }

  Future<void> _fetchSellerMachine() async {
    try {
      final sellerMachinesSnapshot = await FirebaseFirestore.instance
          .collection('seller')
          .doc('qwZiJSWOagNHJDRmXVhe')
          .collection('machines')
          .get();

      List<Map<String, dynamic>> fetchedSellerMachines = sellerMachinesSnapshot.docs.map((doc) {
        return {
          'encryptedImage': doc['encryptedImage'] ?? '',
          'machineName': doc['machineName'] ?? 'Unknown Machine',
          'price': doc['price'] ?? '0',
          'maintenanceDetails': doc['maintenanceDetails'] ?? '0',
          'usageHistory': doc['usageHistory'] ?? '0',
          'isRental': doc['isRental'] ?? false,
          'isNegotiable': doc['isNegotiable'] ?? false,
          'timestamp': doc['timestamp'] ?? '',
        };
      }).toList();

      setState(() {
        sellerMachineProducts = fetchedSellerMachines;
      });
    } catch (e) {
      setState(() {
        sellerMachineProducts = [];
      });
    }
  }

  Future<void> _fetchWeather() async {
    try {
      Position position = await _determinePosition();
      Weather weather = await _wf.currentWeatherByLocation(position.latitude, position.longitude);
      setState(() {
        _weather = weather;
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching weather: $e';
      });
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  List<Widget> _buildScreens() {
    return [
      Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[700],
          title: const Text('Welcome to Your Farm App'),
          actions: [
            IconButton(
  icon: const Icon(Icons.notifications),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NotificationScreen()),
    );
  },
)
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _weatherDetailsCard(),
              const SizedBox(height: 20),
              _sectionTitle('Your Products'),
              _buildYourProductsCarousel(),
              const SizedBox(height: 20),
              _sectionTitle('Seller Products'),
              _buildSellerCarousel(),
              const SizedBox(height: 20),
              _sectionTitle('Seller Machines'),
              _buildSellerMachineCarousel(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddMoreScreen()),
            );
          },
          backgroundColor: Colors.green[800],
          icon: const Icon(Icons.add_shopping_cart),
          label: const Text('Sell Crop'),
        ),
      ),
      const Scaffold(
        body: ProductListScreen(),
      ),
      Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[700],
          title: const Text('Payment'),
        ),
        body: const Center(child: Text('Payment Screen')),
      ),
      const Scaffold(
        body: ProfileScreen(),
      ),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: "Home",
        activeColorPrimary: Colors.green[700]!,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.shopping_basket),
        title: "Products",
        activeColorPrimary: Colors.green[700]!,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.payment),
        title: "Payment",
        activeColorPrimary: Colors.green[700]!,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.menu),
        title: "Menu",
        activeColorPrimary: Colors.green[700]!,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineToSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      navBarStyle: NavBarStyle.style6,
    );
  }

  Widget _weatherDetailsCard() {
    if (_errorMessage != null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            _errorMessage!,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    if (_weather == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _weather?.areaName ?? 'Weather Details',
            style: _sectionTitleStyle(),
          ),
          const SizedBox(height: 10),
          Text(
            DateFormat('h:mm a, EEEE d.M.y').format(_weather!.date!),
            style: TextStyle(fontSize: 16, color: Colors.green[800]),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.network(
                "http://openweathermap.org/img/wn/${_weather?.weatherIcon}@2x.png",
                height: 60,
              ),
              Column(
                children: [
                  Text(
                    "${_weather?.temperature?.celsius?.toStringAsFixed(0)}° C",
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _weather?.weatherDescription ?? '',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Max: ${_weather?.tempMax?.celsius?.toStringAsFixed(0)}° C",
                style: const TextStyle(fontSize: 15),
              ),
              Text(
                "Min: ${_weather?.tempMin?.celsius?.toStringAsFixed(0)}° C",
                style: const TextStyle(fontSize: 15),
              ),
              Text(
                "Wind: ${_weather?.windSpeed?.toStringAsFixed(0)} m/s",
                style: const TextStyle(fontSize: 15),
              ),
              Text(
                "Humidity: ${_weather?.humidity?.toStringAsFixed(0)}%",
                style: const TextStyle(fontSize: 15),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.green[800],
      ),
    );
  }

  TextStyle _sectionTitleStyle() {
    return TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.green[800],
    );
  }

  Widget _buildYourProductsCarousel() {
    if (yourProducts.isEmpty) {
      return Center(
        child: Text(
          'No products available',
          style: TextStyle(color: Colors.green[800], fontSize: 16),
        ),
      );
    }

    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        viewportFraction: 0.9,
      ),
      items: yourProducts.map((product) {
        return Builder(
          builder: (BuildContext context) {
            return Card(
              color: Colors.green[50],
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Show product name or fallback to "Unknown"
                    Text(
                      product['cropName'] ?? 'Unknown Crop',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),

                    // Show price or fallback to "Price not available"
                    Text(
                      "Price: ${product['price'] ?? 'Price not available'}",
                      style: TextStyle(color: Colors.green[800]),
                    ),

                    // Show quantity or fallback to "Quantity not available"
                    Text(
                      "Quantity: ${product['quantity'] ?? 'Quantity not available'}",
                      style: TextStyle(color: Colors.green[800]),
                    ),

                    // Show harvest date or fallback to "Date not available"
                    Text(
                      "Harvest Date: ${product['harvestDate'] ?? 'Date not available'}",
                      style: TextStyle(color: Colors.green[800]),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildSellerCarousel() {
    if (sellerProducts.isEmpty) {
      return Center(
        child: Text(
          'No seller products available',
          style: TextStyle(color: Colors.green[800], fontSize: 16),
        ),
      );
    }

    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
      ),
      items: sellerProducts.map((product) {
        return Builder(
          builder: (BuildContext context) {
            return Card(
              color: Colors.green[50],
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['seedName'] ?? 'Unknown Seed',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                    Text(
                      "Price: ${product['price'] ?? 'Price not available'}",
                      style: TextStyle(color: Colors.green[800]),
                    ),
                    Text(
                      "Location: ${product['location'] ?? 'Location not available'}",
                      style: TextStyle(color: Colors.green[800]),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildSellerMachineCarousel() {
    if (sellerMachineProducts.isEmpty) {
      return Center(
        child: Text(
          'No seller machines available',
          style: TextStyle(color: Colors.green[800], fontSize: 16),
        ),
      );
    }

    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
      ),
      items: sellerMachineProducts.map((product) {
        return Builder(
          builder: (BuildContext context) {
            return Card(
              color: Colors.green[50],
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['machineName'] ?? 'Unknown Machine',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                    Text(
                      "Price: ${product['price'] ?? 'Price not available'}",
                      style: TextStyle(color: Colors.green[800]),
                    ),
                    Text(
                      "Maintenance: ${product['maintenanceDetails'] ?? 'Details not available'}",
                      style: TextStyle(color: Colors.green[800]),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
