import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/health_bloc.dart';
import '../../data/models/health_check_model.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/common_widgets.dart';

class HealthChecksSection extends StatelessWidget {
  const HealthChecksSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Health Checks', style: AppTextStyles.h4),
            const SizedBox(height: AppSpacing.md),
            BlocBuilder<HealthBloc, HealthState>(
              builder: (context, state) {
                if (state is HealthLoaded) {
                  return GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppSpacing.sm,
                    mainAxisSpacing: AppSpacing.sm,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: state.healthChecks.map((check) => _buildHealthCheckCard(check)).toList(),
                  );
                } else if (state is HealthLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return const Text('Error loading health checks');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthCheckCard(HealthCheckModel check) {
    Color statusColor = AppColors.success;
    String statusText = 'Healthy';
    
    if (check.status.toLowerCase() == 'degraded') {
      statusColor = AppColors.warning;
      statusText = 'Degraded';
    } else if (check.status.toLowerCase() == 'unhealthy') {
      statusColor = AppColors.error;
      statusText = 'Unhealthy';
    }

    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              check.name.toUpperCase().replaceAll('_', ' '),
              style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(statusText, style: AppTextStyles.caption),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Expanded(
              child: Text(
                check.message,
                style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}