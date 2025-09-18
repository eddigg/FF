import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../themes/app_theme.dart';

/// Animated status dot widget that pulses like the HTML version
class AnimatedStatusDot extends StatefulWidget {
  final Color? color;
  final double? size;

  const AnimatedStatusDot({
    Key? key,
    this.color,
    this.size,
  }) : super(key: key);

  @override
  State<AnimatedStatusDot> createState() => _AnimatedStatusDotState();
}

class _AnimatedStatusDotState extends State<AnimatedStatusDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 1.0, end: 0.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.size ?? 8,
          height: widget.size ?? 8,
          decoration: BoxDecoration(
            color: widget.color ?? AppColors.success,
            borderRadius: BorderRadius.circular((widget.size ?? 8) / 2),
          ),
          child: Opacity(
            opacity: _animation.value,
            child: Container(
              width: widget.size ?? 8,
              height: widget.size ?? 8,
              decoration: BoxDecoration(
                color: widget.color ?? AppColors.success,
                borderRadius: BorderRadius.circular((widget.size ?? 8) / 2),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Enhanced glass card with HTML-style styling
class EnhancedGlassCard extends StatefulWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final bool enableHover;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final Color? backgroundColor;
  final bool showHoverOverlay; // New parameter for hover overlay effect

  const EnhancedGlassCard({
    Key? key,
    required this.child,
    this.padding,
    this.width,
    this.height,
    this.enableHover = true,
    this.onTap,
    this.borderRadius,
    this.boxShadow,
    this.backgroundColor,
    this.showHoverOverlay = false, // Default to false for backward compatibility
  }) : super(key: key);

  @override
  State<EnhancedGlassCard> createState() => _EnhancedGlassCardState();
}

class _EnhancedGlassCardState extends State<EnhancedGlassCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.normal,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AppAnimations.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onEnter() {
    if (widget.enableHover) {
      _controller.forward();
    }
  }

  void _onExit() {
    if (widget.enableHover) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onEnter(),
      onExit: (_) => _onExit(),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                  color: widget.backgroundColor ?? AppColors.surfaceOpaque,
                  borderRadius: widget.borderRadius ??
                      BorderRadius.circular(AppSpacing.radiusXl),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                  boxShadow: widget.boxShadow ?? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      offset: const Offset(0, 20),
                      blurRadius: 40,
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      offset: const Offset(0, 8),
                      blurRadius: 16,
                      spreadRadius: 0,
                    ),
                    // Additional shadow when hovered
                    if (_controller.value > 0)
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12 * _controller.value),
                        offset: const Offset(0, 25),
                        blurRadius: 50,
                        spreadRadius: 0,
                      ),
                  ],
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: widget.borderRadius ??
                          BorderRadius.circular(AppSpacing.radiusXl),
                      child: Container(
                        padding: widget.padding ??
                            const EdgeInsets.all(AppSpacing.cardPadding),
                        child: widget.child,
                      ),
                    ),
                    // Hover overlay effect
                    if (widget.showHoverOverlay && _controller.value > 0)
                      ClipRRect(
                        borderRadius: widget.borderRadius ?? 
                            BorderRadius.circular(AppSpacing.radiusMd), // 12px as in web
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withValues(alpha: 0.1),
                                Colors.white.withValues(alpha: 0.05),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Info item widget matching the HTML .info-item class
class InfoItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? borderColor;
  final IconData? icon;

  const InfoItem({
    Key? key,
    required this.label,
    required this.value,
    this.borderColor,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border(
          left: BorderSide(
            color: borderColor ?? AppColors.primary,
            width: 4,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: borderColor ?? AppColors.primary,
              size: 20,
            ),
            const SizedBox(height: AppSpacing.xs),
          ],
          Text(
            label,
            style: AppTextStyles.body2.copyWith(
              color: AppColors.textMuted,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTextStyles.body1.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Stat item widget matching the HTML .stat-item class
class StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final IconData? icon;

  const StatItem({
    Key? key,
    required this.label,
    required this.value,
    this.valueColor,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: valueColor ?? AppColors.primary,
              size: 24,
            ),
            const SizedBox(height: AppSpacing.xs),
          ],
          Text(
            value,
            style: AppTextStyles.h3.copyWith(
              color: valueColor ?? AppColors.primary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: AppTextStyles.body2.copyWith(
              color: AppColors.textMuted,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

/// Form group widget matching the HTML .form-group class
class FormFieldGroup extends StatelessWidget {
  final String label;
  final Widget child;
  final String? helperText;

  const FormFieldGroup({
    Key? key,
    required this.label,
    required this.child,
    this.helperText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.body1.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        child,
        if (helperText != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            helperText!,
            style: AppTextStyles.body2.copyWith(
              color: AppColors.textMuted,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}

/// Custom form control matching the HTML .form-control class
class CustomTextField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const CustomTextField({
    Key? key,
    this.hintText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.body1.copyWith(
          color: AppColors.textMuted,
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.backgroundLight,
        contentPadding: const EdgeInsets.all(AppSpacing.md),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(
            color: AppColors.border,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(
            color: AppColors.border,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 2,
          ),
        ),
      ),
      style: AppTextStyles.body1,
    );
  }
}

/// Hash display widget matching the HTML .hash-cell class
class HashDisplay extends StatelessWidget {
  final String hash;
  final int? maxLength;
  final TextStyle? style;

  const HashDisplay({
    Key? key,
    required this.hash,
    this.maxLength,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String displayText = hash;
    if (maxLength != null && hash.length > maxLength!) {
      displayText = '${hash.substring(0, maxLength! ~/ 2)}...${hash.substring(hash.length - maxLength! ~/ 2)}';
    }

    return Text(
      displayText,
      style: style ?? AppTextStyles.body2.copyWith(
        fontFamily: 'Courier New',
        fontSize: 12,
        color: AppColors.textMuted,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// Peer list item matching the HTML .peer-list li class
class PeerListItem extends StatelessWidget {
  final String peerId;
  final VoidCallback? onTap;

  const PeerListItem({
    Key? key,
    required this.peerId,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        margin: const EdgeInsets.only(bottom: AppSpacing.xs),
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        child: Row(
          children: [
            Expanded(
              child: HashDisplay(
                hash: peerId,
                maxLength: 32,
                style: AppTextStyles.body2.copyWith(
                  fontFamily: 'Courier New',
                  fontSize: 14,
                ),
              ),
            ),
            if (onTap != null)
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textMuted,
              ),
          ],
        ),
      ),
    );
  }
}