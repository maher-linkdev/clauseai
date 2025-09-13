import 'package:flutter/material.dart';

class ColorsPalette {
  ColorsPalette._();

  // Primary Colors
  static const Color primary = Color(0xFF5B4FCF);
  static const Color primaryDark = Color(0xFF4039A8);
  static const Color primaryLight = Color(0xFF7B70E3);

  // Secondary Colors
  static const Color secondary = Color(0xFF00BFA5);
  static const Color secondaryDark = Color(0xFF00897B);
  static const Color secondaryLight = Color(0xFF4EDDC5);

  // Background Colors
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // Text Colors
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF607D8B);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF1A1A1A);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Neutral Colors
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);
  static const Color greyDark = Color(0xFF434343);

  // Accent Colors for Document Categories
  static const Color obligationsAccent = Color(0xFF7C4DFF);
  static const Color risksAccent = Color(0xFFFF5252);
  static const Color paymentAccent = Color(0xFF00BCD4);
  static const Color liabilitiesAccent = Color(0xFFFF6E40);

  // Compatibility aliases for commonly used properties
  static const Color surface = surfaceLight;
  static const Color background = backgroundLight;
  static const Color border = grey300;
  static const Color accent = secondary;
}
