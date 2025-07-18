import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConsumerDashboard extends StatelessWidget {
  const ConsumerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consumer Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // The AuthGate will handle navigation to the login screen
            },
          ),
        ],
      ),
      body: Center(child: Text('Welcome Consumer!')),
    );
  }
}
