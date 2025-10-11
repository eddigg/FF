import 'package:flutter/material.dart';
import 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' as glass_card;
import '../../../../shared/themes/web_parity_theme.dart';

class IdentitySidebar extends StatelessWidget {
  final String selectedSection;
  final ValueChanged<String> onSectionSelected;

  const IdentitySidebar({
    super.key,
    required this.selectedSection,
    required this.onSectionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final sections = [
      {'key': 'profile', 'title': '👤 Profile', 'icon': '👤'},
      {'key': 'kyc', 'title': '🆔 KYC Verification', 'icon': '🆔'},
      {'key': 'privacy', 'title': '🔒 Privacy Settings', 'icon': '🔒'},
      {'key': 'verification', 'title': '✅ Identity Verification', 'icon': '✅'},
      {'key': 'activity', 'title': '📊 Activity History', 'icon': '📊'},
      {'key': 'reputation', 'title': '⭐ Reputation Score', 'icon': '⭐'},
    ];

    // Mock user profile data
    final mockUserProfile = {
      'username': 'alice_blockchain',
      'status': 'Active',
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
                      color: isSelected ? const Color(0xFF4299E1).withOpacity(0.1) : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      gradient: isSelected ? const LinearGradient(colors: [Color(0xFF4299E1), Color(0xFF3182CE)]) : null,
                    ),
                    child: Row(
                      children: [
                        Text(section['icon'] as String, style: TextStyle(fontSize: 20, color: isSelected ? Colors.white : const Color(0xFF4A5568))),
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
          // Profile Summary
          _ProfileSummary(
            user: mockUserProfile,
            reputationScore: 850,
            verificationLevel: 'Gold',
          ),
        ],
      ),
    );
  }
}

class _ProfileSummary extends StatelessWidget {
  final Map<String, dynamic> user;
  final int reputationScore;
  final String verificationLevel;

  const _ProfileSummary({required this.user, required this.reputationScore, required this.verificationLevel});

  @override
  Widget build(BuildContext context) {
    return glass_card.GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF4299E1), Color(0xFF3182CE)]),
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
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF48BB78).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              user['status'].toString(),
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF48BB78)),
            ),
          ),
          const SizedBox(height: 15),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _StatItem(value: reputationScore.toString(), label: 'Reputation'),
              _StatItem(value: verificationLevel, label: 'Verification'),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF4299E1).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600, color: Color(0xFF2D3748)),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF718096)),
          ),
        ],
      ),
    );
  }
}