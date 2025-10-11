import 'package:flutter/material.dart';
import 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart'
    as glass_card;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/stubs/stub_blocs_clean.dart';
import 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart';

class NetworkOverview extends StatelessWidget {
  const NetworkOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return glass_card.GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Network Overview', style: WebParityTheme.panelTitleStyle),
            const SizedBox(height: 12),
            BlocBuilder<NodeDashboardBloc, NodeDashboardState>(
              builder: (context, state) {
                if (state is NodeDashboardLoaded) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Active Validators',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 120,
                        child: ListView.builder(
                          itemCount: state.validators.length,
                          itemBuilder: (context, index) {
                            final validator = state.validators[index];
                            return _ValidatorItem(validator: validator);
                          },
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Network Stats',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _NetworkStatItem(
                        label: 'Total Validators',
                        value: state.networkStats['totalValidators'].toString(),
                      ),
                      _NetworkStatItem(
                        label: 'Network Hash Rate',
                        value: state.networkStats['networkHashRate'],
                      ),
                      _NetworkStatItem(
                        label: 'Average Block Time',
                        value: state.networkStats['avgBlockTime'],
                      ),
                      _NetworkStatItem(
                        label: 'Network Difficulty',
                        value: state.networkStats['networkDifficulty'],
                      ),
                    ],
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ValidatorItem extends StatelessWidget {
  final dynamic validator; // Replace with ValidatorModel

  const _ValidatorItem({required this.validator});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            validator.address.substring(0, 20) + '...',
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              color: Color(0xFF666666),
            ),
          ),
          Text(
            'Stake: ${validator.stake}',
            style: const TextStyle(
              color: Color(0xFF27AE60),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          Text(
            validator.isActive ? '🟢 Active' : '🔴 Inactive',
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _NetworkStatItem extends StatelessWidget {
  final String label;
  final String value;

  const _NetworkStatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
        ],
      ),
    );
  }
}
