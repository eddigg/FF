import 'package:flutter/material.dart';
import 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' as glass_card;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/stubs/stub_blocs_clean.dart';
import 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart';

class AlertsSection extends StatelessWidget {
  const AlertsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return glass_card.GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('⚠️ Alerts & Notifications', style: WebParityTheme.panelTitleStyle),
            const SizedBox(height: 12),
            BlocBuilder<HealthBloc, HealthState>(
              builder: (context, state) {
                return Container(
                  height: 150,
                  child: ListView(
                    children: const [
                      _AlertItem(
                        severity: '⚠️',
                        message: 'High memory usage detected',
                        time: '2 min ago',
                      ),
                      _AlertItem(
                        severity: 'ℹ️',
                        message: 'New version available',
                        time: '1 hour ago',
                      ),
                      _AlertItem(
                        severity: '✅',
                        message: 'System backup completed',
                        time: '3 hours ago',
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AlertItem extends StatelessWidget {
  final String severity;
  final String message;
  final String time;

  const _AlertItem({
    required this.severity,
    required this.message,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Text(severity, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message, style: const TextStyle(fontSize: 13)),
                Text(time, style: const TextStyle(fontSize: 11, color: Color(0xFF718096))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}