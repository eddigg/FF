import 'package:flutter/material.dart';
import 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' as glass_card;
import 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart';

class SocialRightSidebar extends StatelessWidget {
  const SocialRightSidebar({super.key});

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

    // Mock data for suggested users
    final mockSuggestedUsers = ['Bob', 'Charlie', 'David', 'Eve'];

    return glass_card.GlassCard(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Box
          TextFormField(
            decoration: WebParityTheme.inputDecoration('🔍 Search posts...'),
            onChanged: (value) {
              // For stub implementation, we just show a snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search functionality')),
              );
            },
          ),
          const SizedBox(height: 20),
          // Trending Now
          Text('🔥 Trending Now', style: WebParityTheme.panelTitleStyle),
          const SizedBox(height: 15),
          Column(
            children: mockTrendingTopics
                .map((topic) => _TrendingTopicItem(topic: topic))
                .toList(),
          ),
          const SizedBox(height: 30),
          // Suggested Users
          Text('👥 Suggested Users', style: WebParityTheme.panelTitleStyle),
          const SizedBox(height: 15),
          Column(
            children: mockSuggestedUsers
                .map((username) => _SuggestedUserItem(username: username))
                .toList(),
          ),
        ],
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

class _TrendingTopicItem extends StatelessWidget {
  final Map<String, dynamic> topic;

  const _TrendingTopicItem({required this.topic});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
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

class _SuggestedUserItem extends StatelessWidget {
  final String username;

  const _SuggestedUserItem({required this.username});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF667EEA), Color(0xFF764BA2)]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                username.substring(0, 1).toUpperCase(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              username,
              style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF2D3748)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // For stub implementation, we just show a snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Followed $username')),
              );
            },
            style: WebParityTheme.primaryButtonStyle,
            child: const Text('Follow'),
          ),
        ],
      ),
    );
  }
}