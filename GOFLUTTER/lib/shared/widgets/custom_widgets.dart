import 'package:flutter/material.dart';
import '../themes/web_colors.dart';
import '../themes/web_parity_theme.dart';

class EnhancedGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets margin;

  const EnhancedGlassCard({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.margin = const EdgeInsets.all(10),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: WebColors.surface.withOpacity(0.2),
        borderRadius: BorderRadius.circular(WebParityTheme.radiusMd),
        border: Border.all(
          color: WebColors.border.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2D2D40),
            Color(0xFF1E1E2E),
          ],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(WebParityTheme.radiusMd - 2),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 8,
            sigmaY: 8,
          ),
          child: child,
        ),
      ),
    );
  }
}

class GradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Gradient gradient;
  final EdgeInsets padding;
  final BorderRadius borderRadius;

  const GradientButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.gradient = WebColors.backgroundGradient,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: borderRadius,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: borderRadius,
          child: Container(
            padding: padding,
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}

class WebParityTheme {
  static const double containerPadding = 20.0;
  static const double cardPadding = 16.0;
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 12.0;
  static const double spacingLg = 16.0;
  static const double spacingXl = 24.0;
  static const double radiusSm = 4.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusXl = 16.0;
  static const double architectureCardPadding = 24.0;
  static const double navBarPadding = 16.0;
  
  static int getGridColumns(double width) {
    if (width < 600) {
      return 1;
    } else if (width < 900) {
      return 2;
    } else if (width < 1200) {
      return 3;
    } else {
      return 4;
    }
  }
  
  static double getResponsiveSpacing(double width) {
    if (width < 600) {
      return spacingSm;
    } else if (width < 900) {
      return spacingMd;
    } else {
      return spacingLg;
    }
  }
}

extension AppSpacing on num {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double containerPadding = 20.0;
  static const double cardPadding = 16.0;
  static const double radiusSm = 4.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusXl = 16.0;
}
