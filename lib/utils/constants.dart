import 'package:flutter/material.dart';

// A centralized place for constant values used throughout the AgroConnect app.
// Using constants helps in maintaining consistency and makes future updates easier.

// --- COLOR CONSTANTS ---
// These colors define the visual theme of the application.
const kPrimaryColor = Color(0xFF4CAF50); // A strong, nature-like green
const kPrimaryLightColor = Color(
  0xFFC8E6C9,
); // A lighter shade of the primary color
const kAccentColor = Color(
  0xFFFF9800,
); // An orange accent for buttons or highlights
const kTextColor = Color(
  0xFF333333,
); // Dark grey for primary text for readability
const kTextSecondaryColor = Color(
  0xFF757575,
); // Lighter grey for subtitles or secondary text
const kBackgroundColor = Color(
  0xFFF5F5F5,
); // A very light grey for screen backgrounds
const kErrorColor =
    Colors.redAccent; // Color for error messages or validation failures

// --- PADDING & SPACING ---
// Standardized padding and spacing values to ensure a consistent layout.
const double kDefaultPadding = 20.0;
const double kDefaultRadius = 12.0;
const double kDefaultMargin = 16.0;

// --- TEXT STYLES ---
// Predefined text styles to ensure typographic consistency.
const TextStyle kHeadingStyle = TextStyle(
  fontSize: 28.0,
  fontWeight: FontWeight.bold,
  color: kTextColor,
  height: 1.2,
);

const TextStyle kSubheadingStyle = TextStyle(
  fontSize: 22.0,
  fontWeight: FontWeight.w600,
  color: kTextColor,
);

const TextStyle kBodyTextStyle = TextStyle(
  fontSize: 16.0,
  color: kTextSecondaryColor,
  height: 1.5,
);

const TextStyle kButtonTextStyle = TextStyle(
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

// --- FIREBASE COLLECTION NAMES ---
// Storing collection names as constants prevents typos and eases future updates.
// This is a critical best practice for working with Firebase.
const String usersCollection = 'users';
const String productsCollection = 'products';
const String ordersCollection = 'orders';


// --- ASSET PATHS (Example) ---
// If you had local assets like a logo or placeholder images, you would define their paths here.
// const String kLogoPath = 'assets/images/agroconnect_logo.png';