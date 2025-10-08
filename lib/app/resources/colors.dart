import 'package:flutter/material.dart';

// A centralized place for all application colors.
// Using a class like this helps maintain a consistent color palette
// and makes theming easier.
abstract class AppColors { 
  const AppColors._();

  // Main Palette Colors
  static const Color primary = Color(0xFF2ec4b6);
  static const Color primaryLight = Color(0xFF55dde0);
  
  // Light Theme Colors
  static const Color lightBackground = Color(0xFFF7F7FA);
  static const Color lightSurface = Colors.white;
  static const Color onLightSurface = Color(0xFF1B1B1F);
  static const Color lightSecondaryText = Color(0xFF6C6C7E);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF1B1B1F);
  static const Color darkSurface = Color(0xFF2F2F37);
  static const Color onDarkSurface = Color(0xFFE4E1E6);
  static const Color darkSecondaryText = Color(0xFF9E9CAE);

  // Semantic Colors
  // Use these for specific states, like validation messages or alerts.
  static const Color error = Color(0xFFB00020);
  static const Color warning = Color(0xFFFFC107); // Amber color, widely used for warnings
  static const Color onWarning = Colors.black; // Black provides good contrast on amber

  // Common Colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Color(0xFFBDBDBD);
}