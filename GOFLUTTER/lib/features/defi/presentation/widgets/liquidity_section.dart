import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/stubs/stub_blocs_clean.dart'; // Use stub BLoC instead
import 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' as glass_card;
import 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart';

class LiquiditySection extends StatelessWidget {
  const LiquiditySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('💧 Liquidity Pools', style: WebParityTheme.panelTitleStyle),
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
              itemCount: _mockLiquidityPools.length,
              itemBuilder: (context, index) {
                final pool = _mockLiquidityPools[index];
                return _LiquidityPoolCard(pool: pool);
              },
            );
          },
        ),
      ],
    );
  }

  static final List<Map<String, dynamic>> _mockLiquidityPools = [
    {
      'name': 'ATLAS/USDC',
      'apy': 12.5,
      'tvl': 2500000,
      'yourShare': 1250,
    },
    {
      'name': 'ETH/USDC',
      'apy': 8.2,
      'tvl': 1800000,
      'yourShare': 0,
    },
    {
      'name': 'BTC/USDC',
      'apy': 6.8,
      'tvl': 3200000,
      'yourShare': 500,
    },
    {
      'name': 'ATLAS/ETH',
      'apy': 15.3,
      'tvl': 950000,
      'yourShare': 0,
    },
  ];
}

class _LiquidityPoolCard extends StatelessWidget {
  final Map<String, dynamic> pool;

  const _LiquidityPoolCard({required this.pool});

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
              Text(pool['name'] as String, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF2D3748))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF48BB78).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text('${pool['apy']}% APY', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF48BB78))),
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
              _PoolStat(label: 'TVL', value: '\$${((pool['tvl'] as int) / 1000000).toStringAsFixed(1)}M'),
              _PoolStat(label: 'Your Share', value: '\$${pool['yourShare']}'),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {}, style: WebParityTheme.primaryButtonStyle, child: const Text('Add Liquidity'))),
        ],
      ),
    );
  }
}

class _PoolStat extends StatelessWidget {
  final String label;
  final String value;

  const _PoolStat({required this.label, required this.value});

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