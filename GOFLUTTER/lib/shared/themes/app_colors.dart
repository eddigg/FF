import 'package:flutter/material.dart';

/// Color palette matching the web frontend's design system
class AppColors {
  AppColors._();

  // Primary colors from the web frontend
  static const Color primary = Color(0xFF4299E1); // Primary blue
  static const Color primaryDark = Color(0xFF3182CE); // Darker blue
  static const Color secondary = Color(0xFF48BB78); // Success green
  static const Color tertiary = Color(0xFF9F7AEA); // Purple accent
  static const Color purple = Color(0xFF9F7AEA); // Purple color for governance

  // Background colors matching web gradient
  static const Color background = Color(0xFFF8FAFC); // Main background color
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color backgroundMid = Color(0xFFE2E8F0);
  static const Color backgroundDark = Color(0xFFCBD5E0);

  // Surface and card colors
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceOpaque =
      Color(0xF5FFFFFF); // rgba(255,255,255,0.95)
  static const Color border = Color(0xFFE2E8F0); // Added missing border color

  // Text colors from web
  static const Color textPrimary = Color(0xFF1A202C);
  static const Color textSecondary = Color(0xFF4A5568);
  static const Color textMuted = Color(0xFF718096);

  // Status colors
  static const Color success = Color(0xFF38A169);
  static const Color error = Color(0xFFE53E3E);
  static const Color warning = Color(0xFFED8936);
  static const Color info = Color(0xFF3182CE);

  // DeFi specific colors
  static const Color defiGreen = Color(0xFF11998e);
  static const Color defiGreenDark = Color(0xFF0D7A6F);

  // Gradient definitions matching web CSS
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    // Added missing secondaryGradient
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6C757D), Color(0xFF5A6268)],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
    colors: [backgroundLight, backgroundMid, backgroundDark],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2D3748), Color(0xFF4A5568), Color(0xFF718096)],
  );

  static const LinearGradient walletGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [defiGreen, defiGreenDark],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, success],
  );

  static const LinearGradient warningGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [warning, Color(0xFFDD6B20)],
  );

  static const LinearGradient infoGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [info, primary],
  );
}

/// Spacing system matching web design
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

/// Typography system matching Inter font from web
class AppTextStyles {
  AppTextStyles._();

  // Headers matching web h1, h2 styles
  static const TextStyle h1 = TextStyle(
    fontSize: 56.0, // 3.5rem converted to mobile
    fontWeight: FontWeight.w800,
    letterSpacing: -0.02,
    color: AppColors.textPrimary,
    height: 1.1,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 40.0, // 2.5rem converted
    fontWeight: FontWeight.w700,
    letterSpacing: -0.01,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 35.2, // 2.2rem
    fontWeight: FontWeight.w700,
    letterSpacing: -0.01,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static const TextStyle h4 = TextStyle(
    fontSize: 22.4, // 1.4rem
    fontWeight: FontWeight.w600,
    letterSpacing: -0.01,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle h5 = TextStyle(
    // Added missing h5
    fontSize: 18.0, // Example size, adjust as needed
    fontWeight: FontWeight.w600,
    letterSpacing: -0.01,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  // Body text styles
  static const TextStyle body1 = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.01,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle body2 = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.01,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.01,
    color: AppColors.textMuted,
    height: 1.3,
  );

  // Button text styles
  static const TextStyle button = TextStyle(
    fontSize: 14.4, // 0.9rem
    fontWeight: FontWeight.w600,
    letterSpacing: 0.01,
    height: 1.2,
  );

  static const TextStyle buttonLarge = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.01,
    height: 1.2,
  );

  // Specialized text styles
  static const TextStyle address = TextStyle(
    fontFamily: 'monospace',
    fontSize: 12.0, // 0.75rem
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.2,
  );

  static const TextStyle balance = TextStyle(
    fontSize: 28.8, // 1.8rem
    fontWeight: FontWeight.w700,
    color: AppColors.surface,
    height: 1.1,
  );
}

/// Shadow styles matching web box-shadow
class AppShadows {
  AppShadows._();

  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x14000000), // rgba(0,0,0,0.08)
      offset: Offset(0, 20),
      blurRadius: 40,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x0F000000), // rgba(0,0,0,0.06)
      offset: Offset(0, 8),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> cardHover = [
    BoxShadow(
      color: Color(0x1F000000), // rgba(0,0,0,0.12)
      offset: Offset(0, 25),
      blurRadius: 50,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x14000000), // rgba(0,0,0,0.08)
      offset: Offset(0, 12),
      blurRadius: 24,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> button = [
    BoxShadow(
      color: Color(0x19000000), // rgba(0,0,0,0.1)
      offset: Offset(0, 8),
      blurRadius: 25,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> buttonHover = [
    BoxShadow(
      color: Color(0x26000000), // rgba(0,0,0,0.15)
      offset: Offset(0, 12),
      blurRadius: 30,
      spreadRadius: 0,
    ),
  ];
}
