import 'package:flutter/material.dart';
import 'web_colors.dart';

/// Web parity typography system matching Inter font family from web CSS
class WebTypography {
  WebTypography._();

  // Font family matching web CSS
  static const String fontFamily = 'Inter';

  // Header styles matching web CSS exactly - using const TextStyle to avoid Google Fonts in tests
  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 56.0, // 3.5rem
    fontWeight: FontWeight.w800,
    letterSpacing: -0.02,
    color: WebColors.textPrimary,
    height: 1.1,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28.8, // 1.8rem
    fontWeight: FontWeight.w700,
    letterSpacing: -0.01,
    color: WebColors.textPrimary,
    height: 1.2,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22.4, // 1.4rem
    fontWeight: FontWeight.w600,
    letterSpacing: -0.01,
    color: WebColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle h4 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20.0, // 1.25rem
    fontWeight: FontWeight.w600,
    letterSpacing: -0.01,
    color: WebColors.textPrimary,
    height: 1.3,
  );

  // Subtitle matching web CSS
  static const TextStyle subtitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20.0, // 1.25rem
    fontWeight: FontWeight.w500,
    letterSpacing: 0.01,
    color: WebColors.textSecondary,
    height: 1.4,
  );

  // Button text styles matching web CSS
  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.4, // 0.9rem
    fontWeight: FontWeight.w600,
    letterSpacing: 0.01,
    height: 1.2,
  );

  // Body text styles matching web CSS (these already use const TextStyle, so no change needed)
  static const TextStyle body1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.0, // 1rem
    fontWeight: FontWeight.w400,
    letterSpacing: 0.01,
    color: WebColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle body2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15.2, // 0.95rem
    fontWeight: FontWeight.w400,
    letterSpacing: 0.01,
    color: WebColors.textSecondary,
    height: 1.5,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.4, // 0.9rem
    fontWeight: FontWeight.w400,
    letterSpacing: 0.01,
    color: WebColors.textMuted,
    height: 1.4,
  );

  static const TextStyle buttonLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.0, // 1rem
    fontWeight: FontWeight.w500,
    letterSpacing: 0.01,
    height: 1.2,
  );

  // Navigation card text styles
  static const TextStyle navCardTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.0, // 1rem
    fontWeight: FontWeight.bold,
    letterSpacing: 0.01,
    color: WebColors.textPrimary,
    height: 1.2,
  );

  static const TextStyle navCardDescription = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15.2, // 0.95rem
    fontWeight: FontWeight.w400,
    letterSpacing: 0.01,
    color: WebColors.textSecondary,
    height: 1.5,
  );

  // Form and input text styles
  static const TextStyle formLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.4, // 0.9rem
    fontWeight: FontWeight.w600,
    letterSpacing: 0.01,
    color: WebColors.textSecondary,
    height: 1.3,
  );

  static const TextStyle formInput = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.0, // 1rem
    fontWeight: FontWeight.w400,
    letterSpacing: 0.01,
    color: WebColors.textPrimary,
    height: 1.4,
  );

  // Specialized text styles
  static const TextStyle monospace = TextStyle(
    fontFamily: 'Courier New',
    fontSize: 12.8, // 0.8rem
    fontWeight: FontWeight.w400,
    color: WebColors.hashText,
    height: 1.2,
  );

  static const TextStyle monospaceSmall = TextStyle(
    fontFamily: 'Courier New',
    fontSize: 14.4, // 0.9rem
    fontWeight: FontWeight.w400,
    color: WebColors.hashText,
    height: 1.2,
  );

  // Status and info text styles
  static const TextStyle statusText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.4, // 0.9rem
    fontWeight: FontWeight.w600,
    letterSpacing: 0.01,
    height: 1.3,
  );

  static const TextStyle infoLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.4, // 0.9rem
    fontWeight: FontWeight.w400,
    letterSpacing: 0.01,
    color: WebColors.textMuted,
    height: 1.3,
  );

  static const TextStyle infoValue = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17.6, // 1.1rem
    fontWeight: FontWeight.w600,
    letterSpacing: 0.01,
    color: WebColors.textPrimary,
    height: 1.3,
  );

  // Stat display text styles
  static const TextStyle statValue = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32.0, // 2rem
    fontWeight: FontWeight.bold,
    letterSpacing: -0.01,
    color: WebColors.primary,
    height: 1.1,
  );

  static const TextStyle statLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.4, // 0.9rem
    fontWeight: FontWeight.w400,
    letterSpacing: 0.01,
    color: WebColors.textMuted,
    height: 1.3,
  );
}