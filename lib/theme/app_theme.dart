import 'package:flutter/material.dart';
import 'package:memmerli/theme/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primary1,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary1,
        secondary: AppColors.secondary1,
        background: AppColors.accent2,
        surface: AppColors.white,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.accent2,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary1,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary1,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.primary2,
        ),
        displayMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.primary2,
        ),
        displaySmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.primary2,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: AppColors.primary2,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: AppColors.primary2,
        ),
      ),
      cardColor: AppColors.white,
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: AppColors.primary1,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary1,
        secondary: AppColors.secondary1,
        background: AppColors.primary2,
        surface: Color(0xFF303030),
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.primary2,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary1,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary1,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF303030),
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.accent2,
        ),
        displayMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.accent2,
        ),
        displaySmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.accent2,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: AppColors.accent2,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: AppColors.accent2,
        ),
      ),
      cardColor: const Color(0xFF303030),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}