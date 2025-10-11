import 'package:flutter/material.dart';
import 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart';

class TrendingTopicsSection extends StatelessWidget {
  const TrendingTopicsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for trending topics
    final mockTrendingTopics = [
      {'name': '#ATLASBlockchain', 'count': 1245},
      {'name': '#DeFi', 'count': 892},
      {'name': '#SmartContracts', 'count': 756},
      {'name': '#Web3', 'count': 634},
      {'name': '#Crypto', 'count': 521},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('🔥 Trending Topics', style: WebParityTheme.panelTitleStyle),
        const SizedBox(height: 20),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: mockTrendingTopics.length,
          itemBuilder: (context, index) {
            final topic = mockTrendingTopics[index];
            return _TrendingTopicItem(topic: topic);
          },
        ),
      ],
    );
  }
}

class _TrendingTopicItem extends StatelessWidget {
  final Map<String, dynamic> topic;

  const _TrendingTopicItem({required this.topic});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            topic['name'],
            style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF2D3748)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF667EEA).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              topic['count'].toString(),
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF667EEA)),
            ),
          ),
        ],
      ),
    );
  }
}