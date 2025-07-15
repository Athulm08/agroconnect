// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

// THE CORRECT IMPORTS: Using the '_screen.dart' file names
import 'screens/auth/signup_page.dart'; // Corrected Path
import 'screens/home_screen.dart';
import 'screens/auth/login_page.dart'; // Corrected Path

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
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const AuthGate(),
      // THE CORRECT ROUTES: Using the '...Screen' class names
      routes: {
        '/login': (context) => const LoginScreen(), // Corrected Class Name
        '/signup': (context) => const SignupScreen(), // Corrected Class Name
        '/home': (context) => const HomeScreen(),
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
        // User is not signed in
        if (!snapshot.hasData) {
          return const LoginScreen(); // Corrected Class Name
        }

        // User is signed in
        return const HomeScreen();
      },
    );
  }
}
