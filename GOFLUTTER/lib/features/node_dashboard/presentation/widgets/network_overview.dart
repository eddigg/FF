
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/node_dashboard_bloc.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/common_widgets.dart';

class NetworkOverview extends StatelessWidget {
  const NetworkOverview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Network Overview', style: AppTextStyles.h4),
            const SizedBox(height: AppSpacing.md),
            const Text('Active Validators', style: AppTextStyles.h5),
            const SizedBox(height: AppSpacing.sm),
            BlocBuilder<NodeDashboardBloc, NodeDashboardState>(
              builder: (context, state) {
                if (state is NodeDashboardLoaded) {
                  return Column(
                    children: state.validators.map((validator) => ListTile(
                      title: Text(validator.address),
                      subtitle: Text('Stake: ${validator.stake}'),
                      trailing: Text(validator.isActive ? 'Active' : 'Inactive'),
                    )).toList(),
                  );
                } else if (state is NodeDashboardLoading) {
                  return const CircularProgressIndicator();
                } else {
                  return const Text('Error loading validators');
                }
              },
            ),
            const SizedBox(height: AppSpacing.md),
            const Text('Network Stats', style: AppTextStyles.h4),
            const SizedBox(height: AppSpacing.sm),
            BlocBuilder<NodeDashboardBloc, NodeDashboardState>(
              builder: (context, state) {
                if (state is NodeDashboardLoaded) {
                  return Column(
                    children: [
                      _buildStatItem('Total Validators', state.networkStats.totalValidators.toString()),
                      _buildStatItem('Network Hash Rate', state.networkStats.networkHashRate),
                      _buildStatItem('Average Block Time', state.networkStats.avgBlockTime),
                      _buildStatItem('Network Difficulty', state.networkStats.networkDifficulty),
                    ],
                  );
                } else if (state is NodeDashboardLoading) {
                  return const CircularProgressIndicator();
                } else {
                  return const Text('Error loading network stats');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value) {
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
