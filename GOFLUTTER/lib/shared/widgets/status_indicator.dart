import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../themes/app_spacing.dart';

/// Different status types for indicators
enum StatusType {
  online,
  offline,
  connecting,
  error,
  warning,
  success,
}

/// A small status indicator widget
class StatusIndicator extends StatelessWidget {
  final StatusType status;
  final double size;
  final bool showLabel;
  final String? customLabel;

  const StatusIndicator({
    Key? key,
    required this.status,
    this.size = AppSpacing.iconSm,
    this.showLabel = true,
    this.customLabel,
  }) : super(key: key);

  Color _getColor() {
    switch (status) {
      case StatusType.online:
      case StatusType.success:
        return AppColors.success;
      case StatusType.connecting:
        return AppColors.warning;
      case StatusType.error:
        return AppColors.error;
      case StatusType.offline:
        return AppColors.border;
      case StatusType.warning:
        return AppColors.warning;
    }
  }

  String _getLabel() {
    if (customLabel != null) return customLabel!;

    switch (status) {
      case StatusType.online:
        return 'Online';
      case StatusType.offline:
        return 'Offline';
      case StatusType.connecting:
        return 'Connecting';
      case StatusType.error:
        return 'Error';
      case StatusType.warning:
        return 'Warning';
      case StatusType.success:
        return 'Success';
    }
  }

  IconData _getIcon() {
    switch (status) {
      case StatusType.online:
        return Icons.circle;
      case StatusType.offline:
        return Icons.circle_outlined;
      case StatusType.connecting:
        return Icons.hourglass_empty;
      case StatusType.error:
        return Icons.error;
      case StatusType.warning:
        return Icons.warning;
      case StatusType.success:
        return Icons.check_circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: _getColor(),
            shape: BoxShape.circle,
          ),
        ),
        if (showLabel) ...[
          const SizedBox(width: 8),
          Text(
            _getLabel(),
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}
