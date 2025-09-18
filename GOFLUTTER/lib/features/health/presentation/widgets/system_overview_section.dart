import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/health_bloc.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/common_widgets.dart';

class SystemOverviewSection extends StatelessWidget {
  const SystemOverviewSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('System Overview & Blockchain Status', style: AppTextStyles.h4),
                GradientButton(
                  text: '🔄 Refresh Status',
                  onPressed: () {
                    context.read<HealthBloc>().add(RefreshHealthData());
                  },
                  gradient: AppColors.secondaryGradient,
                  width: 150,
                  height: 30,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            BlocBuilder<HealthBloc, HealthState>(
              builder: (context, state) {
                if (state is HealthLoaded) {
                  return Column(
                    children: [
                      _buildUptimeVersionInfo(state.systemStatus.uptime, state.systemStatus.version),
                      const SizedBox(height: AppSpacing.md),
                      _buildNetworkStatisticsGrid(state),
                      const SizedBox(height: AppSpacing.md),
                      _buildConnectionStatus(state.systemStatus.connectionStatus),
                      const SizedBox(height: AppSpacing.md),
                      _buildRecentTransactionsSection(context),
                    ],
                  );
                } else if (state is HealthLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return const Text('Error loading system overview');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUptimeVersionInfo(String uptime, String version) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Uptime: $uptime', style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: AppSpacing.xs),
        Text('Version: $version', style: AppTextStyles.caption),
      ],
    );
  }

  Widget _buildNetworkStatisticsGrid(HealthLoaded state) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: AppSpacing.sm,
      mainAxisSpacing: AppSpacing.sm,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildStatCard('Total Blocks', state.systemStatus.totalBlocks.toString()),
        _buildStatCard('Total Transactions', state.systemStatus.totalTransactions.toString()),
        _buildStatCard('Active Validators', state.systemStatus.activeValidators.toString()),
        _buildStatCard('Pool Size', state.systemStatus.poolSize.toString()),
      ],
    );
  }

  Widget _buildStatCard(String label, String value) {
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
          Text(value, style: AppTextStyles.h5.copyWith(color: AppColors.primary)),
          const SizedBox(height: AppSpacing.xs),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }

  Widget _buildConnectionStatus(String status) {
    Color statusColor = AppColors.success;
    if (status.toLowerCase().contains('connecting')) {
      statusColor = AppColors.warning;
    } else if (status.toLowerCase().contains('offline')) {
      statusColor = AppColors.error;
    }

    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: statusColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text('Connection Status: $status', style: AppTextStyles.body2),
      ],
    );
  }

  Widget _buildRecentTransactionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Recent Transactions', style: AppTextStyles.h5),
        const SizedBox(height: AppSpacing.sm),
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            border: Border.all(color: AppColors.border),
          ),
          child: BlocBuilder<HealthBloc, HealthState>(
            builder: (context, state) {
              if (state is HealthLoaded) {
                // For now, we'll show a placeholder since we don't have transaction data in the current model
                return const Center(
                  child: Text('No recent transactions', style: AppTextStyles.caption),
                );
              } else if (state is HealthLoading) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return const Center(
                  child: Text('Error loading transactions', style: AppTextStyles.caption),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}