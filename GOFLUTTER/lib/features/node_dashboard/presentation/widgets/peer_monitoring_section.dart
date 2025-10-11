import 'package:flutter/material.dart';
import 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' as glass_card;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/stubs/stub_blocs_clean.dart';
import 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart';

class PeerMonitoringSection extends StatelessWidget {
  const PeerMonitoringSection({super.key});

  @override
  Widget build(BuildContext context) {
    return glass_card.GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Peer Monitoring', style: WebParityTheme.panelTitleStyle),
            const SizedBox(height: 12),
            BlocBuilder<NodeDashboardBloc, NodeDashboardState>(
              builder: (context, state) {
                if (state is NodeDashboardLoaded) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Connected Peers', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF2D3748))),
                      const SizedBox(height: 8),
                      Container(
                        height: 150,
                        child: ListView.builder(
                          itemCount: state.validators.length,
                          itemBuilder: (context, index) {
                            final peer = state.validators[index];
                            return _PeerItem(peer: peer);
                          },
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text('Peer Management', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF2D3748))),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          ElevatedButton(onPressed: () {}, style: WebParityTheme.primaryButtonStyle, child: const Text('Add Peer')),
                          ElevatedButton(onPressed: () {}, style: WebParityTheme.secondaryButtonStyle, child: const Text('Remove Peer')),
                          ElevatedButton(onPressed: () {}, style: WebParityTheme.dangerButtonStyle, child: const Text('Ban Peer')),
                          ElevatedButton(onPressed: () {}, style: WebParityTheme.primaryButtonStyle, child: const Text('Refresh Peers')),
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

class _PeerItem extends StatelessWidget {
  final dynamic peer; // Replace with PeerModel

  const _PeerItem({required this.peer});

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
          Text(peer['address'].toString(), style: const TextStyle(fontFamily: 'monospace', fontSize: 13, color: Color(0xFF666666))),
          Text('Stake: ${peer['stake']}', style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}