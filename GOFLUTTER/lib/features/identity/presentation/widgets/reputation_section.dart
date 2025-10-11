import 'package:flutter/material.dart';
import '../../../../shared/widgets/common_widgets.dart' as glass_card;

class ReputationSection extends StatelessWidget {
  const ReputationSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock reputation data
    final mockReputationData = {
      'score': 850,
      'level': 'Gold Member',
      'badges': ['Early Adopter', 'Community Helper', 'Governance Voter', 'Social Contributor'],
      'metrics': {
        'transactions': 42,
        'governanceVotes': 15,
        'socialContributions': 28,
        'communityHelps': 12,
      },
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('⭐ Reputation Score', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Column(
          children: [
            glass_card.GlassCard(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  Text(
                    mockReputationData['score'].toString(),
                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w700, color: Color(0xFF4299E1)),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    mockReputationData['level'] as String,
                    style: const TextStyle(fontSize: 18, color: Color(0xFF2D3748)),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Your reputation score based on activity and community contributions',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Color(0xFF718096)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            glass_card.GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Reputation Badges', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: (mockReputationData['badges'] as List<String>).map<Widget>((badge) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4299E1).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        badge,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF4299E1)),
                      ),
                    )).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            glass_card.GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Reputation Metrics', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _StatItem(
                        value: (mockReputationData['metrics'] as Map<String, dynamic>)['transactions'].toString(),
                        label: 'Transactions',
                        color: const Color(0xFF4299E1),
                      ),
                      _StatItem(
                        value: (mockReputationData['metrics'] as Map<String, dynamic>)['governanceVotes'].toString(),
                        label: 'Governance Votes',
                        color: const Color(0xFF48BB78),
                      ),
                      _StatItem(
                        value: (mockReputationData['metrics'] as Map<String, dynamic>)['socialContributions'].toString(),
                        label: 'Social Posts',
                        color: const Color(0xFFED8936),
                      ),
                      _StatItem(
                        value: (mockReputationData['metrics'] as Map<String, dynamic>)['communityHelps'].toString(),
                        label: 'Community Helps',
                        color: const Color(0xFF667EEA),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatItem({required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: color),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Color(0xFF718096)),
          ),
        ],
      ),
    );
  }
}