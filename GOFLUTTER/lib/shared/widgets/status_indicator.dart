import 'package:flutter/material.dart';
import '../themes/web_parity_theme.dart';
import '../themes/web_colors.dart';
import '../themes/web_typography.dart';

/// Status indicator widget with animated pulse effect matching web design
class StatusIndicator extends StatefulWidget {
  final String text;
  final StatusType type;
  final double size;

  const StatusIndicator({
    Key? key,
    required this.text,
    this.type = StatusType.success,
    this.size = WebParityTheme.statusDotSize,
  }) : super(key: key);

  @override
  State<StatusIndicator> createState() => _StatusIndicatorState();
}

enum StatusType {
  success,
  warning,
  error,
  info,
}

class _StatusIndicatorState extends State<StatusIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: WebParityTheme.pulseAnimationDuration,
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Helper method to get color based on status type
  Color _getColor() {
    switch (widget.type) {
      case StatusType.warning:
        return WebColors.warning;
      case StatusType.error:
        return WebColors.error;
      case StatusType.info:
        return WebColors.info;
      case StatusType.success:
        return WebColors.statusDot;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FadeTransition(
          opacity: Tween<double>(begin: 1.0, end: 0.5).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
          ),
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: _getColor(),
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: WebParityTheme.spacingXs),
        Text(
          widget.text,
          style: WebTypography.caption.copyWith(
            color: WebColors.textSecondary,
          ),
        ),
      ],
    );
  }
}