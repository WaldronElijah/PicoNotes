import 'package:flutter/material.dart';

class AppTheme {
  // Colors from Figma design
  static const Color primaryBackground = Color(0xFF000000);
  static const Color secondaryBackground = Color(0xFF2C2C2E);
  static const Color toolbarBackground = Color(0xFF323233);
  static const Color primaryText = Color(0xFFFFFFFF);
  static const Color secondaryText = Color(0xFF707071);
  static const Color tertiaryText = Color(0xFF8E8E93);
  static const Color accentBlue = Color(0xFF3375F8);
  static const Color groupedBackground = Color(0xFFF2F2F7);
  
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: primaryBackground,
      fontFamily: 'SF Pro Text',
      
      // Text themes
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: primaryText,
          fontSize: 24,
          fontWeight: FontWeight.w900,
          fontFamily: 'SF Pro Text',
        ),
        headlineMedium: TextStyle(
          color: primaryText,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: 'SF Pro Text',
        ),
        headlineSmall: TextStyle(
          color: primaryText,
          fontSize: 16,
          fontWeight: FontWeight.w900,
          fontFamily: 'SF Pro Text',
          letterSpacing: -0.24,
        ),
        bodyLarge: TextStyle(
          color: primaryText,
          fontSize: 17,
          fontFamily: 'SF Pro Text',
        ),
        bodyMedium: TextStyle(
          color: primaryText,
          fontSize: 16,
          fontFamily: 'SF Pro Text',
        ),
        bodySmall: TextStyle(
          color: secondaryText,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          fontFamily: 'SF Pro Text',
          letterSpacing: -0.18,
        ),
        labelMedium: TextStyle(
          color: primaryText,
          fontSize: 13,
          fontWeight: FontWeight.w500,
          fontFamily: 'SF Pro Text',
        ),
      ),
      
      // App bar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: secondaryBackground,
        foregroundColor: primaryText,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: primaryText,
          fontSize: 16,
          fontWeight: FontWeight.w900,
          fontFamily: 'SF Pro Text',
          letterSpacing: -0.24,
        ),
      ),
      
      // Bottom sheet theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: secondaryBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
      ),
      
      // Input decoration theme
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: tertiaryText,
          fontSize: 16,
          fontFamily: 'SF Pro Text',
        ),
      ),
      
      // Icon theme
      iconTheme: const IconThemeData(
        color: primaryText,
      ),
      
      // Color scheme
      colorScheme: const ColorScheme.dark(
        primary: accentBlue,
        secondary: accentBlue,
        surface: secondaryBackground,
        background: primaryBackground,
        onPrimary: primaryText,
        onSecondary: primaryText,
        onSurface: primaryText,
        onBackground: primaryText,
      ),
    );
  }
  
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: groupedBackground,
      fontFamily: 'SF Pro Text',
      
      // Text themes
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.w900,
          fontFamily: 'SF Pro Text',
        ),
        headlineMedium: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: 'SF Pro Text',
        ),
        headlineSmall: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w900,
          fontFamily: 'SF Pro Text',
          letterSpacing: -0.24,
        ),
        bodyLarge: TextStyle(
          color: Colors.black,
          fontSize: 17,
          fontFamily: 'SF Pro Text',
        ),
        bodyMedium: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontFamily: 'SF Pro Text',
        ),
        bodySmall: TextStyle(
          color: tertiaryText,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          fontFamily: 'SF Pro Text',
          letterSpacing: -0.18,
        ),
        labelMedium: TextStyle(
          color: Colors.black,
          fontSize: 13,
          fontWeight: FontWeight.w500,
          fontFamily: 'SF Pro Text',
        ),
      ),
      
      // Color scheme
      colorScheme: const ColorScheme.light(
        primary: accentBlue,
        secondary: accentBlue,
        surface: Colors.white,
        background: groupedBackground,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.black,
        onBackground: Colors.black,
      ),
    );
  }
} 