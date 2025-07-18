import 'package:flutter/material.dart';
import 'package:agroconnect/utils/constants.dart'; // Your app constants

// Import the pages you just created
import 'package:agroconnect/screens/farmer/orders_page.dart';
import 'package:agroconnect/screens/farmer/products_page.dart';
import 'package:agroconnect/screens/farmer/saved_page.dart';
import 'package:agroconnect/screens/farmer/settings_page.dart';

class FarmerDashboard extends StatefulWidget {
  const FarmerDashboard({super.key});

  @override
  State<FarmerDashboard> createState() => _FarmerDashboardState();
}

class _FarmerDashboardState extends State<FarmerDashboard> {
  int _selectedIndex = 0; // The currently selected tab index

  // List of the pages to be displayed
  static const List<Widget> _pages = <Widget>[
    OrdersPage(),
    ProductsPage(),
    SavedPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body will display the page corresponding to the selected tab
      body: _pages.elementAt(_selectedIndex),

      // The central floating action button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add New Item (Not Implemented)')),
          );
        },
        backgroundColor: kPrimaryColor,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.eco,
          color: Colors.white,
        ), // The central leaf icon
      ),

      // Dock the FAB in the center
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // The custom bottom navigation bar
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape:
            const CircularNotchedRectangle(), // Creates the notch for the FAB
        notchMargin: 8.0, // The space around the notch
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Left side icons
              _buildNavItem(icon: Icons.list_alt_outlined, index: 0),
              _buildNavItem(icon: Icons.grass_outlined, index: 1),

              const SizedBox(width: 40), // The space for the notch
              // Right side icons
              _buildNavItem(icon: Icons.bookmark_border, index: 2),
              _buildNavItem(icon: Icons.settings_outlined, index: 3),
            ],
          ),
        ),
      ),
    );
  }

  // --- HELPER WIDGET to build each navigation item ---
  Widget _buildNavItem({required IconData icon, required int index}) {
    final bool isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? kPrimaryColor : kTextSecondaryColor,
              size: 26,
            ),
            const SizedBox(height: 4),
            // The small dot under the active icon
            if (isSelected)
              Container(
                height: 5,
                width: 5,
                decoration: const BoxDecoration(
                  color: kPrimaryColor,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
