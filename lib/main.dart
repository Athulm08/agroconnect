import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'signup_page.dart';
import 'home_screen.dart';
import 'login_page.dart'; // Assuming you have a login page

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
      title: 'Flutter Firebase Auth',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AuthGate(),
      routes: {
        '/login': (context) =>
            const LoginPage(), // Make sure you have a LoginPage
        '/signup': (context) => const SignupPage(),
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
          return const LoginPage(); // Or SignupPage() if you want that as the initial screen
        }

        // User is signed in
        return const HomeScreen();
      },
    );
  }
}
