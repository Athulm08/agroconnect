import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:agroconnect/screens/auth/signup_page.dart';

// App constants for theming and configuration
import 'package:agroconnect/utils/constants.dart';

// Import all the screens that will be used in navigation
import 'package:agroconnect/screens/auth/login_page.dart';
import 'package:agroconnect/screens/auth/role_selection.dart';
// NOTE: You will need to create register_screen.dart and the dashboard screens
// For now, a placeholder HomeScreen is used after login.

void main() async {
  // Ensure Flutter bindings are initialized before calling Firebase
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase using the generated firebase_options.dart
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgroConnect',
      debugShowCheckedModeBanner: false,

      // --- THEME DEFINITION ---
      // This theme uses your constants to style the entire app consistently.
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Poppins', // (Optional) Add a custom font in pubspec.yaml
        appBarTheme: const AppBarTheme(
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white, // Color for text and icons in AppBar
          elevation: 0.5,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: kPrimaryColor, // Color for text buttons
          ),
        ),
      ),

      // --- ROUTING LOGIC ---
      // The `home` property is set to AuthGate. This widget will decide which
      // screen to show first, making `initialRoute` unnecessary.
      home: const AuthGate(),

      // The `routes` map defines all possible named navigation paths.
      // This is what fixes the "Could not find a generator for route" error.
      routes: {
        '/login': (context) => const LoginScreen(),
        '/role-selection': (context) => const RoleSelectionScreen(),

        '/register': (context) => const SignupScreen(role: 'consumer'),

        '/home': (context) => const HomeScreen(),
      },
    );
  }
}

// --- AUTHENTICATION GATE ---
// This widget listens to Firebase authentication changes and displays the
// correct screen automatically.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If the snapshot is still waiting, show a loading indicator.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // If the user is logged IN, navigate them to the HomeScreen.
        if (snapshot.hasData) {
          return const HomeScreen();
        }

        // If the user is logged OUT, show the LoginScreen.
        return const LoginScreen();
      },
    );
  }
}

// --- PLACEHOLDER HOME SCREEN ---
// This is a temporary screen for logged-in users.
// In the future, this screen will check the user's role (Farmer/Consumer)
// from Firestore and then navigate to the correct dashboard.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current user to display their email
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          // Add a logout button to the AppBar
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // The AuthGate will automatically navigate to the LoginScreen
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Successfully Logged In!\n\nEmail: ${user?.email ?? "No email"}',
          textAlign: TextAlign.center,
          style: kBodyTextStyle,
        ),
      ),
    );
  }
}
