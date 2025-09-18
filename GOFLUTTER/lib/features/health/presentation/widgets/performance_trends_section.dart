import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/health_bloc.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/common_widgets.dart';

class PerformanceTrendsSection extends StatelessWidget {
  const PerformanceTrendsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Performance Trends', style: AppTextStyles.h4),
            const SizedBox(height: AppSpacing.md),
            BlocBuilder<HealthBloc, HealthState>(
              builder: (context, state) {
                if (state is HealthLoaded) {
                  return Column(
                    children: [
                      _buildTrendItem('📈 TPS Trend', 'TPS Trend', state.performanceTrends.tpsTrend),
                      _buildTrendItem('💾 Memory Trend', 'Memory Trend', state.performanceTrends.memoryTrend),
                      _buildTrendItem('⚡ CPU Trend', 'CPU Trend', state.performanceTrends.cpuTrend),
                    ],
                  );
                } else if (state is HealthLoading) {
                  return const CircularProgressIndicator();
                } else {
                  return const Text('Error loading performance trends');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendItem(String icon, String title, String value) {
    Color valueColor = AppColors.success;
    if (value.toLowerCase().contains('decreasing')) {
      valueColor = AppColors.error;
    } else if (value.toLowerCase().contains('stable')) {
      valueColor = AppColors.info;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Text(icon, style: AppTextStyles.body1),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(title, style: AppTextStyles.body2),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 2),
            decoration: BoxDecoration(
              color: valueColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: valueColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}