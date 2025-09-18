import 'package:flutter/material.dart';
import '../../data/models/verification_option_model.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/common_widgets.dart';

class VerificationSection extends StatelessWidget {
  final List<VerificationOptionModel> verificationOptions;

  const VerificationSection({Key? key, required this.verificationOptions}) : super(key: key);

  void _startVerification(BuildContext context, String verificationType) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Starting $verificationType...')),
    );
  }

  void _checkVerificationStatus(BuildContext context, String verificationType) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Checking $verificationType status...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('✅ Identity Verification Methods', style: AppTextStyles.h4),
            const SizedBox(height: AppSpacing.md),
            ...verificationOptions.map((option) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: GlassCard(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: (option.status == 'verified' || option.status == 'active')
                                ? AppColors.success.withValues(alpha: 0.1)
                                : option.status == 'pending'
                                    ? AppColors.warning.withValues(alpha: 0.1)
                                    : AppColors.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              option.icon,
                              style: TextStyle(
                                color: (option.status == 'verified' || option.status == 'active')
                                    ? AppColors.success
                                    : option.status == 'pending'
                                        ? AppColors.warning
                                        : AppColors.error,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                option.name,
                                style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Status: ${option.status}',
                                style: AppTextStyles.caption,
                              ),
                            ],
                          ),
                        ),
                        if (option.status == 'unverified')
                          GradientButton(
                            text: 'Verify',
                            onPressed: () => _startVerification(context, option.name),
                            width: 80,
                          )
                        else if (option.status == 'pending')
                          GradientButton(
                            text: 'Check',
                            onPressed: () => _checkVerificationStatus(context, option.name),
                            gradient: AppColors.warningGradient,
                            width: 80,
                          )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                            decoration: BoxDecoration(
                              color: AppColors.success,
                              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                            ),
                            child: const Text(
                              'Verified',
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}