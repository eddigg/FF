import 'package:flutter/material.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/common_widgets.dart';
import '../../../../shared/widgets/custom_widgets.dart';

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
    return EnhancedGlassCard(
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
                  ? AppColors.successGradient
                  : isWarning
                      ? AppColors.warningGradient
                      : AppColors.primaryGradient,
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