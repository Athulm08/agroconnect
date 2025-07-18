import 'package:flutter/material.dart';
import 'package:agroconnect/utils/constants.dart';

// Import the pages for the dashboard tabs
import 'package:agroconnect/screens/farmer/products_page.dart';
import 'package:agroconnect/screens/farmer/orders_page.dart';
import 'package:agroconnect/screens/farmer/saved_page.dart';
// --- CHANGE 1: Import the new FarmerProfilePage ---
import 'package:agroconnect/screens/farmer/farmer_profile_page.dart';

// Import the page for adding a new product
import 'package:agroconnect/screens/farmer/add_product_page.dart';

class FarmerDashboard extends StatefulWidget {
  const FarmerDashboard({super.key});

  @override
  State<FarmerDashboard> createState() => _FarmerDashboardState();
}

class _FarmerDashboardState extends State<FarmerDashboard> {
  int _selectedIndex = 0;

  // --- CHANGE 2: Replace SettingsPage with FarmerProfilePage ---
  static const List<Widget> _pages = <Widget>[
    ProductsPage(), // Index 0
    OrdersPage(), // Index 1
    SavedPage(), // Index 2
    FarmerProfilePage(), // Index 3 (The new profile page)
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.elementAt(_selectedIndex),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductPage()),
          );
        },
        backgroundColor: kPrimaryColor,
        shape: const CircleBorder(),
        child: const Icon(Icons.add_shopping_cart, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        elevation: 8.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // --- CHANGE 3: The label for the last icon is now "Profile" ---
              _buildNavItem(
                icon: Icons.grass_outlined,
                index: 0,
                label: 'Products',
              ),
              _buildNavItem(
                icon: Icons.list_alt_outlined,
                index: 1,
                label: 'Orders',
              ),
              const SizedBox(width: 40),
              _buildNavItem(
                icon: Icons.bookmark_border,
                index: 2,
                label: 'Saved',
              ),
              _buildNavItem(
                icon: Icons.person_outline,
                index: 3,
                label: 'Profile',
              ), // Updated icon and label
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required int index,
    required String label,
  }) {
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
            // The indicator dot logic remains the same
            if (isSelected)
              Container(
                height: 5,
                width: 5,
                decoration: const BoxDecoration(
                  color: kPrimaryColor,
                  shape: BoxShape.circle,
                ),
              )
            else
              const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
