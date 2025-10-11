import 'package:flutter/material.dart';

// App spacing constants that can be used in const expressions
class AppSpacing {
  AppSpacing._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  // Card and component padding
  static const double cardPadding = 25.0;
  static const double containerPadding = 20.0;

  // Border radius values
  static const double radiusXs = 6.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
}

// App text styles
class AppTextStyles {
  AppTextStyles._();

  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Color(0xFF1A202C),
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Color(0xFF1A202C),
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Color(0xFF1A202C),
  );

  static const TextStyle h4 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Color(0xFF1A202C),
  );

  static const TextStyle h5 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Color(0xFF1A202C),
  );

  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    color: Color(0xFF1A202C),
  );

  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    color: Color(0xFF4A5568),
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: Color(0xFF718096),
  );

  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle address = TextStyle(
    fontSize: 12,
    fontFamily: 'monospace',
    color: Color(0xFF718096),
  );

  static const TextStyle balance = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}

// App colors
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF4299E1);
  static const Color secondary = Color(0xFF48BB78);
  static const Color error = Color(0xFFE53E3E);
  static const Color success = Color(0xFF38A169);
  static const Color warning = Color(0xFFED8936);
  static const Color info = Color(0xFF3182CE);

  static const Color surface = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF8FAFC);
  static const Color backgroundMid = Color(0xFFE2E8F0);

  static const Color textPrimary = Color(0xFF1A202C);
  static const Color textSecondary = Color(0xFF4A5568);
  static const Color textMuted = Color(0xFF718096);

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFFF8FAFC), Color(0xFFE2E8F0)],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF4299E1), Color(0xFF3182CE)],
  );
}

