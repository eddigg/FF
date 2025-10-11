import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/stubs/stub_blocs_clean.dart'; // Use stub BLoC instead
import 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' as glass_card;
import 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart';

class StakingSection extends StatelessWidget {
  const StakingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('🔒 Staking', style: WebParityTheme.panelTitleStyle),
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
                childAspectRatio: 1.0, // Adjust as needed
              ),
              itemCount: _mockStakingOptions.length,
              itemBuilder: (context, index) {
                final option = _mockStakingOptions[index];
                return _StakingCard(option: option);
              },
            );
          },
        ),
      ],
    );
  }

  static final List<Map<String, dynamic>> _mockStakingOptions = [
    {
      'reward': '12.5%',
      'period': 'Annual',
      'minStake': 100,
    },
    {
      'reward': '8.0%',
      'period': '6 Months',
      'minStake': 50,
    },
    {
      'reward': '5.5%',
      'period': '3 Months',
      'minStake': 25,
    },
    {
      'reward': '3.0%',
      'period': '1 Month',
      'minStake': 10,
    },
  ];
}

class _StakingCard extends StatelessWidget {
  final Map<String, dynamic> option;

  const _StakingCard({required this.option});

  @override
  Widget build(BuildContext context) {
    return glass_card.GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(option['reward'] as String, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF48BB78))),
          const SizedBox(height: 5),
          Text(option['period'] as String, style: const TextStyle(color: Color(0xFF718096))),
          const SizedBox(height: 15),
          Text('Min: \$${option['minStake']}', style: const TextStyle(color: Color(0xFF718096))),
          const SizedBox(height: 15),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {}, style: WebParityTheme.primaryButtonStyle, child: const Text('Stake Now'))),
        ],
      ),
    );
  }
}