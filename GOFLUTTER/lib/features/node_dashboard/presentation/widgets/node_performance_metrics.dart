import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/stubs/stub_blocs_clean.dart';
import 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart';
import '../../../../shared/widgets/common_widgets.dart' as glass_card;

class NodePerformanceMetrics extends StatelessWidget {
  const NodePerformanceMetrics({super.key});

  @override
  Widget build(BuildContext context) {
    return glass_card.GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Node Performance Metrics',
              style: WebParityTheme.panelTitleStyle,
            ),
            const SizedBox(height: 12),
            BlocBuilder<NodeDashboardBloc, NodeDashboardState>(
              builder: (context, state) {
                if (state is NodeDashboardLoaded) {
                  return Column(
                    children: [
                      _MetricCard(
                        label: 'Uptime',
                        value: state.nodeMetrics['uptime'],
                      ),
                      _MetricCard(
                        label: 'Blocks Produced',
                        value: state.nodeMetrics['blocksProduced'].toString(),
                      ),
                      _MetricCard(
                        label: 'Transactions Processed',
                        value: state.nodeMetrics['transactionsProcessed']
                            .toString(),
                      ),
                    ],
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
            const SizedBox(height: 20),
            const _NodeControls(),
            const SizedBox(height: 20),
            const _NodeLogs(),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;

  const _MetricCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
        ],
      ),
    );
  }
}

class _NodeControls extends StatelessWidget {
  const _NodeControls();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Controls',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: WebParityTheme.primaryButtonStyle.copyWith(
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                  textStyle: MaterialStateProperty.all(
                    const TextStyle(fontSize: 12),
                  ),
                ),
                child: const Text('▶️ Start'),
              ),
              ElevatedButton(
                onPressed: () {},
                style: WebParityTheme.warningButtonStyle.copyWith(
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                  textStyle: MaterialStateProperty.all(
                    const TextStyle(fontSize: 12),
                  ),
                ),
                child: const Text('⏸️ Pause'),
              ),
              ElevatedButton(
                onPressed: () {},
                style: WebParityTheme.dangerButtonStyle.copyWith(
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                  textStyle: MaterialStateProperty.all(
                    const TextStyle(fontSize: 12),
                  ),
                ),
                child: const Text('⏹️ Stop'),
              ),
              ElevatedButton(
                onPressed: () {},
                style: WebParityTheme.successButtonStyle.copyWith(
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                  textStyle: MaterialStateProperty.all(
                    const TextStyle(fontSize: 12),
                  ),
                ),
                child: const Text('🔄 Sync'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NodeLogs extends StatelessWidget {
  const _NodeLogs();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Node Logs',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 80,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF2C3E50),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView(
            children: const [
              Text(
                '[INFO] Network dashboard initialized',
                style: TextStyle(color: Color(0xFFECF0F1), fontSize: 12),
              ),
              Text(
                '[INFO] Connecting to blockchain network...',
                style: TextStyle(color: Color(0xFFECF0F1), fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
