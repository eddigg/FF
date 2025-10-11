import 'package:flutter/material.dart';
import 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' as glass_card;
import 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart';

class SocialSidebar extends StatelessWidget {
  final String selectedSection;
  final ValueChanged<String> onSectionSelected;

  const SocialSidebar({
    super.key,
    required this.selectedSection,
    required this.onSectionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final sections = [
      {'key': 'feed', 'title': '📰 Social Feed', 'icon': '📰'},
      {'key': 'create', 'title': '✏️ Create Post', 'icon': '✏️'},
      {'key': 'trending', 'title': '🔥 Trending Topics', 'icon': '🔥'},
      {'key': 'moderation', 'title': '🛡️ Content Moderation', 'icon': '🛡️'},
    ];

    // Mock user profile data
    final mockUserProfile = {
      'username': 'Alice',
      'postsCount': 42,
      'followersCount': 128,
      'followingCount': 64,
    };

    return glass_card.GlassCard(
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          // Navigation Menu
          Column(
            children: sections.map((section) {
              final isSelected = selectedSection == section['key'];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  onTap: () => onSectionSelected(section['key'] as String),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF667EEA).withOpacity(0.1) : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      gradient: isSelected
                          ? const LinearGradient(colors: [Color(0xFF667EEA), Color(0xFF764BA2)])
                          : null,
                    ),
                    child: Row(
                      children: [
                        Text(
                          section['icon'] as String,
                          style: TextStyle(
                            fontSize: 20,
                            color: isSelected ? Colors.white : const Color(0xFF4A5568),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          section['title'] as String,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: isSelected ? Colors.white : const Color(0xFF4A5568),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 30),
          // Profile Section
          _ProfileSection(user: mockUserProfile),
        ],
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final Map<String, dynamic> user;

  const _ProfileSection({required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF667EEA), Color(0xFF764BA2)]),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Center(
            child: Text(
              user['username'].toString().substring(0, 1).toUpperCase(),
              style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: 15),
        Text(
          user['username'].toString(),
          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600, color: Color(0xFF2D3748)),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StatItem(value: user['postsCount'].toString(), label: 'Posts'),
            _StatItem(value: user['followersCount'].toString(), label: 'Followers'),
            _StatItem(value: user['followingCount'].toString(), label: 'Following'),
          ],
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF667EEA)),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Color(0xFF718096)),
        ),
      ],
    );
  }
}