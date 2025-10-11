import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/stubs/stub_blocs_clean.dart';
import 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart';
import '../../../../shared/widgets/common_widgets.dart' as glass_card;

class ProposalsSection extends StatelessWidget {
  const ProposalsSection({super.key});

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
                Text('📝 Active Proposals', style: WebParityTheme.panelTitleStyle),
                ElevatedButton(
                  onPressed: () => context.go('/governance/create'),
                  style: WebParityTheme.primaryButtonStyle,
                  child: const Text('NewProposal'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            BlocBuilder<GovernanceBloc, GovernanceState>(
              builder: (context, state) {
                return Container(
                  height: 200,
                  child: ListView(
                    children: const [
                      _ProposalItem(
                        id: 'P-001',
                        title: 'Network Upgrade v2.0',
                        status: 'Voting',
                        votes: '1,245/2,100',
                      ),
                      _ProposalItem(
                        id: 'P-002',
                        title: 'Fee Structure Adjustment',
                        status: 'Discussion',
                        votes: '876/2,100',
                      ),
                      _ProposalItem(
                        id: 'P-003',
                        title: 'New Validator Onboarding',
                        status: 'Review',
                        votes: '2,034/2,100',
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

class _ProposalItem extends StatelessWidget {
  final String id;
  final String title;
  final String status;
  final String votes;

  const _ProposalItem({
    required this.id,
    required this.title,
    required this.status,
    required this.votes,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.grey;
    if (status == 'Voting') statusColor = Colors.blue;
    if (status == 'Discussion') statusColor = Colors.orange;
    if (status == 'Review') statusColor = Colors.purple;

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(id, style: const TextStyle(fontWeight: FontWeight.w600)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(status, style: TextStyle(color: statusColor, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 4),
          Text('Votes: $votes', style: const TextStyle(fontSize: 13, color: Color(0xFF718096))),
        ],
      ),
    );
  }
}