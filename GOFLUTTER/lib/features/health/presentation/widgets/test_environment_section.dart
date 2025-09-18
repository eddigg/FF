import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/health_bloc.dart';
import '../../data/models/test_environment_status_model.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/common_widgets.dart';

class TestEnvironmentSection extends StatelessWidget {
  const TestEnvironmentSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Test Environment & Testing', style: AppTextStyles.h4),
            const SizedBox(height: AppSpacing.md),
            BlocBuilder<HealthBloc, HealthState>(
              builder: (context, state) {
                if (state is HealthLoaded) {
                  return Column(
                    children: [
                      _buildTestEnvironmentStatus(state.testEnvironmentStatus),
                      const SizedBox(height: AppSpacing.md),
                      _buildTestButtons(),
                      const SizedBox(height: AppSpacing.md),
                      _buildTestResultsPlaceholder(),
                    ],
                  );
                } else if (state is HealthLoading) {
                  return const CircularProgressIndicator();
                } else {
                  return const Text('Error loading test environment status');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestEnvironmentStatus(TestEnvironmentStatusModel status) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatusItem('Nodes', status.nodes.toString(), AppColors.primary),
          _buildStatusItem('Wallets', status.wallets.toString(), AppColors.primary),
          _buildStatusItem('Txs', status.transactions.toString(), AppColors.primary),
          _buildStatusItem('Blocks', status.blocks.toString(), AppColors.primary),
        ],
      ),
    );
  }

  Widget _buildStatusItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.h5.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.caption,
        ),
      ],
    );
  }

  Widget _buildTestButtons() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GradientButton(
              text: 'Start Test Environment',
              onPressed: () {},
              width: 150,
            ),
            const SizedBox(width: AppSpacing.sm),
            GradientButton(
              text: 'Stop Test Environment',
              onPressed: () {},
              gradient: AppColors.secondaryGradient,
              width: 150,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GradientButton(
              text: 'Automated Tests',
              onPressed: () {},
              width: 120,
            ),
            const SizedBox(width: AppSpacing.sm),
            GradientButton(
              text: 'Performance Tests',
              onPressed: () {},
              gradient: AppColors.secondaryGradient,
              width: 120,
            ),
            const SizedBox(width: AppSpacing.sm),
            GradientButton(
              text: 'Security Tests',
              onPressed: () {},
              gradient: AppColors.secondaryGradient,
              width: 120,
            ),
            const SizedBox(width: AppSpacing.sm),
            GradientButton(
              text: 'Integration Tests',
              onPressed: () {},
              gradient: AppColors.secondaryGradient,
              width: 120,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTestResultsPlaceholder() {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: AppColors.border),
      ),
      child: const Center(
        child: Text(
          'Click a test button to run tests and view results',
          style: AppTextStyles.caption,
        ),
      ),
    );
  }
}