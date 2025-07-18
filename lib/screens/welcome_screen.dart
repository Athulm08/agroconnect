import 'package:flutter/material.dart';
// The import for 'login_page.dart' has been removed as it was unused.

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen size for responsive layout
    final size = MediaQuery.of(context).size;

    return Scaffold(
      // Use a Stack to layer the background image and the content
      body: Stack(
        fit: StackFit.expand,
        children: [
          // --- BACKGROUND IMAGE ---
          Image.asset(
            'assets/images/welcome_background.png',
            fit: BoxFit.cover, // Cover the entire screen
          ),

          // --- CONTENT OVERLAY ---
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: size.height * 0.45, // About 45% of the screen height
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // --- HEADING TEXT ---
                    const Text(
                      'The next generation of farming',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    // --- SUBHEADING TEXT ---
                    const Text(
                      'We provide data that enables the goals of global agriculture.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Poppins',
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 40.0),

                    // --- GET STARTED BUTTON ---
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFF4B3832,
                        ), // Dark brown color
                        foregroundColor: Colors.white, // Text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40.0,
                          vertical: 16.0,
                        ),
                      ),
                      onPressed: () {
                        // Navigate to the AuthGate. It will then decide whether to show
                        // the Login screen or the user's dashboard.
                        // Using pushReplacementNamed prevents the user from going back
                        // to the welcome screen.
                        Navigator.pushReplacementNamed(context, '/auth');
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Get Started',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Icon(Icons.arrow_forward, size: 20.0),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
