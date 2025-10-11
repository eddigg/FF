import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/stubs/stub_blocs_clean.dart';
import 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart';
import '../../../../shared/widgets/common_widgets.dart' as glass_card;

class GovernanceOverview extends StatelessWidget {
  const GovernanceOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return glass_card.GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🏛️ Governance Overview', style: WebParityTheme.panelTitleStyle),
            const SizedBox(height: 12),
            BlocBuilder<GovernanceBloc, GovernanceState>(
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
                          Text('Total Proposals: 24', style: TextStyle(fontSize: 14)),
                          SizedBox(height: 4),
                          Text('Active Proposals: 3', style: TextStyle(fontSize: 14)),
                          SizedBox(height: 4),
                          Text('Participation Rate: 68%', style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Recent Activity',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 120,
                      child: ListView(
                        children: const [
                          _ActivityItem(
                            title: 'New Proposal: Network Upgrade',
                            time: '2 hours ago',
                            type: 'proposal',
                          ),
                          _ActivityItem(
                            title: 'Voting Ended: Fee Structure',
                            time: '1 day ago',
                            type: 'vote',
                          ),
                          _ActivityItem(
                            title: 'Proposal Executed: Staking Rewards',
                            time: '3 days ago',
                            type: 'execute',
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

class _ActivityItem extends StatelessWidget {
  final String title;
  final String time;
  final String type;

  const _ActivityItem({
    required this.title,
    required this.time,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    String icon = 'ℹ️';
    if (type == 'proposal') icon = '📝';
    if (type == 'vote') icon = '✅';
    if (type == 'execute') icon = '⚡';

    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13)),
                Text(time, style: const TextStyle(fontSize: 11, color: Color(0xFF718096))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}