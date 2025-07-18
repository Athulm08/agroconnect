// lib/services/auth_service.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agroconnect/utils/constants.dart'; // For collection names

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // SIGN IN WITH GOOGLE
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // 1. Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // The user canceled the sign-in
        return null;
      }

      // 2. Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 3. Create a new credential for Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Sign in to Firebase with the credential
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      final User? user = userCredential.user;

      // 5. For new users, create a document in the users collection
      if (user != null && userCredential.additionalUserInfo!.isNewUser) {
        await _firestore.collection(usersCollection).doc(user.uid).set({
          'email': user.email,
          'displayName': user.displayName,
          'createdAt': FieldValue.serverTimestamp(),
          // Default role for Google Sign-In users.
          // You could navigate them to a role selection screen after this.
          'role': 'consumer',
        });
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific errors
      debugPrint("FirebaseAuthException: ${e.message}");
      return null;
    } catch (e) {
      // Handle other errors
      debugPrint("Error during Google sign-in: $e");
      return null;
    }
  }
}
