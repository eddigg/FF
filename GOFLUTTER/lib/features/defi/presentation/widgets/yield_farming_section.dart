import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/stubs/stub_blocs_clean.dart'; // Use stub BLoC instead
import 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' as glass_card;
import 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart';

class YieldFarmingSection extends StatelessWidget {
  const YieldFarmingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('🌾 Yield Farming', style: WebParityTheme.panelTitleStyle),
        const SizedBox(height: 20),
        BlocBuilder<DeFiBloc, DeFiState>(
          builder: (context, state) {
            // Since we're using stub BLoC, we'll show mock data
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1.2,
              ),
              itemCount: _mockYieldFarms.length,
              itemBuilder: (context, index) {
                final farm = _mockYieldFarms[index];
                return _YieldFarmCard(farm: farm);
              },
            );
          },
        ),
      ],
    );
  }

  static final List<Map<String, dynamic>> _mockYieldFarms = [
    {
      'name': 'ATLAS/USDC LP',
      'apy': 25.5,
      'reward': 'ATLAS',
      'tvl': 1500000,
    },
    {
      'name': 'ETH/USDC LP',
      'apy': 18.2,
      'reward': 'ATLAS',
      'tvl': 2200000,
    },
    {
      'name': 'BTC/USDC LP',
      'apy': 12.8,
      'reward': 'ATLAS',
      'tvl': 3800000,
    },
    {
      'name': 'ATLAS/ETH LP',
      'apy': 32.3,
      'reward': 'ATLAS',
      'tvl': 950000,
    },
  ];
}

class _YieldFarmCard extends StatelessWidget {
  final Map<String, dynamic> farm;

  const _YieldFarmCard({required this.farm});

  @override
  Widget build(BuildContext context) {
    return glass_card.GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(farm['name'] as String, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF2D3748))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF48BB78).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text('${farm['apy']}% APY', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF48BB78))),
              ),
            ],
          ),
          const SizedBox(height: 15),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _FarmStat(label: 'Reward Token', value: farm['reward'] as String),
              _FarmStat(label: 'TVL', value: '\$${((farm['tvl'] as int) / 1000000).toStringAsFixed(1)}M'),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {}, style: WebParityTheme.primaryButtonStyle, child: const Text('Stake in Farm'))),
        ],
      ),
    );
  }
}

class _FarmStat extends StatelessWidget {
  final String label;
  final String value;

  const _FarmStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC).withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF2D3748))),
          Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF718096))),
        ],
      ),
    );
  }
}