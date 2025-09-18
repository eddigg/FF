import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../themes/web_parity_theme.dart';
import '../themes/web_typography.dart';
import '../themes/web_gradients.dart';
import '../themes/web_shadows.dart';

/// WebButton widget with multiple variants matching web CSS button styles
class WebButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final String? route; // New property for navigation
  final WebButtonVariant variant;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final TextStyle? textStyle;
  final IconData? icon;
  final bool isLoading;

  const WebButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.route, // New parameter
    this.variant = WebButtonVariant.primary,
    this.padding,
    this.width,
    this.height,
    this.borderRadius,
    this.textStyle,
    this.icon,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<WebButton> createState() => _WebButtonState();
}

// Enum for button variants
enum WebButtonVariant {
  primary,
  secondary,
  success,
  warning,
}

class _WebButtonState extends State<WebButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _translateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: WebParityTheme.transitionFast,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: WebParityTheme.easeInOut,
    ));
    
    _translateAnimation = Tween<double>(
      begin: 0.0,
      end: -2.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: WebParityTheme.easeInOut,
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

  // Handle button press - either custom callback or navigation
  void _handlePress() {
    if (widget.isLoading) return;
    
    // If onPressed is provided, call it
    if (widget.onPressed != null) {
      widget.onPressed!();
      return;
    }
    
    // If route is provided, navigate to it
    if (widget.route != null && context.mounted) {
      context.go(widget.route!);
    }
  }

  // Helper method to get padding
  EdgeInsets _getPadding() {
    if (widget.padding != null) return widget.padding!;
    
    return const EdgeInsets.symmetric(
      horizontal: WebParityTheme.spacingMd,
      vertical: WebParityTheme.spacingSm,
    );
  }

  // Helper method to get border radius
  BorderRadius _getBorderRadius() {
    if (widget.borderRadius != null) return widget.borderRadius!;
    
    return BorderRadius.circular(WebParityTheme.radiusSm);
  }

  // Helper method to get gradient based on variant
  LinearGradient _getGradient() {
    switch (widget.variant) {
      case WebButtonVariant.secondary:
        return WebGradients.buttonSecondary;
      case WebButtonVariant.success:
        return WebGradients.buttonSuccess;
      case WebButtonVariant.warning:
        return WebGradients.buttonWarning;
      case WebButtonVariant.primary:
        return WebGradients.buttonPrimary;
    }
  }

  // Helper method to get hover shadow based on variant
  List<BoxShadow> _getHoverShadow() {
    switch (widget.variant) {
      case WebButtonVariant.secondary:
        return WebShadows.buttonPrimaryHover; // Using primary hover for all variants
      case WebButtonVariant.success:
        return WebShadows.buttonSuccessHover;
      case WebButtonVariant.warning:
        return WebShadows.buttonWarningHover;
      case WebButtonVariant.primary:
        return WebShadows.buttonPrimaryHover;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: _handlePress,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.translate(
              offset: Offset(0, _translateAnimation.value),
              child: Container(
                width: widget.width,
                height: widget.height ?? 40,
                padding: _getPadding(),
                decoration: BoxDecoration(
                  gradient: _getGradient(),
                  borderRadius: _getBorderRadius(),
                  boxShadow: _getHoverShadow(),
                ),
                child: Center(
                  child: widget.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 2,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            if (widget.icon != null) ...[
                              Icon(
                                widget.icon,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: WebParityTheme.spacingXs),
                            ],
                            Expanded(
                              child: Text(
                                widget.text,
                                style: widget.textStyle ?? 
                                    WebTypography.button.copyWith(
                                      color: Colors.white,
                                    ),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
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