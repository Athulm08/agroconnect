import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:agroconnect/utils/constants.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/foundation.dart'; // <-- Import foundation for debugPrint

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // --- UPLOAD IMAGE TO CLOUDINARY ---
  Future<String> uploadImageToCloudinary(File imageFile) async {
    // IMPORTANT: Replace with your Cloudinary details
    final cloudinary = CloudinaryPublic(
      'dadqmzixu',
      'agroconnect_unsigned',
      cache: false,
    );

    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imageFile.path,
          resourceType: CloudinaryResourceType.Image,
        ),
      );
      // Return the secure URL of the uploaded image
      return response.secureUrl;
    } on CloudinaryException catch (e) {
      // --- FIX APPLIED HERE ---
      // Use debugPrint for development-only logging.
      debugPrint('Cloudinary Error: ${e.message}');
      debugPrint('Cloudinary Request: ${e.request}');
      throw Exception('Failed to upload image. Please try again.');
    }
  }

  // --- ADD PRODUCT TO FIRESTORE ---
  Future<void> addProduct({
    required String name,
    required String description,
    required double price,
    required String imageUrl,
  }) async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('You must be logged in to add a product.');
    }

    await _firestore.collection(productsCollection).add({
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'farmerId': currentUser.uid,
      'farmerName':
          currentUser.displayName ??
          'Anonymous Farmer', // Or fetch from a user profile
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
