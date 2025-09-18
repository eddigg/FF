import 'package:flutter/material.dart';
import 'web_colors.dart';

/// Web parity gradient system matching linear and radial gradients from web CSS
class WebGradients {
  WebGradients._();

  // Background gradients matching web CSS body background
  static const LinearGradient backgroundMain = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
    colors: [
      WebColors.backgroundLight, // #f8fafc
      WebColors.backgroundMid, // #e2e8f0
      WebColors.backgroundDark, // #cbd5e0
    ],
  );

  // Header title gradient matching web CSS
  static const LinearGradient headerTitle = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
    colors: [
      Color(0xFF2D3748), // #2d3748
      Color(0xFF4A5568), // #4a5568
      Color(0xFF718096), // #718096
    ],
  );

  // Button gradients matching web CSS
  static const LinearGradient buttonPrimary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      WebColors.primary, // #4299e1
      WebColors.primaryDark, // #3182ce
    ],
  );

  static const LinearGradient buttonSecondary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      WebColors.buttonSecondary, // #6c757d
      WebColors.buttonSecondaryDark, // #5a6268
    ],
  );

  static const LinearGradient buttonSuccess = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      WebColors.success, // #48bb78
      WebColors.successDark, // #38a169
    ],
  );

  static const LinearGradient buttonWarning = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      WebColors.warning, // #ed8936
      WebColors.warningDark, // #dd6b20
    ],
  );

  // Logout button gradient matching web CSS
  static const LinearGradient logoutButton = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF2D3748), // #2d3748
      Color(0xFF4A5568), // #4a5568
    ],
  );

  // Navigation card overlay gradient for hover effects
  static const LinearGradient navCardOverlay = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x1AFFFFFF), // rgba(255,255,255,0.1)
      Color(0x0DFFFFFF), // rgba(255,255,255,0.05)
    ],
  );

  // Radial gradients for background overlays matching web CSS ::before
  static RadialGradient get radialBlue => const RadialGradient(
        center: Alignment(-0.6, 0.6), // 20% 80% in CSS
        radius: 0.8,
        colors: [
          WebColors.radialBlue, // rgba(66, 153, 225, 0.1)
          Colors.transparent,
        ],
        stops: [0.0, 0.5],
      );

  static RadialGradient get radialPurple => const RadialGradient(
        center: Alignment(0.6, -0.6), // 80% 20% in CSS
        radius: 0.8,
        colors: [
          WebColors.radialPurple, // rgba(102, 126, 234, 0.1)
          Colors.transparent,
        ],
        stops: [0.0, 0.5],
      );

  static RadialGradient get radialGreen => const RadialGradient(
        center: Alignment(-0.2, -0.2), // 40% 40% in CSS
        radius: 0.8,
        colors: [
          WebColors.radialGreen, // rgba(72, 187, 120, 0.05)
          Colors.transparent,
        ],
        stops: [0.0, 0.5],
      );

  // Combined radial gradient stack for background overlay
  static List<RadialGradient> get backgroundOverlays => [
        radialBlue,
        radialPurple,
        radialGreen,
      ];

  // Card background gradients
  static const LinearGradient cardBackground = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x1AFFFFFF), // rgba(255,255,255,0.1)
      Color(0x0DFFFFFF), // rgba(255,255,255,0.05)
    ],
  );

  // Glass morphism gradient for navigation cards and components
  static const LinearGradient glassMorphism = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xE6FFFFFF), // rgba(255,255,255,0.9)
      Color(0xD9FFFFFF), // rgba(255,255,255,0.85)
    ],
  );

  // Status gradients for different states
  static const LinearGradient statusSuccess = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFC6F6D5), // #c6f6d5
      Color(0xFF9AE6B4), // #9ae6b4
    ],
  );

  static const LinearGradient statusError = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFED7D7), // #fed7d7
      Color(0xFFFEB2B2), // #feb2b2
    ],
  );

  // Form background gradient
  static const LinearGradient formBackground = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      WebColors.formBackground, // #f7fafc
      Color(0xFFF1F5F9), // Slightly darker shade
    ],
  );

  // Info item gradient for wallet info cards
  static const LinearGradient infoItem = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      WebColors.formBackground, // #f7fafc
      Color(0xFFEDF2F7), // Slightly different shade
    ],
  );

  // Stat item background gradient
  static const LinearGradient statItem = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      WebColors.formBackground, // #f7fafc
      Color(0xFFE2E8F0), // #e2e8f0
    ],
  );
}
