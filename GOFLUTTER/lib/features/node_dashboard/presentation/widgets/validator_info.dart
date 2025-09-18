
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/node_dashboard_bloc.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/common_widgets.dart';

class ValidatorInfo extends StatelessWidget {
  const ValidatorInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Validator Info', style: AppTextStyles.h4),
            const SizedBox(height: AppSpacing.md),
            BlocBuilder<NodeDashboardBloc, NodeDashboardState>(
              builder: (context, state) {
                if (state is NodeDashboardLoaded) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoItem('Staked Tokens', state.validatorInfo.stake.toString()),
                      _buildInfoItem('Validator Status', state.validatorInfo.status ?? 'Unknown'),
                      _buildInfoItem('Address', state.validatorInfo.address),
                      _buildInfoItem('Validator Rank', (state.validatorInfo.rank ?? 0).toString()),
                      _buildInfoItem('Node Mode', state.validatorInfo.nodeMode ?? 'Unknown'),
                    ],
                  );
                } else if (state is NodeDashboardLoading) {
                  return const CircularProgressIndicator();
                } else {
                  return const Text('Error loading validator info');
                }
              },
            ),
            const SizedBox(height: AppSpacing.md),
            const Text('Quick Actions', style: AppTextStyles.h4),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                GradientButton(text: 'Stake', onPressed: () {}),
                GradientButton(text: 'Export', onPressed: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.body2),
          Text(value, style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
