import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/dashboard_bloc.dart';
import '../../../../shared/widgets/custom_widgets.dart';
import '../../../../shared/themes/app_colors.dart';

class NodeMetricsCard extends StatelessWidget {
  const NodeMetricsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EnhancedGlassCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📈 Node Metrics',
              style: AppTextStyles.h2.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.01,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            BlocBuilder<DashboardBloc, DashboardState>(
              builder: (context, state) {
                if (state is DashboardLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is DashboardLoaded) {
                  return _buildMetricsGrid(state.dashboardModel);
                } else if (state is DashboardError) {
                  return Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: AppColors.error),
                  );
                }
                return const Text('Press refresh to load data');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsGrid(dynamic dashboardModel) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: AppSpacing.md,
      mainAxisSpacing: AppSpacing.md,
      children: [
        _buildMetricCard(
          'Blocks',
          dashboardModel.blockCount.toString(),
          'Latest block height',
          Icons.account_tree,
        ),
        _buildMetricCard(
          'Transactions',
          dashboardModel.transactionCount.toString(),
          'In recent blocks',
          Icons.swap_horiz,
        ),
        _buildMetricCard(
          'Peers',
          dashboardModel.peerCount.toString(),
          'Connected nodes',
          Icons.group,
        ),
        _buildMetricCard(
          'Latency',
          '${dashboardModel.networkLatency.toStringAsFixed(1)}ms',
          'Network response time',
          Icons.timer,
        ),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, String description, IconData icon) {
    return EnhancedGlassCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: AppColors.primary),
            const SizedBox(height: AppSpacing.sm),
            Text(
              value,
              style: AppTextStyles.h3.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              title,
              style: AppTextStyles.body1.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              description,
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}