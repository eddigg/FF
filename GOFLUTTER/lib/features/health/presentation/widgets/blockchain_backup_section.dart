
import 'package:flutter/material.dart';
import 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' as glass_card;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/stubs/stub_blocs_clean.dart';
import 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart';

class BlockchainBackupSection extends StatelessWidget {
  const BlockchainBackupSection({super.key});

  @override
  Widget build(BuildContext context) {
    return glass_card.GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('💾 Blockchain Backup', style: WebParityTheme.panelTitleStyle),
            const SizedBox(height: 12),
            BlocBuilder<HealthBloc, HealthState>(
              builder: (context, state) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Status: 🟢 Completed', style: TextStyle(fontSize: 14)),
                          SizedBox(height: 4),
                          Text('Last Backup: 2 hours ago', style: TextStyle(fontSize: 14)),
                          SizedBox(height: 4),
                          Text('Backup Size: 2.4GB', style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: null,
                            style: WebParityTheme.primaryButtonStyle,
                            child: const Text('📥 Backup Now'),
                          ),
                          ElevatedButton(
                            onPressed: null,
                            style: WebParityTheme.secondaryButtonStyle,
                            child: const Text('📤 Restore'),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PanelTitle extends StatelessWidget {
  final String title;
  const _PanelTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(title, style: WebParityTheme.panelTitleStyle),
    );
  }
}

class _BackupCard extends StatelessWidget {
  final String title;
  final Widget child;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const _BackupCard({required this.title, required this.child, this.buttonText, this.onButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Color(0xFF667EEA), fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          child,
          if (buttonText != null && onButtonPressed != null)
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: onButtonPressed, style: WebParityTheme.primaryButtonStyle, child: Text(buttonText!)),
              ),
            ),
        ],
      ),
    );
  }
}

class _BackupSystemStatus extends StatelessWidget {
  final dynamic status; // Replace with BackupStatusModel

  const _BackupSystemStatus({required this.status});

  @override
  Widget build(BuildContext context) {
    Color indicatorColor = Colors.grey;
    if (status.status == 'active') indicatorColor = Colors.green;
    if (status.status == 'inactive') indicatorColor = Colors.red;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 12, height: 12, decoration: BoxDecoration(color: indicatorColor, shape: BoxShape.circle)),
            const SizedBox(width: 10),
            Text('Status: ${status.status}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        Text('Last Backup: ${status.lastBackup}', style: const TextStyle(fontSize: 14)),
        Text('Next Backup: ${status.nextBackup}', style: const TextStyle(fontSize: 14)),
        Text('Auto Backup: ${status.autoBackup ? 'Enabled' : 'Disabled'}', style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}

class _BackupStatistics extends StatelessWidget {
  final dynamic status; // Replace with BackupStatusModel

  const _BackupStatistics({required this.status});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Total Backups: ${status.totalBackups}', style: const TextStyle(fontSize: 14)),
        Text('Total Size: ${status.totalSize}', style: const TextStyle(fontSize: 14)),
        Text('Verified: ${status.verifiedBackups}', style: const TextStyle(fontSize: 14, color: Colors.green)),
        Text('Corrupted: ${status.corruptedBackups}', style: const TextStyle(fontSize: 14, color: Colors.red)),
      ],
    );
  }
}

class _ManualBackupControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Create a manual backup of the current blockchain state', style: TextStyle(fontSize: 14, color: Color(0xFF666666))),
        const SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(onPressed: () {}, style: WebParityTheme.primaryButtonStyle, child: const Text('📦 Create Manual Backup')),
        ),
      ],
    );
  }
}

class _BackupHistory extends StatelessWidget {
  final List<dynamic> backups; // Replace with List<BackupItemModel>

  const _BackupHistory({required this.backups});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('📋 Backup History', style: TextStyle(color: Color(0xFF667EEA), fontSize: 18, fontWeight: FontWeight.bold)),
            ElevatedButton(onPressed: () {}, style: WebParityTheme.secondaryButtonStyle, child: const Text('🔄 Refresh')),
          ],
        ),
        const SizedBox(height: 15),
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: backups.isEmpty
              ? const Center(child: Text('No backups found'))
              : ListView.builder(
                  itemCount: backups.length,
                  itemBuilder: (context, index) {
                    final backup = backups[index];
                    Color statusColor = Colors.grey;
                    if (backup.status == 'created') statusColor = Colors.blue[700]!;
                    if (backup.status == 'verified') statusColor = Colors.green[700]!;
                    if (backup.status == 'corrupted') statusColor = Colors.red[700]!;

                    return Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 8, left: 10, right: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFF0F0F0)),
                      ),
                      child: Row(
                        children: [
                          Expanded(flex: 2, child: Text(backup.id, style: const TextStyle(fontFamily: 'Courier New', fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF667EEA)))),
                          Expanded(flex: 2, child: Text(backup.timestamp, style: const TextStyle(fontSize: 13, color: Color(0xFF666666)))),
                          Expanded(flex: 1, child: Text(backup.size, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(3)),
                            child: Text(backup.status.toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: statusColor)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
