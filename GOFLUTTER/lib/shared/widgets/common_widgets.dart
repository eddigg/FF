import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui'; // For ImageFilter
import '../themes/web_parity_theme.dart';
import '../themes/web_colors.dart';
import '../themes/web_typography.dart';
import '../themes/web_gradients.dart';
import '../themes/web_shadows.dart';

/// A glass-like card widget with consistent styling
class GlassCard extends StatefulWidget {
  final Widget child;
  final EdgeInsets? margin;
  final double? width;
  final double? height;

  const GlassCard({
    Key? key,
    required this.child,
    this.margin,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: WebParityTheme.transitionFast, // Use web parity theme
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: WebParityTheme.easeInOut, // Use web parity theme
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.width,
              height: widget.height,
              margin: widget.margin,
              decoration: BoxDecoration(
                color: WebColors.surfaceOpaque, // Use web parity colors
                borderRadius: BorderRadius.circular(WebParityTheme.radiusXl), // Use web parity theme
                boxShadow: WebShadows.glassEffect, // Use web parity shadows
                border: Border.all(
                  color: WebColors.borderCard, // Use web parity colors
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(WebParityTheme.radiusXl), // Use web parity theme
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: widget.child,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Gradient button widget matching the web frontend button styles
class GradientButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final LinearGradient? gradient;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final TextStyle? textStyle;
  final IconData? icon;
  final bool isLoading;
  final ButtonSize size; // New parameter for button size

  const GradientButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.gradient,
    this.padding,
    this.width,
    this.height,
    this.borderRadius,
    this.textStyle,
    this.icon,
    this.isLoading = false,
    this.size = ButtonSize.normal, // Default to normal size
  }) : super(key: key);

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

// Enum for button sizes
enum ButtonSize {
  small,
  normal,
  large,
}

class _GradientButtonState extends State<GradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _translateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: WebParityTheme.transitionFast, // Use web parity theme
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: WebParityTheme.easeInOut, // Use web parity theme
    ));
    
    _translateAnimation = Tween<double>(
      begin: 0.0,
      end: widget.size == ButtonSize.small ? -1.0 : -2.0, // Smaller movement for small buttons
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: WebParityTheme.easeInOut, // Use web parity theme
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  // Helper method to get padding based on button size
  EdgeInsets _getPadding() {
    if (widget.padding != null) return widget.padding!;
    
    switch (widget.size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(
          horizontal: WebParityTheme.spacingSm,
          vertical: WebParityTheme.spacingXs,
        );
      case ButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: WebParityTheme.spacingXl,
          vertical: WebParityTheme.spacingMd,
        );
      case ButtonSize.normal:
        return const EdgeInsets.symmetric(
          horizontal: WebParityTheme.spacingMd,
          vertical: WebParityTheme.spacingSm,
        );
    }
  }

  // Helper method to get border radius based on button size
  BorderRadius _getBorderRadius() {
    if (widget.borderRadius != null) return widget.borderRadius!;
    
    switch (widget.size) {
      case ButtonSize.small:
        return BorderRadius.circular(WebParityTheme.radiusXs); // Use web parity theme
      case ButtonSize.large:
        return BorderRadius.circular(WebParityTheme.radiusMd); // Use web parity theme
      case ButtonSize.normal:
        return BorderRadius.circular(WebParityTheme.radiusSm); // Use web parity theme
    }
  }

  // Helper method to get font size based on button size
  double _getFontSize() {
    switch (widget.size) {
      case ButtonSize.small:
        return 12.8; // 0.8rem
      case ButtonSize.large:
        return 16.0; // 1rem
      case ButtonSize.normal:
        return 14.4; // 0.9rem
    }
  }

