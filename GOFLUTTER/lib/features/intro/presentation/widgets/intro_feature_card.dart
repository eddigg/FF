import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/common_widgets.dart';

class IntroFeatureCard extends StatelessWidget {
  final String icon;
  final String title;
  final String description;
  final String? route; // Add route parameter

  const IntroFeatureCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    this.route, // Make route optional
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Wrap the GlassCard with GestureDetector for tap handling
    Widget card = GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16), // AppSpacing.md
        child: Column(
          children: [
            Text(
              icon,
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 16), // AppSpacing.md
            Text(
              title,
              style: const TextStyle(
                fontSize: 20, // AppTextStyles.h4
                fontWeight: FontWeight.w600,
                color: Colors.black, // Changed from Colors.white to Colors.black
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8), // AppSpacing.sm
            Text(
              description,
              style: const TextStyle(
                fontSize: 16, // AppTextStyles.body1
                color: Colors.black87, // Changed from Colors.white70 to Colors.black87
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );

    // Add tap handler if route is provided
    if (route != null) {
      card = GestureDetector(
        onTap: () => context.go(route!),
        child: card,
      );
    }

    return card;
  }
}
