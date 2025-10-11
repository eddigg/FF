import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/stubs/stub_blocs_clean.dart'; // Use stub BLoC instead
import 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' as glass_card;
import 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart';

class PortfolioSection extends StatelessWidget {
  const PortfolioSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('📊 Portfolio Overview', style: WebParityTheme.panelTitleStyle),
        const SizedBox(height: 20),
        BlocBuilder<DeFiBloc, DeFiState>(
          builder: (context, state) {
            // Since we're using stub BLoC, we'll show mock data
            return Column(
              children: [
                glass_card.GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Your Assets', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 15),
                      ..._buildMockAssets(),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                glass_card.GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Recent Transactions', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 15),
                      const Text('No recent transactions', style: TextStyle(color: Color(0xFF718096), fontStyle: FontStyle.italic)),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  List<Widget> _buildMockAssets() {
    final mockAssets = [
      {'symbol': 'ATLAS', 'amount': 1250.50, 'value': 25010.00, 'change': 5.2},
      {'symbol': 'ETH', 'amount': 2.35, 'value': 6845.00, 'change': -2.1},
      {'symbol': 'BTC', 'amount': 0.125, 'value': 4500.00, 'change': 3.7},
    ];

    return mockAssets.map<Widget>((asset) {
      final double change = asset['change'] as double;
      final isNegativeChange = change < 0;
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(asset['symbol']! as String, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF2D3748))),
                const SizedBox(width: 10),
                Text((asset['amount'] as double).toStringAsFixed(2), style: const TextStyle(fontSize: 16, color: Color(0xFF4A5568))),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('\$${(asset['value'] as double).toStringAsFixed(2)}', style: const TextStyle(color: Color(0xFF48BB78), fontWeight: FontWeight.w600)),
                Text(
                  '${isNegativeChange ? '' : '+'}${change.toStringAsFixed(2)}%',
                  style: TextStyle(fontSize: 14, color: isNegativeChange ? Colors.red[600] : const Color(0xFF48BB78)),
                ),
              ],
            ),
          ],
        ),
      );
    }).toList();
  }
}