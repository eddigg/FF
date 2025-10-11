import 'package:flutter/material.dart';
import '../themes/web_colors.dart';
import '../themes/web_gradients.dart';

// Export other shared widgets
export 'glass_card.dart';
export 'web_scaffold.dart';
export 'web_button.dart';
export 'status_indicator.dart';
export 'loading_indicator.dart';
export 'breadcrumb_navigation.dart';
export 'responsive_grid.dart';

class AppColors {
  static const Color primary = WebColors.primary;
  static const Color secondary = WebColors.secondary;
  static const Color surface = WebColors.surface;
  static const Color background = WebColors.background;
  static const Color backgroundMid = WebColors.backgroundMid;
  static const Color border = WebColors.border;
  static const Color textPrimary = WebColors.textPrimary;
  static const Color textSecondary = WebColors.textSecondary;
  static const Color textMuted = WebColors.textMuted;
  static const Color success = WebColors.success;
  static const Color error = WebColors.error;
  static const Color warning = WebColors.warning;
  static const Color info = WebColors.info;
  static const Color cardBackground = Color(0xFF252536);
  static const Color cardGradient = Color(0xFF2D2D40);
  static const Color backgroundGradient = Color(0xFF1A1A2E);
  static const Color surfaceOpaque = WebColors.surfaceOpaque;
  static const Color textTertiary = Color(0xFF7E7E98);
  static const Color card = WebColors.surface;

  // Add gradient lists for compatibility
  static const List<Color> primaryGradient = [
    Color(0xFF667eea),
    Color(0xFF764ba2),
  ];
  static const List<Color> secondaryGradient = [
    Color(0xFF11998e),
    Color(0xFF38ef7d),
  ];
}

class AppTextStyles {
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.25,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle h4 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.35,
  );

  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static const TextStyle address = TextStyle(
    fontFamily: 'monospace',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );
}

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double containerPadding = 20.0;
  static const double cardPadding = 16.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
}

// Add missing gradient for compatibility
class GradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final List<Color> colors;
  final EdgeInsets padding;
  final BorderRadius borderRadius;

  const GradientButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.colors = AppColors.primaryGradient,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
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
