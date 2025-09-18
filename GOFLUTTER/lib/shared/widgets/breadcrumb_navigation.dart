import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../themes/web_colors.dart';
import '../themes/web_typography.dart';
import '../themes/web_gradients.dart';
import '../widgets/glass_card.dart';

/// Breadcrumb navigation widget for consistent navigation patterns across all feature pages
/// Matches the web implementation patterns for breadcrumb navigation
class BreadcrumbNavigation extends StatelessWidget {
  final List<BreadcrumbItem> items;
  
  const BreadcrumbNavigation({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ...items.asMap().entries.expand((entry) {
              final index = entry.key;
              final item = entry.value;
              final isLast = index == items.length - 1;
              
              return [
                _buildBreadcrumbItem(context, item, isLast),
                if (!isLast) ...[
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: WebColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                ],
              ];
            }).toList(),
          ],
        ),
      ),
    );
  }
  
  /// Build a breadcrumb item
  Widget _buildBreadcrumbItem(BuildContext context, BreadcrumbItem item, bool isLast) {
    return InkWell(
      onTap: isLast ? null : () {
        if (item.route != null) {
          context.go(item.route!);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          gradient: isLast ? WebGradients.buttonPrimary : null,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.icon != null) ...[
              Icon(
                item.icon,
                size: 16,
                color: isLast ? Colors.white : WebColors.textSecondary,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              item.title,
              style: WebTypography.body1.copyWith(
                color: isLast ? Colors.white : WebColors.textPrimary,
                fontWeight: isLast ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Breadcrumb item model
class BreadcrumbItem {
  final String title;
  final String? route;
  final IconData? icon;
  
  BreadcrumbItem({
    required this.title,
    this.route,
    this.icon,
  });
}