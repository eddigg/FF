import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/stubs/stub_blocs_clean.dart'; // Use stub BLoC instead
import 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' as glass_card;
import 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart';

class TradingSection extends StatelessWidget {
  const TradingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('📈 DEX Trading', style: WebParityTheme.panelTitleStyle),
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
                      Text('Available Trading Pairs', style: WebParityTheme.cardTitleStyle),
                      const SizedBox(height: 15),
                      ..._mockTradingPairs.map<Widget>((pair) => _TradingPairItem(pair: pair)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                glass_card.GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Quick Trade', style: WebParityTheme.cardTitleStyle),
                      const SizedBox(height: 15),
                      _buildTradeForm(),
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

  static final List<Map<String, dynamic>> _mockTradingPairs = [
    {
      'symbol': 'ATLAS/USDC',
      'price': 20.0,
      'change': 2.5,
    },
    {
      'symbol': 'ETH/USDC',
      'price': 2920.50,
      'change': -1.2,
    },
    {
      'symbol': 'BTC/USDC',
      'price': 36000.0,
      'change': 0.8,
    },
    {
      'symbol': 'ATLAS/ETH',
      'price': 0.0068,
      'change': 3.7,
    },
  ];

  Widget _buildTradeForm() {
    return Column(
      children: [
        _buildDropdownField(label: 'From Token', options: const ['ATLAS', 'ETH', 'USDC'], selected: 'ATLAS'),
        _buildTextField(label: 'Amount', placeholder: '0.0', isNumeric: true),
        _buildDropdownField(label: 'To Token', options: const ['USDC', 'ATLAS', 'ETH'], selected: 'USDC'),
        const SizedBox(height: 15),
        SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {}, style: WebParityTheme.primaryButtonStyle, child: const Text('Trade'))),
      ],
    );
  }

  Widget _buildDropdownField({required String label, required List<String> options, required String selected}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF4A5568))),
          const SizedBox(height: 5),
          DropdownButtonFormField<String>(
            initialValue: selected,
            items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (value) {},
            decoration: WebParityTheme.inputDecoration(''),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({required String label, String placeholder = '', bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF4A5568))),
          const SizedBox(height: 5),
          TextFormField(
            keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
            decoration: WebParityTheme.inputDecoration(placeholder),
          ),
        ],
      ),
    );
  }
}

class _TradingPairItem extends StatelessWidget {
  final Map<String, dynamic> pair;

  const _TradingPairItem({required this.pair});

  @override
  Widget build(BuildContext context) {
    final double change = pair['change'] as double;
    final isNegativeChange = change < 0;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(pair['symbol'] as String, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF2D3748))),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('\$${(pair['price'] as double).toStringAsFixed(2)}', style: const TextStyle(color: Color(0xFF48BB78), fontWeight: FontWeight.w600)),
              Text(
                '${isNegativeChange ? '' : '+'}${change.toStringAsFixed(2)}%',
                style: TextStyle(fontSize: 14, color: isNegativeChange ? Colors.red[600] : const Color(0xFF48BB78)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}