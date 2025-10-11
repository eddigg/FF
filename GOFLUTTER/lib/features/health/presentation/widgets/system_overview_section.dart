
import 'package:flutter/material.dart';
import 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' as glass_card;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/stubs/stub_blocs_clean.dart';
import 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart';

class SystemOverviewSection extends StatelessWidget {
  const SystemOverviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return glass_card.GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('🏥 System Overview & Blockchain Status', style: WebParityTheme.panelTitleStyle),
                ElevatedButton(
                  onPressed: () => context.read<HealthBloc>().add(LoadHealthData()),
                  style: WebParityTheme.primaryButtonStyle.copyWith(
                    padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                    textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 14)),
                  ),
                  child: const Text('🔄 Refresh Status'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            BlocBuilder<HealthBloc, HealthState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'System Health',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('🟢 System Status: Operational', style: TextStyle(fontSize: 14)),
                          SizedBox(height: 4),
                          Text('📈 Uptime: 99.98%', style: TextStyle(fontSize: 14)),
                          SizedBox(height: 4),
                          Text('⏱️ Response Time: 42ms', style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Blockchain Status',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('🔗 Network: Connected', style: TextStyle(fontSize: 14)),
                          SizedBox(height: 4),
                          Text('🔢 Block Height: 12,345', style: TextStyle(fontSize: 14)),
                          SizedBox(height: 4),
                          Text('⏱️ Block Time: 12.3s', style: TextStyle(fontSize: 14)),
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

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF4299E1))),
          Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF6C757D))),
        ],
      ),
    );
  }
}

class _ConnectionStatus extends StatelessWidget {
  final String status;

  const _ConnectionStatus({required this.status});

  @override
  Widget build(BuildContext context) {
    Color indicatorColor = Colors.orange;
    String statusText = 'Connecting...';
    if (status == 'Connected') {
      indicatorColor = Colors.green;
      statusText = 'Connected';
    } else if (status == 'Disconnected') {
      indicatorColor = Colors.red;
      statusText = 'Disconnected';
    }

    return Row(
      children: [
        const Text('Connection Status:', style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
        const SizedBox(width: 10),
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: indicatorColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(statusText, style: TextStyle(fontSize: 12, color: indicatorColor)),
      ],
    );
  }
}

class _RecentTransactions extends StatelessWidget {
  final List<dynamic> transactions; // Assuming a list of dynamic for now

  const _RecentTransactions({required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('📋 Recent Transactions', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF495057))),
        const SizedBox(height: 8),
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(8),
          ),
          child: transactions.isEmpty
              ? const Center(child: Text('No recent transactions', style: TextStyle(fontSize: 12, color: Color(0xFF6C757D))))
              : ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final tx = transactions[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      child: Text(
                        '${tx['Sender'].substring(0, 6)}... -> ${tx['Recipient'].substring(0, 6)}... (${tx['Amount']} tokens)',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF6C757D)),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
