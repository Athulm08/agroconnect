import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agroconnect/utils/constants.dart';

class SignupScreen extends StatefulWidget {
  final String role;

  const SignupScreen({super.key, required this.role});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // All state and methods remain unchanged
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _isLoading = true);

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      await FirebaseFirestore.instance
          .collection(usersCollection)
          .doc(userCredential.user!.uid)
          .set({
            'email': _emailController.text.trim(),
            'role': widget.role,
            'createdAt': FieldValue.serverTimestamp(),
          });

      if (mounted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/auth', (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists for that email.';
      } else {
        message = 'An error occurred. Please try again.';
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: kErrorColor),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An unexpected error occurred: ${e.toString()}'),
            backgroundColor: kErrorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final displayRole = widget.role[0].toUpperCase() + widget.role.substring(1);

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Image.asset(
              'assets/images/auth_background.png',
              height: screenHeight,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Container(
              height: screenHeight,
              width: double.infinity,
              decoration: BoxDecoration(
                // --- FIX APPLIED HERE ---
                color: kPrimaryColor.withAlpha(217),
              ),
            ),
            Positioned(
              top: screenHeight * 0.1,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  const Icon(
                    Icons.person_add_alt_1,
                    color: Colors.white,
                    size: 90,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Create Account',
                    style: kHeadingStyle.copyWith(
                      color: Colors.white,
                      fontSize: 26,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Signing up as a $displayRole',
                    style: kSubheadingStyle.copyWith(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: screenHeight * 0.7,
                padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding * 1.5,
                  vertical: kDefaultPadding,
                ),
                decoration: const BoxDecoration(
                  color: kBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Form content remains the same
                      TextFormField(
                        controller: _emailController,
                        decoration: _buildInputDecoration(
                          'Email',
                          Icons.email_outlined,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || !value.contains('@')) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration:
                            _buildInputDecoration(
                              'Password',
                              Icons.lock_outline,
                            ).copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: kPrimaryLightColor,
                                ),
                                onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                              ),
                            ),
                        validator: (value) {
                          if (value == null || value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        decoration:
                            _buildInputDecoration(
                              'Confirm Password',
                              Icons.lock_person_outlined,
                            ).copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: kPrimaryLightColor,
                                ),
                                onPressed: () => setState(
                                  () => _obscureConfirmPassword =
                                      !_obscureConfirmPassword,
                                ),
                              ),
                            ),
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: kAccentColor,
                              ),
                            )
                          : ElevatedButton(
                              onPressed: _signUp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryColor,
                                padding: const EdgeInsets.symmetric(
                                  vertical: kDefaultPadding * 0.8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    kDefaultRadius,
                                  ),
                                ),
                              ),
                              child: const Text(
                                'Sign Up',
                                style: kButtonTextStyle,
                              ),
                            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account?",
                            style: kBodyTextStyle,
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(
                              context,
                            ).pushReplacementNamed('/login'),
                            child: const Text(
                              'Log In',
                              style: TextStyle(
                                color: kAccentColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget remains unchanged
  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      hintText: label,
      prefixIcon: Icon(icon, color: kPrimaryLightColor),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kDefaultRadius),
        borderSide: BorderSide.none,
      ),
    );
  }
}
