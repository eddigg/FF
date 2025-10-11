import 'package:flutter/material.dart';
import '../../../../shared/widgets/common_widgets.dart' as glass_card;

class ActivitySection extends StatelessWidget {
  const ActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock activity history data
    final mockActivityHistory = [
      {
        'icon': '📝',
        'title': 'Updated profile information',
        'time': '2 hours ago',
      },
      {
        'icon': '🔒',
        'title': 'Enabled two-factor authentication',
        'time': '1 day ago',
      },
      {
        'icon': '📧',
        'title': 'Verified email address',
        'time': '2 days ago',
      },
      {
        'icon': '📱',
        'title': 'Added phone number',
        'time': '3 days ago',
      },
      {
        'icon': '🗳️',
        'title': 'Voted on governance proposal #12',
        'time': '1 week ago',
      },
    ];

    // Mock activity metrics data
    final mockActivityMetrics = {
      'transactions': 42,
      'proposalsCreated': 3,
      'votesCast': 15,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('📊 Activity History', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Column(
          children: [
            glass_card.GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Recent Activity', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  ...mockActivityHistory.map<Widget>((activity) => _ActivityItem(activity: activity)).toList(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            glass_card.GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Activity Statistics', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _StatItem(
                        value: mockActivityMetrics['transactions'].toString(),
                        label: 'Transactions',
                        color: const Color(0xFF4299E1),
                      ),
                      _StatItem(
                        value: mockActivityMetrics['proposalsCreated'].toString(),
                        label: 'Proposals Created',
                        color: const Color(0xFF48BB78),
                      ),
                      _StatItem(
                        value: mockActivityMetrics['votesCast'].toString(),
                        label: 'Votes Cast',
                        color: const Color(0xFFED8936),
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

class _ActivityItem extends StatelessWidget {
  final Map<String, dynamic> activity;

  const _ActivityItem({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF4299E1).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                activity['icon'] as String,
                style: const TextStyle(fontSize: 20, color: Color(0xFF4299E1)),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['title'] as String,
                  style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF2D3748)),
                ),
                Text(
                  activity['time'] as String,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF718096)),
                ),
              ],
            ),
          ),
        ],
      ),
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
        color: color.withValues(alpha: 0.1),
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