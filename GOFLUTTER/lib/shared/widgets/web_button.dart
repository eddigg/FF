import 'package:flutter/material.dart';
import '../themes/web_colors.dart';

/// Different button variants for the web interface
enum WebButtonVariant {
  primary,
  secondary,
  success,
  warning,
  danger,
  neutral,
}

/// A web-style button with different variants
class WebButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final WebButtonVariant variant;
  final bool isDisabled;
  final bool isLoading;
  final Icon? icon;
  final double height;
  final double? width;
  final double borderRadius;

  const WebButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.variant = WebButtonVariant.primary,
    this.isDisabled = false,
    this.isLoading = false,
    this.icon,
    this.height = 40.0,
    this.width,
    this.borderRadius = 8.0,
  }) : super(key: key);

  Color _getBackgroundColor() {
    if (isDisabled) return WebColors.border;

    switch (variant) {
      case WebButtonVariant.primary:
        return WebColors.primary;
      case WebButtonVariant.secondary:
        return WebColors.secondary;
      case WebButtonVariant.success:
        return WebColors.success;
      case WebButtonVariant.warning:
        return WebColors.warning;
      case WebButtonVariant.danger:
        return WebColors.error;
      case WebButtonVariant.neutral:
        return WebColors.surface;
    }
  }

  Color _getTextColor() {
    if (isDisabled) return WebColors.textSecondary;

    switch (variant) {
      case WebButtonVariant.neutral:
        return WebColors.textPrimary;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: (isDisabled || isLoading) ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _getBackgroundColor(),
          foregroundColor: _getTextColor(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: variant == WebButtonVariant.neutral ? 0 : 2,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(width: 8),
            ],
            if (isLoading)
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(_getTextColor()),
                ),
              )
            else
              Text(text),
          ],
        ),
      ),
    );
  }
}
