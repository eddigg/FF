
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/node_dashboard_bloc.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/common_widgets.dart';

class ShardingSection extends StatelessWidget {
  const ShardingSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Sharding Architecture', style: AppTextStyles.h4),
            const SizedBox(height: AppSpacing.md),
            BlocBuilder<NodeDashboardBloc, NodeDashboardState>(
              builder: (context, state) {
                if (state is NodeDashboardLoaded) {
                  return Column(
                    children: [
                      _buildShardingInfoCard('Shard Overview', state.shardingInfo.shardOverview),
                      _buildShardingInfoCard('Validator Assignment', state.shardingInfo.validatorAssignment),
                      _buildShardingInfoCard('Cross-Shard Transactions', state.shardingInfo.crossShardTransactions),
                      _buildShardingInfoCard('Shard Statistics', state.shardingInfo.shardStatistics),
                    ],
                  );
                } else if (state is NodeDashboardLoading) {
                  return const CircularProgressIndicator();
                } else {
                  return const Text('Error loading sharding info');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShardingInfoCard(String title, dynamic data) {
    return GlassCard(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.h5),
            const SizedBox(height: AppSpacing.sm),
            Text(data.toString(), style: AppTextStyles.body2),
          ],
        ),
      ),
    );
  }
}
