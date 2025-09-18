import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/health_bloc.dart';
import '../../data/models/alert_model.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/common_widgets.dart';

class AlertsSection extends StatelessWidget {
  const AlertsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('System Alerts', style: AppTextStyles.h4),
            const SizedBox(height: AppSpacing.md),
            BlocBuilder<HealthBloc, HealthState>(
              builder: (context, state) {
                if (state is HealthLoaded) {
                  return _buildAlertsByCategory(state.alerts);
                } else if (state is HealthLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return const Text('Error loading alerts');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertsByCategory(List<AlertModel> alerts) {
    // Sort alerts by level (critical, error, warning, info)
    final sortedAlerts = List<AlertModel>.from(alerts);
    sortedAlerts.sort((a, b) {
      final levels = ['critical', 'error', 'warning', 'info'];
      return levels.indexOf(a.level.toLowerCase()).compareTo(levels.indexOf(b.level.toLowerCase()));
    });

    // Group alerts by level
    final criticalAlerts = sortedAlerts.where((alert) => alert.level.toLowerCase() == 'critical').toList();
    final errorAlerts = sortedAlerts.where((alert) => alert.level.toLowerCase() == 'error').toList();
    final warningAlerts = sortedAlerts.where((alert) => alert.level.toLowerCase() == 'warning').toList();
    final infoAlerts = sortedAlerts.where((alert) => alert.level.toLowerCase() == 'info').toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (criticalAlerts.isNotEmpty) ...[
            _buildAlertCategory('Critical', criticalAlerts, AppColors.error),
            const SizedBox(height: AppSpacing.sm),
          ],
          if (errorAlerts.isNotEmpty) ...[
            _buildAlertCategory('Error', errorAlerts, AppColors.error.withValues(alpha: 0.8)),
            const SizedBox(height: AppSpacing.sm),
          ],
          if (warningAlerts.isNotEmpty) ...[
            _buildAlertCategory('Warning', warningAlerts, AppColors.warning),
            const SizedBox(height: AppSpacing.sm),
          ],
          if (infoAlerts.isNotEmpty) ...[
            _buildAlertCategory('Info', infoAlerts, AppColors.info),
          ],
        ],
      ),
    );
  }

  Widget _buildAlertCategory(String category, List<AlertModel> alerts, Color backgroundColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(category, style: AppTextStyles.h5.copyWith(color: backgroundColor)),
        const SizedBox(height: AppSpacing.xs),
        ...alerts.map((alert) => _buildAlertItem(alert)).toList(),
      ],
    );
  }

  Widget _buildAlertItem(AlertModel alert) {
    Color levelColor = AppColors.info;
    if (alert.level.toLowerCase() == 'critical') {
      levelColor = AppColors.error;
    } else if (alert.level.toLowerCase() == 'error') {
      levelColor = AppColors.error.withValues(alpha: 0.8);
    } else if (alert.level.toLowerCase() == 'warning') {
      levelColor = AppColors.warning;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 2),
                decoration: BoxDecoration(
                  color: levelColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  alert.level.toUpperCase(),
                  style: AppTextStyles.caption.copyWith(color: Colors.white),
                ),
              ),
              Text(alert.timestamp, style: AppTextStyles.caption),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(alert.message, style: AppTextStyles.body2),
        ],
      ),
    );
  }
}