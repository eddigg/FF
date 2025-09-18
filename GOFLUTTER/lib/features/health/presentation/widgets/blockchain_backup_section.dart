import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/health_bloc.dart';
import '../../data/models/backup_status_model.dart';
import '../../data/models/backup_item_model.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/common_widgets.dart';

class BlockchainBackupSection extends StatelessWidget {
  const BlockchainBackupSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Blockchain Backup System', style: AppTextStyles.h4),
            const SizedBox(height: AppSpacing.md),
            BlocBuilder<HealthBloc, HealthState>(
              builder: (context, state) {
                if (state is HealthLoaded) {
                  return Column(
                    children: [
                      _buildBackupDashboard(state.backupStatus),
                      const SizedBox(height: AppSpacing.md),
                      _buildBackupHistory(state.backupHistory),
                    ],
                  );
                } else if (state is HealthLoading) {
                  return const CircularProgressIndicator();
                } else {
                  return const Text('Error loading backup status');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackupDashboard(BackupStatusModel status) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildBackupCard(
                'System Status',
                _buildStatusIndicator(status.status),
                _buildBackupStatusMetrics(status),
                GradientButton(
                  text: '🔄 Refresh Status',
                  onPressed: () {},
                  gradient: AppColors.secondaryGradient,
                  width: double.infinity,
                  height: 30,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildBackupCard(
                'Backup Statistics',
                null,
                _buildBackupStats(status),
                null,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildBackupCard(
                'Manual Controls',
                const Text(
                  'Create a manual backup of the current blockchain state',
                  style: AppTextStyles.caption,
                ),
                null,
                GradientButton(
                  text: '📦 Create Manual Backup',
                  onPressed: () {},
                  width: double.infinity,
                  height: 30,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBackupCard(String title, Widget? header, Widget? content, Widget? button) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: AppTextStyles.h5.copyWith(color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            if (header != null) ...[
              header,
              const SizedBox(height: AppSpacing.sm),
            ],
            if (content != null) ...[
              content,
              const SizedBox(height: AppSpacing.sm),
            ],
            if (button != null) button,
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(String status) {
    Color indicatorColor = AppColors.success;
    if (status.toLowerCase() == 'inactive') {
      indicatorColor = AppColors.error;
    } else if (status.toLowerCase() == 'unknown') {
      indicatorColor = AppColors.warning;
    }

    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: indicatorColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          status,
          style: AppTextStyles.body2.copyWith(
            color: indicatorColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildBackupStatusMetrics(BackupStatusModel status) {
    return Column(
      children: [
        _buildInfoItem('Last Backup', status.lastBackup),
        _buildInfoItem('Next Backup', status.nextBackup),
        _buildInfoItem(
          'Auto Backup',
          status.autoBackup ? 'Enabled' : 'Disabled',
          status.autoBackup ? AppColors.success : AppColors.error,
        ),
      ],
    );
  }

  Widget _buildBackupStats(BackupStatusModel status) {
    return Column(
      children: [
        _buildInfoItem('Total Backups', status.totalBackups.toString()),
        _buildInfoItem('Total Size', status.totalSize),
        _buildInfoItem('Verified', status.verifiedBackups.toString(), AppColors.success),
        _buildInfoItem('Corrupted', status.corruptedBackups.toString(), AppColors.error),
      ],
    );
  }

  Widget _buildBackupHistory(List<BackupItemModel> backupHistory) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Backup History', style: AppTextStyles.h4),
            GradientButton(
              text: '🔄 Refresh',
              onPressed: () {},
              gradient: AppColors.secondaryGradient,
              width: 100,
              height: 30,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        if (backupHistory.isEmpty)
          Container(
            height: 100,
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              border: Border.all(color: AppColors.border),
            ),
            child: const Center(
              child: Text('No backups found', style: AppTextStyles.caption),
            ),
          )
        else
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              border: Border.all(color: AppColors.border),
            ),
            child: ListView.builder(
              itemCount: backupHistory.length,
              itemBuilder: (context, index) {
                final backup = backupHistory[index];
                return _buildBackupItem(backup);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildBackupItem(BackupItemModel backup) {
    Color statusColor = AppColors.info;
    if (backup.status.toLowerCase() == 'created') {
      statusColor = AppColors.primary;
    } else if (backup.status.toLowerCase() == 'verified') {
      statusColor = AppColors.success;
    } else if (backup.status.toLowerCase() == 'corrupted') {
      statusColor = AppColors.error;
    }

    return Container(
      margin: const EdgeInsets.all(AppSpacing.xs),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              backup.id,
              style: AppTextStyles.caption.copyWith(fontFamily: 'monospace'),
            ),
          ),
          Expanded(
            child: Text(
              backup.timestamp,
              style: AppTextStyles.caption,
            ),
          ),
          Expanded(
            child: Text(
              backup.size,
              style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 2),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              backup.status,
              style: AppTextStyles.caption.copyWith(
                color: statusColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String title, String value, [Color? valueColor]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.body2),
          Text(
            value,
            style: AppTextStyles.body1.copyWith(
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}