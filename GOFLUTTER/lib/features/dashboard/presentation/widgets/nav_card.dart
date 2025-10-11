import 'package:flutter/material.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/themes/app_text_styles.dart';
import '../../../../shared/themes/app_spacing.dart';
import '../../../../shared/widgets/common_widgets.dart';
// import '../../../../core/widgets/app_widgets.dart';

class NavCard extends StatelessWidget {
  final String title;
  final String icon;
  final String description;
  final String buttonText;
  final VoidCallback onPressed;
  final bool isSuccess;
  final bool isWarning;

  const NavCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.description,
    required this.buttonText,
    required this.onPressed,
    this.isSuccess = false,
    this.isWarning = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  icon,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  title,
                  style: AppTextStyles.h4.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  description,
                  style: AppTextStyles.body2.copyWith(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            GradientButton(
              text: buttonText,
              onPressed: onPressed,
              gradient: isSuccess
                  ? const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)])
                  : isWarning
                      ? const LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFDD6B20)])
                      : const LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF2563EB)]),
              width: double.infinity,
              textStyle: AppTextStyles.button.copyWith(
                fontSize: 13,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
