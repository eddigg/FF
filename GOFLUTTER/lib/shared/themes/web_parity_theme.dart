import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'web_colors.dart';
import 'web_gradients.dart';
import 'web_typography.dart';

/// Theme class that provides styling consistent with the web application
class WebParityTheme {
  // Spacing constants
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double containerPadding = 16.0;
  static const double cardPadding = 16.0;
  static const double architectureCardPadding = 25.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusXl = 24.0;
  static const double navBarPadding = 16.0;
  static const double navCardPadding = 12.0;

  // Duration constants
  static const Duration transitionNormal = Duration(milliseconds: 300);

  // Text styles
  static TextStyle get cardTitleStyle => WebTypography.h4.copyWith(
    color: WebColors.textPrimary,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get panelTitleStyle => WebTypography.h3.copyWith(
    color: WebColors.textPrimary,
    fontWeight: FontWeight.w600,
  );

  // Utility functions
  static int getGridColumns(double maxWidth) {
    if (maxWidth > 1200) return 4;
    if (maxWidth > 768) return 3;
    if (maxWidth > 480) return 2;
    return 1;
  }

  static double getResponsiveSpacing(double maxWidth) {
    if (maxWidth > 1200) return spacingLg;
    if (maxWidth > 768) return spacingMd;
    return spacingSm;
  }

  // Button styles
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: const Color(
      0xFF667EEA,
    ), // Use direct color to avoid import issues
    foregroundColor: Colors.white,
    textStyle: WebTypography.button,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusMd),
    ),
  );

  static ButtonStyle get secondaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF4A5568), // Gray color for secondary
    foregroundColor: Colors.white,
    textStyle: WebTypography.button,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusMd),
    ),
  );

  static ButtonStyle get warningButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFFED8936), // Orange color for warning
    foregroundColor: Colors.white,
    textStyle: WebTypography.button,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusMd),
    ),
  );

  static ButtonStyle get dangerButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFFF56565), // Red color for danger
    foregroundColor: Colors.white,
    textStyle: WebTypography.button,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusMd),
    ),
  );

  static ButtonStyle get successButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF48BB78), // Green color for success
    foregroundColor: Colors.white,
    textStyle: WebTypography.button,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusMd),
    ),
  );

  // Input decoration
  static InputDecoration inputDecoration(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: WebTypography.body2.copyWith(color: WebColors.textMuted),
    filled: true,
    fillColor: WebColors.surface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusMd),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusMd),
      borderSide: const BorderSide(
        color: Color(0xFF667EEA),
      ), // Use direct color to avoid import issues
    ),
  );

  // Get the theme data
  static ThemeData getThemeData() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF667EEA),
        secondary: Color(0xFF48BB78),
        background: Color(0xFF667EEA),
        surface: Color(0xFF764BA2),
        error: Color(0xFFEF4444),
      ),
      scaffoldBackgroundColor: const Color(0xFF667EEA),
      cardColor: Colors.white.withOpacity(0.1),
      textTheme: GoogleFonts.interTextTheme(
        const TextTheme(
          displayLarge: TextStyle(
            fontSize: 56.0,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
          displayMedium: TextStyle(
            fontSize: 48.0,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          displaySmall: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          headlineLarge: TextStyle(
            fontSize: 28.8,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          headlineMedium: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          headlineSmall: TextStyle(
            fontSize: 21.0,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          titleLarge: TextStyle(
            fontSize: 21.0,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          titleMedium: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
          titleSmall: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
          bodyLarge: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
          bodyMedium: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
            color: Colors.white70,
          ),
          bodySmall: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: Colors.white54,
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF764BA2),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: Color(0xFF48BB78),
        textTheme: ButtonTextTheme.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF48BB78),
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.white),
          textStyle: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Colors.white.withOpacity(0.1),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF48BB78)),
        ),
      ),
    );
  }
}
