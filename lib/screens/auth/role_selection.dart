import 'package:flutter/material.dart';
import 'package:agroconnect/screens/auth/signup_page.dart'; // Assuming a common registration screen
import 'package:agroconnect/utils/constants.dart'; // For consistent styling
import 'package:agroconnect/widgets/custom_button.dart'; // Reusable custom button

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Your Role'),
        backgroundColor: kPrimaryColor, // Consistent theme color
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Title Text
              const Text(
                'Welcome to AgroConnect!',
                style: TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12.0),
              const Text(
                'Please select how you would like to use the app.',
                style: TextStyle(fontSize: 16.0, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60.0),

              // Farmer Role Selection Button
              CustomButton(
                text: 'I am a Farmer',
                onPressed: () {
                  // Navigate to the registration screen, passing the 'farmer' role
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignupScreen(role: 'farmer'),
                    ),
                  );
                },
                icon: Icons.agriculture, // Farmer-related icon
              ),
              const SizedBox(height: 24.0),

              // Consumer Role Selection Button
              CustomButton(
                text: 'I am a Consumer',
                onPressed: () {
                  // Navigate to the registration screen, passing the 'consumer' role
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const SignupScreen(role: 'consumer'),
                    ),
                  );
                },
                icon: Icons.shopping_cart, // Consumer-related icon
              ),
            ],
          ),
        ),
      ),
    );
  }
}
