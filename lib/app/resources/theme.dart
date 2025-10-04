import 'package:flutter/material.dart';
import 'package:listen_to_my_tracks/app/resources/colors.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTheme {
  const AppTheme._();

  // Font Family
  static final String _fontFamily = GoogleFonts.poppins().fontFamily!;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: _fontFamily,
      scaffoldBackgroundColor: AppColors.lightBackground,
      primaryColor: AppColors.primary,

      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.primaryLight,
        surface: AppColors.lightSurface,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onSurface: AppColors.onLightSurface,
        error: AppColors.error,
        onError: AppColors.white,
      ),

      textTheme: _textTheme.apply(
        bodyColor: AppColors.onLightSurface,
        displayColor: AppColors.onLightSurface,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightBackground,
        foregroundColor: AppColors.onLightSurface,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
      ),

      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: AppColors.lightSurface,
        surfaceTintColor: Colors.transparent,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(
          color: AppColors.lightSecondaryText.withValues(alpha: 0.8),
          fontWeight: FontWeight.w400,
        ),
      ),

      listTileTheme: const ListTileThemeData(iconColor: AppColors.primary),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: _fontFamily,
      scaffoldBackgroundColor: AppColors.darkBackground,
      primaryColor: AppColors.primary,

      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.primaryLight,
        surface: AppColors.darkSurface,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onSurface: AppColors.onDarkSurface,
        error: AppColors.error,
        onError: AppColors.white,
      ),

      textTheme: _textTheme.apply(
        bodyColor: AppColors.onDarkSurface,
        displayColor: AppColors.onDarkSurface,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.onDarkSurface,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
      ),

      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: AppColors.darkSurface,
        surfaceTintColor: Colors.transparent,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(
          color: AppColors.darkSecondaryText.withValues(alpha: 0.8),
          fontWeight: FontWeight.w400,
        ),
      ),

      listTileTheme: const ListTileThemeData(iconColor: AppColors.primaryLight),
    );
  }

  static const TextTheme _textTheme = TextTheme(
    headlineMedium: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
    titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    titleMedium: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
    bodyLarge: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
    bodyMedium: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
    labelLarge: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 14,
      letterSpacing: 0.5,
    ),
  );
}
