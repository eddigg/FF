
import 'package:flutter/material.dart';
import 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' as glass_card;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/stubs/stub_blocs_clean.dart';
import 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart';

class ShardingSection extends StatelessWidget {
  const ShardingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return glass_card.GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sharding Info', style: WebParityTheme.panelTitleStyle),
            const SizedBox(height: 12),
            BlocBuilder<NodeDashboardBloc, NodeDashboardState>(
              builder: (context, state) {
                if (state is NodeDashboardLoaded) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Shard Distribution', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF2D3748))),
                      const SizedBox(height: 8),
                      Container(
                        height: 120,
                        child: ListView(
                          children: const [
                            _ShardItem(id: '0x01', nodes: 24, status: 'Active'),
                            _ShardItem(id: '0x02', nodes: 18, status: 'Active'),
                            _ShardItem(id: '0x03', nodes: 15, status: 'Syncing'),
                          ],
                        ),
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

class _ShardItem extends StatelessWidget {
  final String id;
  final int nodes;
  final String status;

  const _ShardItem({required this.id, required this.nodes, required this.status});

  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.grey;
    if (status == 'Active') statusColor = Colors.green;
    if (status == 'Syncing') statusColor = Colors.orange;

    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Shard $id', style: const TextStyle(fontWeight: FontWeight.w600)),
          Text('$nodes nodes', style: const TextStyle(color: Color(0xFF666666))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(status, style: TextStyle(color: statusColor, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
