import 'package:flutter/material.dart';
import 'web_colors.dart';
import 'web_typography.dart';

/// Main Web Parity Theme System matching ATLAS.BC0.0.1/web/frontend exactly
class WebParityTheme {
  WebParityTheme._();

  /// Get the complete theme data matching web frontend
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: WebTypography.fontFamily,

      // Color scheme matching web CSS
      colorScheme: ColorScheme.fromSeed(
        seedColor: WebColors.primary,
        brightness: Brightness.light,
        primary: WebColors.primary,
        secondary: WebColors.secondary,
        surface: WebColors.surface,
        error: WebColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: WebColors.textPrimary,
        onError: Colors.white,
      ),

      // Background color matching web body
      scaffoldBackgroundColor: WebColors.backgroundLight,

      // App bar theme matching web header
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: WebTypography.h1,
        iconTheme: const IconThemeData(color: WebColors.textPrimary),
        centerTitle: true,
      ),

      // Card theme matching web nav-card and card styling
      cardTheme: CardThemeData(
        color: WebColors.cardBackground,
        elevation: 0,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: WebColors.borderCard,
            width: 1,
          ),
        ),
      ),

      // Elevated button theme matching web nav-btn
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: WebColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          textStyle: WebTypography.button,
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
      ),

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: WebColors.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          textStyle: WebTypography.button,
        ),
      ),

      // Input decoration theme matching web form-control
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: WebColors.formBorder, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: WebColors.formBorder, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: WebColors.primary, width: 2),
        ),
        filled: true,
        fillColor: WebColors.surface,
        contentPadding: const EdgeInsets.all(12),
        hintStyle: WebTypography.formInput.copyWith(color: WebColors.textMuted),
        labelStyle: WebTypography.formLabel,
      ),

      // List tile theme matching web styling
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),

      // Divider theme matching web borders
      dividerTheme: const DividerThemeData(
        color: WebColors.border,
        thickness: 1,
        space: 1,
      ),

      // Text theme using web typography
      textTheme: TextTheme(
        displayLarge: WebTypography.h1,
        displayMedium: WebTypography.h2,
        displaySmall: WebTypography.h3,
        headlineLarge: WebTypography.h2,
        headlineMedium: WebTypography.h3,
        headlineSmall: WebTypography.h4,
        titleLarge: WebTypography.navCardTitle,
        titleMedium: WebTypography.formLabel,
        titleSmall: WebTypography.caption,
        bodyLarge: WebTypography.body1,
        bodyMedium: WebTypography.body2,
        bodySmall: WebTypography.caption,
        labelLarge: WebTypography.button,
        labelMedium: WebTypography.statusText,
        labelSmall: WebTypography.infoLabel,
      ),
    );
  }

  /// Animation durations matching web CSS transitions
  static const Duration transitionFast = Duration(milliseconds: 200);
  static const Duration transitionNormal = Duration(milliseconds: 300);
  static const Duration transitionSlow = Duration(milliseconds: 400);

  /// Animation curves matching web CSS cubic-bezier
  static const Curve easeInOut = Cubic(0.4, 0.0, 0.2, 1.0);
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeIn = Curves.easeIn;

  /// Spacing system matching web CSS padding and margins
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;

  /// Container and component spacing
  static const double containerPadding = 20.0;
  static const double cardPadding = 25.0;
  static const double navCardPadding = 20.0;
  static const double navBarPadding = 25.0;

  /// Border radius values matching web CSS
  static const double radiusXs = 6.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;

  /// Responsive breakpoints matching web CSS media queries
  static const double mobileBreakpoint = 480.0;
  static const double tabletBreakpoint = 768.0;
  static const double desktopBreakpoint = 1024.0;
  static const double maxContainerWidth = 1400.0;

  /// Navigation card dimensions matching web CSS
  static const double navCardHeight = 240.0;
  static const double navCardMinWidth = 180.0;
  static const double navCardMobileHeight = 220.0;

  /// Grid layout settings matching web CSS
  static const double gridGap = 20.0;
  static const double gridGapMobile = 15.0;
  static const int gridColumnsDesktop = 4;
  static const int gridColumnsTablet = 2;
  static const int gridColumnsMobile = 1;

  /// Architecture card settings
  static const double architectureCardMinWidth = 220.0;
  static const double architectureCardPadding = 20.0;

  /// Status indicator settings
  static const double statusDotSize = 8.0;
  static const Duration pulseAnimationDuration = Duration(seconds: 2);

  /// Helper method to get responsive grid columns
  static int getGridColumns(double screenWidth) {
    if (screenWidth >= desktopBreakpoint) {
      return gridColumnsDesktop;
    } else if (screenWidth >= tabletBreakpoint) {
      return gridColumnsTablet;
    } else {
      return gridColumnsMobile;
    }
  }

  /// Helper method to get responsive spacing
  static double getResponsiveSpacing(double screenWidth) {
    return screenWidth <= mobileBreakpoint ? gridGapMobile : gridGap;
  }

  /// Helper method to get responsive nav card height
  static double getNavCardHeight(double screenWidth) {
    return screenWidth <= mobileBreakpoint
        ? navCardMobileHeight
        : navCardHeight;
  }

  /// Helper method to check if screen is mobile
  static bool isMobile(double screenWidth) {
    return screenWidth <= mobileBreakpoint;
  }

  /// Helper method to check if screen is tablet
  static bool isTablet(double screenWidth) {
    return screenWidth > mobileBreakpoint && screenWidth <= tabletBreakpoint;
  }

  /// Helper method to check if screen is desktop
  static bool isDesktop(double screenWidth) {
    return screenWidth > tabletBreakpoint;
  }
}
