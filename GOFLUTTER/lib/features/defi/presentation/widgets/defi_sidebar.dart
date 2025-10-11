import 'package:flutter/material.dart';
import 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' as glass_card;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/stubs/stub_blocs_clean.dart'; // Use stub BLoC instead

class DeFiSidebar extends StatelessWidget {
  final String selectedSection;
  final ValueChanged<String> onSectionSelected;

  const DeFiSidebar({
    super.key,
    required this.selectedSection,
    required this.onSectionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final sections = [
      {'key': 'portfolio', 'title': '📊 Portfolio', 'icon': '📊'},
      {'key': 'lending', 'title': '💰 Lending', 'icon': '💰'},
      {'key': 'trading', 'title': '📈 Trading', 'icon': '📈'},
      {'key': 'staking', 'title': '🔒 Staking', 'icon': '🔒'},
      {'key': 'liquidity', 'title': '💧 Liquidity', 'icon': '💧'},
      {'key': 'yield', 'title': '🌾 Yield Farming', 'icon': '🌾'},
    ];

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
                      color: isSelected ? const Color(0xFF48BB78).withValues(alpha: 0.1) : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      gradient: isSelected ? const LinearGradient(colors: [Color(0xFF48BB78), Color(0xFF38A169)]) : null,
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
          // Portfolio Summary - simplified to always show mock data
          _PortfolioSummary(),
        ],
      ),
    );
  }
}

class _PortfolioSummary extends StatelessWidget {
  const _PortfolioSummary();

  @override
  Widget build(BuildContext context) {
    final mockPortfolio = {
      'totalValue': 25000.00,
      'change': 5.2,
      'staked': 12500,
      'lent': 5000,
      'rewards': 1250,
      'apy': 12.5,
    };

    final bool isNegativeChange = mockPortfolio['change']! < 0;
    return glass_card.GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('\$${mockPortfolio['totalValue']!.toStringAsFixed(2)}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: Color(0xFF48BB78))),
          const SizedBox(height: 10),
          Text(
            '${isNegativeChange ? '' : '+'}${mockPortfolio['change']!.toStringAsFixed(2)}%',
            style: TextStyle(fontSize: 14, color: isNegativeChange ? Colors.red[600] : const Color(0xFF48BB78)),
          ),
          const SizedBox(height: 15),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _StatItem(value: '\$${mockPortfolio['staked']!.toStringAsFixed(0)}', label: 'Staked'),
              _StatItem(value: '\$${mockPortfolio['lent']!.toStringAsFixed(0)}', label: 'Lent'),
              _StatItem(value: '\$${mockPortfolio['rewards']!.toStringAsFixed(0)}', label: 'Rewards'),
              _StatItem(value: '${mockPortfolio['apy']!.toStringAsFixed(0)}%', label: 'APY'),
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
        color: const Color(0xFF48BB78).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600, color: Color(0xFF2D3748))),
          Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF718096))),
        ],
      ),
    );
  }
}