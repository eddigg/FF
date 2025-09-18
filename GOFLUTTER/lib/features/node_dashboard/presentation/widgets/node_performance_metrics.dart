
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/node_dashboard_bloc.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/common_widgets.dart';

class NodePerformanceMetrics extends StatelessWidget {
  const NodePerformanceMetrics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Node Performance Metrics', style: AppTextStyles.h4),
            const SizedBox(height: AppSpacing.md),
            BlocBuilder<NodeDashboardBloc, NodeDashboardState>(
              builder: (context, state) {
                if (state is NodeDashboardLoaded) {
                  return Column(
                    children: [
                      _buildMetricItem('Uptime', state.nodeMetrics.uptime),
                      _buildMetricItem('Blocks Produced', state.nodeMetrics.blocksProduced.toString()),
                      _buildMetricItem('Transactions Processed', state.nodeMetrics.transactionsProcessed.toString()),
                    ],
                  );
                } else if (state is NodeDashboardLoading) {
                  return const CircularProgressIndicator();
                } else {
                  return const Text('Error loading metrics');
                }
              },
            ),
            const SizedBox(height: AppSpacing.md),
            const Text('Controls', style: AppTextStyles.h4),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                GradientButton(text: 'Start', onPressed: () {}),
                GradientButton(text: 'Pause', onPressed: () {}),
                GradientButton(text: 'Stop', onPressed: () {}),
                GradientButton(text: 'Sync', onPressed: () {}),
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
                  child: Text('Logs will appear here...', style: AppTextStyles.body2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem(String title, String value) {
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
