
import 'package:flutter/material.dart';
import 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' as glass_card;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/stubs/stub_blocs_clean.dart';
import 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart';

class TestEnvironmentSection extends StatelessWidget {
  const TestEnvironmentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return glass_card.GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🧪 Test Environment & Testing', style: WebParityTheme.panelTitleStyle),
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
                          Text('Status: 🟢 Active', style: TextStyle(fontSize: 14)),
                          SizedBox(height: 4),
                          Text('Tests Running: 24', style: TextStyle(fontSize: 14)),
                          SizedBox(height: 4),
                          Text('Success Rate: 98.5%', style: TextStyle(fontSize: 14)),
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
                            child: const Text('▶️ Start Tests'),
                          ),
                          ElevatedButton(
                            onPressed: null,
                            style: WebParityTheme.warningButtonStyle,
                            child: const Text('⏸️ Pause'),
                          ),
                          ElevatedButton(
                            onPressed: null,
                            style: WebParityTheme.dangerButtonStyle,
                            child: const Text('⏹️ Stop'),
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

class _TestEnvStatus extends StatelessWidget {
  final dynamic status; // Replace with TestEnvironmentStatusModel

  const _TestEnvStatus({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE9ECEF)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatusItem(label: 'Nodes', value: status.nodes.toString()),
          _StatusItem(label: 'Wallets', value: status.wallets.toString()),
          _StatusItem(label: 'Txs', value: status.transactions.toString()),
          _StatusItem(label: 'Blocks', value: status.blocks.toString()),
        ],
      ),
    );
  }
}

class _StatusItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatusItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF667EEA))),
        Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF6C757D))),
      ],
    );
  }
}

class _TestEnvControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(onPressed: () {}, style: WebParityTheme.primaryButtonStyle, child: const Text('Start Test Environment')),
        const SizedBox(width: 12),
        ElevatedButton(onPressed: () {}, style: WebParityTheme.secondaryButtonStyle, child: const Text('Stop Test Environment')),
      ],
    );
  }
}

class _TestTypeButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: [
        ElevatedButton(onPressed: () {}, style: WebParityTheme.primaryButtonStyle, child: const Text('Automated Tests')),
        ElevatedButton(onPressed: () {}, style: WebParityTheme.secondaryButtonStyle, child: const Text('Performance Tests')),
        ElevatedButton(onPressed: () {}, style: WebParityTheme.secondaryButtonStyle, child: const Text('Security Tests')),
        ElevatedButton(onPressed: () {}, style: WebParityTheme.secondaryButtonStyle, child: const Text('Integration Tests')),
      ],
    );
  }
}

class _TestResultsPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE9ECEF)),
      ),
      child: const Center(
        child: Text('Click a test button to run tests and view results', style: TextStyle(fontSize: 14, color: Color(0xFF666666))),
      ),
    );
  }
}
