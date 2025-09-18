import 'package:flutter/material.dart';
import 'dart:ui'; // For ImageFilter
import '../themes/app_theme.dart'; // For AppAnimations
import '../themes/web_parity_theme.dart';
import '../themes/web_colors.dart';
import '../themes/web_typography.dart';
import '../themes/web_gradients.dart';
import '../themes/web_shadows.dart';

/// Glass morphism card widget matching the web frontend design
class GlassCard extends StatefulWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final bool enableHover;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final bool showHoverOverlay; // New parameter for hover overlay effect
  final double? opacity; // New parameter for configurable opacity

  const GlassCard({
    Key? key,
    required this.child,
    this.padding,
    this.width,
    this.height,
    this.enableHover = true,
    this.onTap,
    this.borderRadius,
    this.boxShadow,
    this.showHoverOverlay = false, // Default to false for backward compatibility
    this.opacity = 0.9, // Default opacity matching web (rgba(255,255,255,0.9))
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
                  color: WebColors.cardBackground.withValues(alpha: widget.opacity ?? 0.9),
                  borderRadius: widget.borderRadius ?? 
                      BorderRadius.circular(WebParityTheme.radiusXl),
                  border: Border.all(
                    color: WebColors.borderCard,
                    width: 1,
                  ),
                  boxShadow: widget.boxShadow ?? WebShadows.glassEffect,
                ),
                child: ClipRRect(
                  borderRadius: widget.borderRadius ?? 
                      BorderRadius.circular(WebParityTheme.radiusXl),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Stack(
                      children: [
                        Container(
                          padding: widget.padding ?? 
                              const EdgeInsets.all(WebParityTheme.cardPadding),
                          child: widget.child,
                        ),
                        // Hover overlay effect
                        if (widget.showHoverOverlay && _controller.value > 0)
                          Container(
                            decoration: BoxDecoration(
                              gradient: WebGradients.navCardOverlay,
                              borderRadius: widget.borderRadius ?? 
                                  BorderRadius.circular(WebParityTheme.radiusMd),
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
      ),
    );
  }
}

/// Navigation card widget matching the web frontend nav-card class
class NavigationCard extends StatefulWidget {
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onPressed;
  final IconData? icon;
  final LinearGradient? gradient;
  final double? height; // New parameter for card height

  const NavigationCard({
    Key? key,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onPressed,
    this.icon,
    this.gradient,
    this.height = 240, // Default height matching web (240px)
  }) : super(key: key);

  @override
  State<NavigationCard> createState() => _NavigationCardState();
}

class _NavigationCardState extends State<NavigationCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _translateYAnimation;
  late Animation<double> _overlayOpacityAnimation;
  late Animation<BoxShadow> _boxShadowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: WebParityTheme.transitionSlow, // 400ms matching web
      vsync: this,
    );
    
    // Scale animation: 1.0 to 1.02
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: WebParityTheme.easeInOut, // cubic-bezier(0.4, 0, 0.2, 1)
    ));
    
    // Translate Y animation: 0 to -4
    _translateYAnimation = Tween<double>(
      begin: 0.0,
      end: -4.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: WebParityTheme.easeInOut,
    ));
    
    // Overlay opacity animation: 0 to 1
    _overlayOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: WebParityTheme.easeInOut,
    ));
    
    // Box shadow animation
    _boxShadowAnimation = TweenSequence<BoxShadow>([
      TweenSequenceItem(
        tween: Tween<BoxShadow>(
          begin: WebShadows.navCard.first,
          end: WebShadows.navCard.first,
        ),
        weight: 50.0,
      ),
      TweenSequenceItem(
        tween: Tween<BoxShadow>(
          begin: WebShadows.navCard.first,
          end: WebShadows.navCardHover.first,
        ),
        weight: 50.0,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: WebParityTheme.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onEnter(PointerEvent event) {
    _controller.forward();
  }

  void _onExit(PointerEvent event) {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _translateYAnimation.value),
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                height: widget.height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(WebParityTheme.radiusLg),
                  border: Border.all(
                    color: WebColors.borderCard,
                    width: 1,
                  ),
                  boxShadow: [_boxShadowAnimation.value],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(WebParityTheme.radiusLg),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Stack(
                      children: [
                        // Background with gradient
                        Container(
                          decoration: BoxDecoration(
                            gradient: widget.gradient ?? WebGradients.glassMorphism,
                          ),
                        ),
                        // Content
                        Container(
                          padding: const EdgeInsets.all(WebParityTheme.navCardPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (widget.icon != null) ...[
                                Container(
                                  padding: const EdgeInsets.all(WebParityTheme.spacingSm),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(WebParityTheme.radiusSm)),
                                  ),
                                  child: Icon(
                                    widget.icon,
                                    color: WebColors.textPrimary,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(height: WebParityTheme.spacingSm),
                              ],
                              
                              Text(
                                widget.title,
                                style: WebTypography.navCardTitle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              
                              const SizedBox(height: WebParityTheme.spacingXs),
                              
                              Text(
                                widget.description,
                                style: WebTypography.navCardDescription,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              
                              const SizedBox(height: WebParityTheme.spacingSm),
                              
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: widget.onPressed,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: WebColors.primary,
                                    padding: const EdgeInsets.symmetric(vertical: WebParityTheme.spacingSm),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(WebParityTheme.radiusMd)),
                                    ),
                                  ),
                                  child: Text(
                                    widget.buttonText,
                                    style: WebTypography.button.copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Hover overlay effect
                        if (_overlayOpacityAnimation.value > 0)
                          Opacity(
                            opacity: _overlayOpacityAnimation.value,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: WebGradients.navCardOverlay,
                                borderRadius: BorderRadius.circular(WebParityTheme.radiusLg),
                              ),
                            ),
                          ),
                      ],
                    ),
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