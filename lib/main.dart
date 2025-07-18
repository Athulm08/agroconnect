import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // <-- Import foundation for debugPrint
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

// App constants for theming and configuration
import 'package:agroconnect/utils/constants.dart';

// --- Import all the screens that will be used in navigation ---
import 'package:agroconnect/screens/auth/login_page.dart';
import 'package:agroconnect/screens/auth/role_selection.dart';
import 'package:agroconnect/screens/auth/signup_page.dart';
import 'package:agroconnect/screens/consumer_dashboard.dart';
import 'package:agroconnect/screens/farmer_dashboard.dart';
import 'package:agroconnect/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Poppins',
        appBarTheme: const AppBarTheme(
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
          elevation: 0.5,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: kPrimaryColor),
        ),
      ),
      home: const AuthGate(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/role-selection': (context) => const RoleSelectionScreen(),
        '/register': (context) => const SignupScreen(role: 'consumer'),
        '/home': (context) => const HomeScreen(),
        '/farmer-dashboard': (context) => const FarmerDashboard(),
        '/consumer-dashboard': (context) => const ConsumerDashboard(),
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return const RoleBasedRedirect();
        }
        return const LoginScreen();
      },
    );
  }
}

class RoleBasedRedirect extends StatelessWidget {
  const RoleBasedRedirect({super.key});

  Future<String?> _getUserRole(String uid) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      if (docSnapshot.exists) {
        return docSnapshot.get('role');
      }
    } catch (e) {
      // --- FIX: Replaced 'print' with 'debugPrint' ---
      // This is the recommended way to log errors during development.
      if (kDebugMode) {
        // kDebugMode ensures this only runs in debug build
        debugPrint('Error fetching user role: $e');
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const LoginScreen();
    }

    return FutureBuilder<String?>(
      future: _getUserRole(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return const HomeScreen();
        }
        final role = snapshot.data;
        if (role == 'farmer') {
          return const FarmerDashboard();
        } else if (role == 'consumer') {
          return const ConsumerDashboard();
        }
        return const HomeScreen();
      },
    );
  }
}
