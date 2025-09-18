import 'package:flutter/material.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/common_widgets.dart';

class NodeControlsSection extends StatelessWidget {
  const NodeControlsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Node Controls', style: AppTextStyles.h4),
            const SizedBox(height: AppSpacing.md),
            const Text('Node Management', style: AppTextStyles.h5),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                GradientButton(
                  text: '▶️ Start',
                  onPressed: () {
                    // TODO: Implement start node functionality
                  },
                  width: 100,
                ),
                GradientButton(
                  text: '⏸️ Pause',
                  onPressed: () {
                    // TODO: Implement pause node functionality
                  },
                  gradient: AppColors.warningGradient,
                  width: 100,
                ),
                GradientButton(
                  text: '⏹️ Stop',
                  onPressed: () {
                    // TODO: Implement stop node functionality
                  },
                  gradient: AppColors.secondaryGradient,
                  width: 100,
                ),
                GradientButton(
                  text: '🔄 Sync',
                  onPressed: () {
                    // TODO: Implement sync node functionality
                  },
                  gradient: AppColors.infoGradient,
                  width: 100,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            const Text('Validator Management', style: AppTextStyles.h5),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                GradientButton(
                  text: '⚖️ Stake',
                  onPressed: () {
                    // TODO: Implement update stake functionality
                  },
                  gradient: AppColors.warningGradient,
                  width: 100,
                ),
                GradientButton(
                  text: '📊 Export',
                  onPressed: () {
                    // TODO: Implement export node data functionality
                  },
                  gradient: AppColors.successGradient,
                  width: 100,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            const Text('Node Logs', style: AppTextStyles.h4),
            const SizedBox(height: AppSpacing.sm),
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: AppColors.backgroundDark,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: const SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.sm),
                  child: Text(
                    '[INFO] Network dashboard initialized\n[INFO] Connecting to blockchain network...',
                    style: AppTextStyles.body2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}