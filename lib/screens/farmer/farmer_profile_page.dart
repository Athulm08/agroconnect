import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agroconnect/utils/constants.dart';

class FarmerProfilePage extends StatefulWidget {
  const FarmerProfilePage({super.key});

  @override
  State<FarmerProfilePage> createState() => _FarmerProfilePageState();
}

class _FarmerProfilePageState extends State<FarmerProfilePage> {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  // --- SAFE SIGN OUT METHOD ---
  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Guard against async gaps
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil('/auth', (route) => false);
    } catch (e) {
      debugPrint("Error signing out: $e");
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
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: kBackgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      // Use a FutureBuilder to fetch user data asynchronously
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
        future: currentUser != null
            ? FirebaseFirestore.instance
                  .collection(usersCollection)
                  .doc(currentUser!.uid)
                  .get()
            : null,
        builder: (context, snapshot) {
          // --- LOADING STATE ---
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: kAccentColor),
            );
          }
          // --- ERROR STATE ---
          if (snapshot.hasError ||
              !snapshot.hasData ||
              !snapshot.data!.exists) {
            return Center(
              child: Text(
                'Could not load profile data.',
                style: kBodyTextStyle.copyWith(color: kErrorColor),
              ),
            );
          }
          // --- SUCCESS STATE ---
          if (currentUser == null) {
            return const Center(child: Text('Not logged in.'));
          }

          final userData = snapshot.data!.data();
          final String email =
              userData?['email'] ?? currentUser!.email ?? 'No email';
          final String role = userData?['role'] ?? 'No role';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Column(
              children: [
                // --- PROFILE HEADER ---
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: kPrimaryColor,
                  child: Icon(Icons.person, size: 60, color: Colors.white),
                ),
                const SizedBox(height: kDefaultPadding),
                Text(email, style: kSubheadingStyle),
                const SizedBox(height: kDefaultPadding / 2),
                Chip(
                  label: Text(
                    role.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: kPrimaryLightColor,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                const SizedBox(height: kDefaultPadding),
                const Divider(),
                const SizedBox(height: kDefaultPadding),

                // --- MENU OPTIONS ---
                _buildProfileMenuOption(
                  icon: Icons.edit_outlined,
                  title: 'Edit Profile',
                  onTap: () {},
                ),
                _buildProfileMenuOption(
                  icon: Icons.shield_outlined,
                  title: 'Privacy Policy',
                  onTap: () {},
                ),
                _buildProfileMenuOption(
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  onTap: () {},
                ),

                const SizedBox(height: kDefaultPadding * 2),

                // --- SIGN OUT BUTTON ---
                ElevatedButton.icon(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text('Sign Out', style: kButtonTextStyle),
                  onPressed: _signOut,
                  style: ElevatedButton.styleFrom(
                    // --- FIX APPLIED HERE ---
                    backgroundColor: kErrorColor.withAlpha(
                      204,
                    ), // Replaced withOpacity(0.8)
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(kDefaultRadius),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// A helper widget to build reusable menu list tiles.
  Widget _buildProfileMenuOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: kPrimaryColor),
      title: Text(title, style: kBodyTextStyle.copyWith(color: kTextColor)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
