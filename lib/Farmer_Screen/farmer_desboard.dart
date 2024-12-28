// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

// import 'add_more.dart';
// import 'home_screen.dart';
// import 'menu_screen.dart';
// import 'payment_screen.dart';
// import 'product_screen.dart';

// class FarmerDashboard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       debugShowCheckedModeBanner: false,
//       routerConfig: _router,
//     );
//   }

//   final GoRouter _router = GoRouter(
//     routes: [
//       GoRoute(
//         path: '/',
//         builder: (context, state) => MainScreen(),
//       ),
//       GoRoute(
//         path: '/add-more',
//         builder: (context, state) => const AddMoreScreen(),
//       ),
//     ],
//   );

//   FarmerDashboard({super.key});
// }

// class MainScreen extends StatelessWidget {
//   final PersistentTabController _controller =
//       PersistentTabController(initialIndex: 0);

//   MainScreen({super.key});

//   List<Widget> _buildScreens() {
//     return [
//       const HomePage(),
//       ProductListScreen(),
//       const PaymentScreen(),
//       const MenuScreen(),
//     ];
//   }

//   List<PersistentBottomNavBarItem> _navBarsItems() {
//     return [
//       PersistentBottomNavBarItem(
//         icon: const Icon(Icons.home),
//         title: "Home",
//         activeColorPrimary: Colors.green[700]!,
//         inactiveColorPrimary: Colors.grey,
//       ),
//       PersistentBottomNavBarItem(
//         icon: const Icon(Icons.shopping_basket),
//         title: "Products",
//         activeColorPrimary: Colors.green[700]!,
//         inactiveColorPrimary: Colors.grey,
//       ),
//       PersistentBottomNavBarItem(
//         icon: const Icon(Icons.payment),
//         title: "Payment",
//         activeColorPrimary: Colors.green[700]!,
//         inactiveColorPrimary: Colors.grey,
//       ),
//       PersistentBottomNavBarItem(
//         icon: const Icon(Icons.menu),
//         title: "Menu",
//         activeColorPrimary: Colors.green[700]!,
//         inactiveColorPrimary: Colors.grey,
//       ),
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PersistentTabView(
//       context,
//       controller: _controller,
//       screens: _buildScreens(),
//       items: _navBarsItems(),
//       confineToSafeArea: true,
//       backgroundColor: Colors.white,
//       handleAndroidBackButtonPress: true,
//       resizeToAvoidBottomInset: true,
//       stateManagement: true,
//       navBarStyle: NavBarStyle.style6,
//     );
//   }
// }
