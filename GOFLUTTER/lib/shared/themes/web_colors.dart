import 'package:flutter/material.dart';

/// Web parity color system matching ATLAS.BC0.0.1/web/frontend/index.html exactly
class WebColors {
  WebColors._();

  // Primary colors from web CSS
  static const Color primary = Color(0xFF4299E1); // #4299e1
  static const Color primaryDark = Color(0xFF3182CE); // #3182ce
  static const Color secondary = Color(0xFF48BB78); // #48bb78
  static const Color secondaryDark = Color(0xFF38A169); // #38a169

  // Background colors matching web gradient
  static const Color backgroundLight = Color(0xFFF8FAFC); // #f8fafc
  static const Color backgroundMid = Color(0xFFE2E8F0); // #e2e8f0
  static const Color backgroundDark = Color(0xFFCBD5E0); // #cbd5e0

  // Text colors from web
  static const Color textPrimary = Color(0xFF1A202C); // #1a202c
  static const Color textSecondary = Color(0xFF4A5568); // #4a5568
  static const Color textMuted = Color(0xFF718096); // #718096

  // Surface and card colors
  static const Color surface = Color(0xFFFFFFFF); // white
  static const Color surfaceOpaque =
      Color(0xF2FFFFFF); // rgba(255,255,255,0.95)
  static const Color cardBackground =
      Color(0xE6FFFFFF); // rgba(255,255,255,0.9)

  // Border colors
  static const Color border = Color(0xFFE2E8F0); // #e2e8f0
  static const Color borderLight = Color(0x33FFFFFF); // rgba(255,255,255,0.2)
  static const Color borderCard = Color(0x4DFFFFFF); // rgba(255,255,255,0.3)

  // Status colors
  static const Color success = Color(0xFF48BB78); // #48bb78
  static const Color successDark = Color(0xFF38A169); // #38a169
  static const Color warning = Color(0xFFED8936); // #ed8936
  static const Color warningDark = Color(0xFFDD6B20); // #dd6b20
  static const Color error = Color(0xFFE53E3E); // #e53e3e
  static const Color info = Color(0xFF4299E1); // #4299e1

  // Button variant colors
  static const Color buttonSecondary = Color(0xFF6C757D); // #6c757d
  static const Color buttonSecondaryDark = Color(0xFF5A6268); // #5a6268

  // Radial gradient overlay colors
  static const Color radialBlue = Color(0x1A4299E1); // rgba(66, 153, 225, 0.1)
  static const Color radialPurple =
      Color(0x1A667EEA); // rgba(102, 126, 234, 0.1)
  static const Color radialGreen =
      Color(0x0D48BB78); // rgba(72, 187, 120, 0.05)

  // Form colors
  static const Color formBackground = Color(0xFFF7FAFC); // #f7fafc
  static const Color formBorder = Color(0xFFE2E8F0); // #e2e8f0
  static const Color formFocus = Color(0x1A4299E1); // rgba(66, 153, 225, 0.1)

  // Status message colors
  static const Color statusSuccessBackground = Color(0xFFC6F6D5); // #c6f6d5
  static const Color statusSuccessText = Color(0xFF22543D); // #22543d
  static const Color statusSuccessBorder = Color(0xFF9AE6B4); // #9ae6b4

  static const Color statusErrorBackground = Color(0xFFFED7D7); // #fed7d7
  static const Color statusErrorText = Color(0xFF742A2A); // #742a2a
  static const Color statusErrorBorder = Color(0xFFFEB2B2); // #feb2b2

  // Table colors
  static const Color tableHeader = Color(0xFFF7FAFC); // #f7fafc
  static const Color tableHover = Color(0xFFF7FAFC); // #f7fafc
  static const Color tableBorder = Color(0xFFE2E8F0); // #e2e8f0

  // Hash/monospace text color
  static const Color hashText = Color(0xFF718096); // #718096

  // Status dot color
  static const Color statusDot = Color(0xFF48BB78); // #48bb78 (green)
}
