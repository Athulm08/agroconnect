import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:agroconnect/utils/constants.dart'; // Using constants for styling

// Convert the widget to a StatefulWidget to access the 'mounted' property.
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<void> _signOut() async {
    try {
      // The asynchronous operation
      await FirebaseAuth.instance.signOut();

      // --- FIX APPLIED HERE ---
      // Check if the widget is still in the widget tree before using its context.
      if (!mounted) return;

      // If it's still mounted, it's safe to use the context for navigation.
      Navigator.of(context).pushNamedAndRemoveUntil('/auth', (route) => false);
    } catch (e) {
      debugPrint("Error signing out: $e");
      // Optionally show an error message if sign-out fails
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error signing out. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: kBackgroundColor,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // You can add more settings options here, e.g., Profile, Notifications, etc.
              const Spacer(), // Pushes the button to the bottom
              // SIGN OUT BUTTON
              ElevatedButton.icon(
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text('Sign Out', style: kButtonTextStyle),
                onPressed: _signOut, // Call the safe sign-out method
                style: ElevatedButton.styleFrom(
                  backgroundColor: kErrorColor,
                  padding: const EdgeInsets.symmetric(
                    vertical: kDefaultPadding * 0.8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kDefaultRadius),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