  // Helper method to get height based on button size
  double _getHeight() {
    if (widget.height != null) return widget.height!;
    
    switch (widget.size) {
      case ButtonSize.small:
        return 32;
      case ButtonSize.large:
        return 56;
      case ButtonSize.normal:
        return 40;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onPressed != null ? _onTapDown : null,
      onTapUp: widget.onPressed != null ? _onTapUp : null,
      onTapCancel: _onTapCancel,
      onTap: widget.onPressed != null && !widget.isLoading 
          ? () {
              HapticFeedback.lightImpact();
              widget.onPressed!();
            }
          : null,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.translate(
              offset: Offset(0, _translateAnimation.value),
              child: Container(
                width: widget.width,
                height: _getHeight(),
                padding: _getPadding(),
                decoration: BoxDecoration(
                  gradient: widget.onPressed != null 
                      ? (widget.gradient ?? WebGradients.buttonPrimary) // Use web parity gradients
                      : const LinearGradient(
                          colors: [WebColors.textMuted, WebColors.textMuted], // Use web parity colors
                        ),
                  borderRadius: _getBorderRadius(),
                  boxShadow: widget.onPressed != null ? [
                    BoxShadow(
                      color: (widget.gradient?.colors.first ?? WebColors.primary).withValues(
                        alpha: widget.size == ButtonSize.small ? 0.2 : 0.4
                      ),
                      offset: Offset(0, widget.size == ButtonSize.small ? 3 : 5),
                      blurRadius: widget.size == ButtonSize.small ? 8 : 15,
                      spreadRadius: 0,
                    ),
                  ] : null,
                ),
                child: Center(
                  child: widget.isLoading
                      ? SizedBox(
                          width: widget.size == ButtonSize.small ? 16 : 20,
                          height: widget.size == ButtonSize.small ? 16 : 20,
                          child: CircularProgressIndicator(
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: widget.size == ButtonSize.small ? 1.5 : 2,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.icon != null) ...[
                              Icon(
                                widget.icon,
                                color: Colors.white,
                                size: widget.size == ButtonSize.small ? 16 : 18,
                              ),
                              SizedBox(width: widget.size == ButtonSize.small ? 
                                WebParityTheme.spacingXs : WebParityTheme.spacingSm), // Use web parity theme
                            ],
                            Text(
                              widget.text,
                              style: widget.textStyle ?? 
                                  WebTypography.button.copyWith( // Use web parity typography
                                    color: Colors.white,
                                    fontSize: _getFontSize(),
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Status message widget for showing success/error messages
class StatusMessage extends StatelessWidget {
  final String message;
  final StatusType type;
  final bool isVisible;
  final VoidCallback? onDismiss;

  const StatusMessage({
    Key? key,
    required this.message,
    required this.type,
    required this.isVisible,
    this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (type) {
      case StatusType.success:
        backgroundColor = WebColors.success; // Use web parity colors
        textColor = Colors.white;
        icon = Icons.check_circle;
        break;
      case StatusType.error:
        backgroundColor = WebColors.error; // Use web parity colors
        textColor = Colors.white;
        icon = Icons.error;
        break;
      case StatusType.warning:
        backgroundColor = WebColors.warning; // Use web parity colors
        textColor = Colors.white;
        icon = Icons.warning;
        break;
      case StatusType.info:
        backgroundColor = WebColors.info; // Use web parity colors
        textColor = Colors.white;
        icon = Icons.info;
        break;
    }

    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: WebParityTheme.transitionNormal, // Use web parity theme
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(WebParityTheme.spacingMd), // Use web parity theme
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(WebParityTheme.radiusSm), // Use web parity theme
          boxShadow: WebShadows.card, // Use web parity shadows
        ),
        child: Row(
          children: [
            Icon(icon, color: textColor, size: 20),
            const SizedBox(width: WebParityTheme.spacingSm), // Use web parity theme
            Expanded(
              child: Text(
                message,
                style: WebTypography.body2.copyWith(color: textColor), // Use web parity typography
              ),
            ),
            if (onDismiss != null)
              GestureDetector(
                onTap: onDismiss,
                child: Icon(
                  Icons.close,
                  color: textColor,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

enum StatusType { success, error, warning, info }

/// Loading shimmer widget for skeleton screens
class ShimmerLoading extends StatefulWidget {
  final Widget child;
  final bool isLoading;

  const ShimmerLoading({
    Key? key,
    required this.child,
    required this.isLoading,
  }) : super(key: key);

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-1.0 + 2.0 * _controller.value, 0.0),
              end: Alignment(-0.5 + 2.0 * _controller.value, 0.0),
              colors: const [
                Color(0xFFE0E0E0),
                Color(0xFFF5F5F5),
                Color(0xFFE0E0E0),
              ],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}