import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:agroconnect/services/auth_service.dart';
import 'package:agroconnect/utils/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (mounted) Navigator.of(context).pushReplacementNamed('/auth');
    } on FirebaseAuthException catch (e) {
      debugPrint('Email/Password login failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Incorrect email or password.'),
            backgroundColor: kErrorColor,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isGoogleLoading = true);
    try {
      final userCredential = await _authService.signInWithGoogle();
      if (userCredential != null && mounted) {
        Navigator.of(context).pushReplacementNamed('/auth');
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Google sign-in failed. Please try again.'),
            backgroundColor: kErrorColor,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // The background color is now applied to the container, not the Scaffold,
      // to prevent the green screen flash if the layout fails.
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: Container(
          height:
              screenHeight, // Ensure the container takes up the full screen height
          color: kPrimaryColor, // The green background is now here
          child: Stack(
            children: [
              // --- HEADER SECTION (REMAINS THE SAME) ---
              Positioned(
                top: screenHeight * 0.1,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    const Icon(Icons.grass, color: Colors.white, size: 90),
                    const SizedBox(height: 16),
                    Text(
                      'Hello!',
                      style: kHeadingStyle.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Welcome to AgroConnect',
                      style: kSubheadingStyle.copyWith(
                        color: Colors.white70,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),

              // --- LOGIN FORM SECTION ---
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  // Use a fraction of the screen height to ensure it fits
                  height: screenHeight * 0.68,
                  padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultPadding * 1.5,
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
                    // --- REVISED COLUMN LAYOUT ---
                    child: Column(
                      // Use spaceAround to distribute vertical space evenly and robustly
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text('Login', style: kSubheadingStyle),

                        // --- INPUT FIELDS GROUP ---
                        Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              decoration: _buildInputDecoration(
                                'Email',
                                Icons.email_outlined,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) => (v == null || !v.contains('@'))
                                  ? 'Enter a valid email'
                                  : null,
                            ),
                            const SizedBox(height: kDefaultPadding),
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
                                        () => _obscurePassword =
                                            !_obscurePassword,
                                      ),
                                    ),
                                  ),
                              validator: (v) => (v == null || v.length < 6)
                                  ? 'Password is too short'
                                  : null,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => Navigator.of(
                                  context,
                                ).pushNamed('/forgot-password'),
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(color: kPrimaryColor),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // --- BUTTONS GROUP ---
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: kAccentColor,
                                    ),
                                  )
                                : ElevatedButton(
                                    onPressed: _login,
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
                                      'Login',
                                      style: kButtonTextStyle,
                                    ),
                                  ),
                            const SizedBox(height: kDefaultPadding),
                            _buildSocialLoginDivider(),
                            const SizedBox(height: kDefaultPadding),
                            _isGoogleLoading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: kAccentColor,
                                    ),
                                  )
                                : OutlinedButton.icon(
                                    icon: Image.asset(
                                      'assets/images/google_logo.png',
                                      height: 24,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.login),
                                    ),
                                    label: const Text(
                                      'Sign in with Google',
                                      style: TextStyle(
                                        color: kTextColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: _signInWithGoogle,
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: kDefaultPadding * 0.8,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          kDefaultRadius,
                                        ),
                                      ),
                                      side: const BorderSide(
                                        color: kTextSecondaryColor,
                                      ),
                                    ),
                                  ),
                          ],
                        ),

                        // --- SIGN UP LINK ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account?",
                              style: kBodyTextStyle,
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(
                                context,
                              ).pushNamed('/role-selection'),
                              child: const Text(
                                'Sign Up',
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
      ),
    );
  }

  // Helper widgets remain unchanged
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

  Widget _buildSocialLoginDivider() {
    return const Row(
      children: [
        Expanded(child: Divider(color: Colors.black26)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text('Or', style: TextStyle(color: kTextSecondaryColor)),
        ),
        Expanded(child: Divider(color: Colors.black26)),
      ],
    );
  }
}
