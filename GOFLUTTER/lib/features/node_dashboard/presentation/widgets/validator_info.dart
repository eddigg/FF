import 'package:flutter/material.dart';
import 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart'
    as glass_card;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/stubs/stub_blocs_clean.dart';
import 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart';

class ValidatorInfo extends StatelessWidget {
  const ValidatorInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return glass_card.GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Validator Info', style: WebParityTheme.panelTitleStyle),
            const SizedBox(height: 12),
            BlocBuilder<NodeDashboardBloc, NodeDashboardState>(
              builder: (context, state) {
                if (state is NodeDashboardLoaded) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _StakedTokensCard(
                        stake: state.validatorInfo['stake'].toString(),
                      ),
                      const SizedBox(height: 12),
                      _ValidatorStatusCard(
                        status: state.validatorInfo['status'] ?? 'Unknown',
                        address: state.validatorInfo['address'] ?? 'Unknown',
                      ),
                      const SizedBox(height: 12),
                      GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _InfoItem(
                            label: 'Validator Rank',
                            value:
                                state.validatorInfo['rank']?.toString() ?? '0',
                          ),
                          _InfoItem(
                            label: 'Node Mode',
                            value: state.validatorInfo['nodeMode'] ?? 'Unknown',
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Quick Actions',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: WebParityTheme.warningButtonStyle.copyWith(
                                padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 5,
                                  ),
                                ),
                                textStyle: MaterialStateProperty.all(
                                  const TextStyle(fontSize: 13),
                                ),
                              ),
                              child: const Text('⚖️ Stake'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: WebParityTheme.successButtonStyle.copyWith(
                                padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 5,
                                  ),
                                ),
                                textStyle: MaterialStateProperty.all(
                                  const TextStyle(fontSize: 13),
                                ),
                              ),
                              child: const Text('📊 Export'),
                            ),
                          ),
                        ],
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

class _StakedTokensCard extends StatelessWidget {
  final String stake;

  const _StakedTokensCard({required this.stake});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF1C40F), Color(0xFFF39C12)],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            stake,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const Text(
            'Staked Tokens',
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _ValidatorStatusCard extends StatelessWidget {
  final String status;
  final String address;

  const _ValidatorStatusCard({required this.status, required this.address});

  @override
  Widget build(BuildContext context) {
    Color indicatorColor = Colors.grey;
    String statusText = 'Checking...';
    if (status == 'Active Validator') {
      indicatorColor = const Color(0xFF27AE60);
      statusText = 'Active Validator';
    } else if (status == 'Not a Validator') {
      indicatorColor = const Color(0xFFE74C3C);
      statusText = 'Not a Validator';
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Validator Status',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: indicatorColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                statusText,
                style: TextStyle(fontSize: 13, color: indicatorColor),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Address: ${address.substring(0, 16)}...',
            style: const TextStyle(fontSize: 13, color: Color(0xFF666666)),
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _InfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF718096)),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
        ],
      ),
    );
  }
}
