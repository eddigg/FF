import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/stubs/stub_blocs_clean.dart'; // Use stub BLoC instead
import 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' as glass_card;
import 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart';

class LendingSection extends StatelessWidget {
  const LendingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('💰 Lending & Borrowing', style: WebParityTheme.panelTitleStyle),
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
              itemCount: _mockLendingPools.length,
              itemBuilder: (context, index) {
                final pool = _mockLendingPools[index];
                return _LendingPoolCard(pool: pool);
              },
            );
          },
        ),
      ],
    );
  }

  static final List<Map<String, dynamic>> _mockLendingPools = [
    {
      'name': 'ATLAS',
      'supplyAPY': 8.5,
      'borrowAPY': 12.3,
      'totalSupply': 15000000,
      'utilization': 65,
    },
    {
      'name': 'ETH',
      'supplyAPY': 8.5,
      'borrowAPY': 12.3,
      'totalSupply': 15000000,
      'utilization': 65,
    },
    {
      'name': 'BTC',
      'supplyAPY': 4.2,
      'borrowAPY': 6.8,
      'totalSupply': 8500000,
      'utilization': 42,
    },
    {
      'name': 'USDC',
      'supplyAPY': 6.8,
      'borrowAPY': 9.5,
      'totalSupply': 22000000,
      'utilization': 78,
    },
  ];
}

class _LendingPoolCard extends StatelessWidget {
  final Map<String, dynamic> pool;

  const _LendingPoolCard({required this.pool});

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
                child: Text('${pool['supplyAPY']}% APY', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF48BB78))),
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
              _PoolStat(label: 'Supply APY', value: '${pool['supplyAPY']}%'),
              _PoolStat(label: 'Borrow APY', value: '${pool['borrowAPY']}%'),
              _PoolStat(label: 'Total Supply', value: '\$${(pool['totalSupply'] / 1000000).toStringAsFixed(1)}M'),
              _PoolStat(label: 'Utilization', value: '${pool['utilization']}%'),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(child: ElevatedButton(onPressed: () {}, style: WebParityTheme.primaryButtonStyle, child: const Text('Supply'))),
              const SizedBox(width: 10),
              Expanded(child: ElevatedButton(onPressed: () {}, style: WebParityTheme.secondaryButtonStyle, child: const Text('Borrow'))),
            ],
          ),
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