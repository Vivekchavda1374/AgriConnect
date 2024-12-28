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

  List<String> yourProducts = [];
  List<String> sellerProducts = [];

  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  @override
  void initState() {
    super.initState();
    _fetchWeather();
    _fetchCrops();
  }

  Future<void> _fetchCrops() async {
    try {
      final cropsSnapshot = await FirebaseFirestore.instance
          .collection('farmer')
          .doc("SvEArqH9fSnsbgPwFVcr") // Replace with your dynamic farmerId
          .collection('crops')
          .get();

      List<String> fetchedCrops = cropsSnapshot.docs.map((doc) {
        return doc['cropName'] as String ?? 'Unknown Crop';
      }).toList();

      setState(() {
        yourProducts = fetchedCrops;
        sellerProducts = fetchedCrops; // Optionally, you can use different data for seller products
      });
    } catch (e) {
      print('Error fetching crops: $e');
      setState(() {
        yourProducts = []; // Ensure the list is empty if fetch fails
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

  void _addProduct(String product) {
    setState(() {
      yourProducts.add(product);
      sellerProducts.add(product);
    });
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
              onPressed: () {},
            ),
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
              _sectionTitle('Events'),
              _buildCard('Events', 'Upcoming events...'),
              const SizedBox(height: 20),
              _sectionTitle('Seller Products'),
              _buildSellerCarousel(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Replaced GoRouter navigation with Navigator.push
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddMoreScreen()),
            );
          },
          backgroundColor: Colors.green[800],
          icon: const Icon(Icons.add_shopping_cart),
          label: const Text('Sell Crop'),
        ),
      ),
      Scaffold(
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
        height: 180.0, // Different height for the first carousel
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        viewportFraction: 0.7, // Different viewportFraction for the first carousel
      ),
      items: yourProducts.map((product) {
        return Builder(
          builder: (BuildContext context) {
            return Card(
              color: Colors.green[100],
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    product,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildCard(String title, String subtitle) {
    return Card(
      color: Colors.green[50],
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          title: Text(title),
          subtitle: Text(subtitle),
        ),
      ),
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
        height: 200.0, // Different height for the second carousel
        autoPlay: false, // No auto-play for the seller products carousel
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        viewportFraction: 0.7, // Different viewportFraction for the second carousel
      ),
      items: sellerProducts.map((product) {
        return Builder(
          builder: (BuildContext context) {
            return Card(
              color: Colors.green[100],
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    product,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
