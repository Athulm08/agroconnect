import 'package:flutter/material.dart';
import 'package:agroconnect/utils/constants.dart';

// Import the pages for the dashboard tabs
import 'package:agroconnect/screens/farmer/orders_page.dart';
import 'package:agroconnect/screens/farmer/products_page.dart';
import 'package:agroconnect/screens/farmer/saved_page.dart';
import 'package:agroconnect/screens/farmer/settings_page.dart';

// Import the page for adding a new product
import 'package:agroconnect/screens/farmer/add_product_page.dart';

class FarmerDashboard extends StatefulWidget {
  const FarmerDashboard({super.key});

  @override
  State<FarmerDashboard> createState() => _FarmerDashboardState();
}

class _FarmerDashboardState extends State<FarmerDashboard> {
  // --- CHANGE 1: Set the default index to 0 ---
  // This makes the first item in the list the default page.
  int _selectedIndex = 0;

  // --- CHANGE 2: Reorder the list of pages ---
  // ProductsPage is now at index 0 and OrdersPage is at index 1.
  static const List<Widget> _pages = <Widget>[
    ProductsPage(), // Corresponds to index 0
    OrdersPage(), // Corresponds to index 1
    SavedPage(), // Corresponds to index 2
    SettingsPage(), // Corresponds to index 3
  ];

  /// Changes the selected page index when a navigation item is tapped.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body displays the widget from the _pages list at the current index.
      body: _pages.elementAt(_selectedIndex),

      // The central floating action button for adding new products.
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the Add Product screen when the button is pressed.
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductPage()),
          );
        },
        backgroundColor: kPrimaryColor,
        shape: const CircleBorder(), // Makes the button perfectly round.
        child: const Icon(Icons.add_shopping_cart, color: Colors.white),
      ),

      // Docks the floating action button in the center of the bottom app bar.
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // The custom bottom navigation bar.
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape:
            const CircularNotchedRectangle(), // Creates the "notch" for the FAB.
        notchMargin: 8.0, // Sets the space around the notch.
        elevation: 8.0, // Adds a subtle shadow.
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            // Distributes the icons evenly.
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // --- CHANGE 3: Swap the navigation items to match the new order ---
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

              // This SizedBox creates the gap in the middle for the notch.
              const SizedBox(width: 40),

              // Right side items remain the same.
              _buildNavItem(
                icon: Icons.bookmark_border,
                index: 2,
                label: 'Saved',
              ),
              _buildNavItem(
                icon: Icons.settings_outlined,
                index: 3,
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// A helper widget to build each navigation item to avoid code repetition.
  /// Includes the icon and the small indicator dot.
  Widget _buildNavItem({
    required IconData icon,
    required int index,
    required String label,
  }) {
    final bool isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      borderRadius: BorderRadius.circular(
        20,
      ), // Makes the ripple effect circular.
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Takes up minimum vertical space.
          children: [
            Icon(
              icon,
              // The color changes based on whether the item is selected.
              color: isSelected ? kPrimaryColor : kTextSecondaryColor,
              size: 26,
            ),
            const SizedBox(height: 4),
            // The small indicator dot is only shown if the item is selected.
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
              // Add an empty SizedBox to maintain layout consistency.
              const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
