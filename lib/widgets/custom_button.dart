import 'package:flutter/material.dart';

/// A reusable custom button widget for the AgroConnect app.
///
/// This button can be customized with text, an icon, and an action.
/// It uses an [ElevatedButton] for a consistent Material Design look.
class CustomButton extends StatelessWidget {
  /// The text to display on the button.
  final String text;

  /// The callback function that is called when the button is tapped.
  final VoidCallback onPressed;

  /// An optional icon to display to the left of the text.
  final IconData? icon;

  /// The background color of the button. Defaults to the theme's primary color.
  final Color? color;

  /// The color of the text and icon. Defaults to white.
  final Color? textColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        // Use the provided color, or default to green for the app's theme
        backgroundColor: color ?? Colors.green,
        // Set a fixed height and padding for a consistent size
        minimumSize: const Size(double.infinity, 50),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        // Define the shape with rounded corners
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        // Set elevation for a subtle shadow
        elevation: 5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // If an icon is provided, display it
          if (icon != null) Icon(icon, color: textColor ?? Colors.white),
          // Add spacing between icon and text if both are present
          if (icon != null) const SizedBox(width: 10),
          // The button's text label
          Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textColor ?? Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
