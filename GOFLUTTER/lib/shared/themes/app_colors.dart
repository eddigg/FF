import 'package:flutter/material.dart';

/// App color palette for consistent styling across the application
class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF3B82F6);
  static const Color primaryLight = Color(0xFF60A5FA);
  static const Color primaryDark = Color(0xFF2563EB);

  // Secondary colors
  static const Color secondary = Color(0xFF10B981);
  static const Color secondaryLight = Color(0xFF34D399);
  static const Color secondaryDark = Color(0xFF059669);

  // Background colors
  static const Color background = Color(0xFF111827);
  static const Color backgroundMid = Color(0xFF1F2937);
  static const Color surface = Color(0xFF1F2937);
  static const Color card = Color(0xFF374151);

  // Text colors
  static const Color textPrimary = Color(0xFFF9FAFB);
  static const Color textSecondary = Color(0xFFD1D5DB);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textMuted = Color(0xFF6B7280);

  // Status colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Border colors
  static const Color border = Color(0xFF4B5563);
  static const Color borderLight = Color(0xFF6B7280);
  static const Color divider = Color(0xFF374151);

  // Gradient colors
  static const List<Color> primaryGradient = [primary, primaryDark];
  static const List<Color> secondaryGradient = [secondary, secondaryDark];
  static const Gradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [background, backgroundMid],
  );
  static const Gradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [surface, card],
  );
  static const Gradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [success, Color(0xFF059669)],
  );
  static const Gradient warningGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [warning, Color(0xFFD97706)],
  );
}
