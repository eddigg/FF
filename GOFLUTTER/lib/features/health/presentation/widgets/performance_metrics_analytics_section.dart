import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/health_bloc.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/common_widgets.dart';

class PerformanceMetricsAnalyticsSection extends StatelessWidget {
  const PerformanceMetricsAnalyticsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Performance Metrics & Analytics', style: AppTextStyles.h4),
            const SizedBox(height: AppSpacing.md),
            BlocBuilder<HealthBloc, HealthState>(
              builder: (context, state) {
                if (state is HealthLoaded) {
                  return _buildMetricsGrid(state);
                } else if (state is HealthLoading) {
                  return const CircularProgressIndicator();
                } else {
                  return const Text('Error loading performance metrics');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsGrid(HealthLoaded state) {
    final metrics = [
      {'label': 'Transactions/sec', 'value': state.performanceMetrics.tps.toString(), 'unit': 'TPS'},
      {'label': 'Block Time', 'value': state.performanceMetrics.blockTime.toString(), 'unit': 's'},
      {'label': 'Memory Usage', 'value': state.performanceMetrics.memoryUsage.toString(), 'unit': 'MB'},
      {'label': 'CPU Usage', 'value': state.performanceMetrics.cpuUsage.toString(), 'unit': '%'},
      {'label': 'Network Latency', 'value': state.performanceMetrics.networkLatency.toString(), 'unit': 'ms'},
      {'label': 'Active Peers', 'value': state.performanceMetrics.activePeers.toString(), 'unit': ''},
      {'label': 'Validators', 'value': state.performanceMetrics.validatorCount.toString(), 'unit': ''},
      {'label': 'Pending Tx', 'value': state.performanceMetrics.pendingTransactions.toString(), 'unit': ''},
      {'label': 'Block Height', 'value': state.performanceMetrics.blockHeight.toString(), 'unit': ''},
      {'label': 'Total Staked', 'value': state.performanceMetrics.totalStaked.toString(), 'unit': ' tokens'},
      {'label': 'Avg Block Size', 'value': state.performanceMetrics.avgBlockSize.toString(), 'unit': 'KB'},
      {'label': 'Gas Price', 'value': state.performanceMetrics.gasPrice.toString(), 'unit': ''},
      {'label': 'Contracts', 'value': state.performanceMetrics.contractCount.toString(), 'unit': ''},
    ];

    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: AppSpacing.sm,
      mainAxisSpacing: AppSpacing.sm,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: metrics.map((metric) => _buildMetricCard(metric)).toList(),
    );
  }

  Widget _buildMetricCard(Map<String, dynamic> metric) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${metric['value']}${metric['unit']}',
            style: AppTextStyles.body1.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            metric['label'],
            style: AppTextStyles.caption,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Healthy',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.success,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}