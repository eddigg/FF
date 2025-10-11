import 'package:flutter/material.dart';
import 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' as glass_card;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/stubs/stub_blocs_clean.dart';
import 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart';

class ShardingManagementSection extends StatelessWidget {
  const ShardingManagementSection({super.key});

  @override
  Widget build(BuildContext context) {
    return glass_card.GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sharding Management', style: WebParityTheme.panelTitleStyle),
            const SizedBox(height: 12),
            BlocBuilder<NodeDashboardBloc, NodeDashboardState>(
              builder: (context, state) {
                if (state is NodeDashboardLoaded) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Shard Configuration', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF2D3748))),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Shard ID: 0x01', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                            SizedBox(height: 4),
                            Text('Nodes in Shard: 24', style: TextStyle(fontSize: 14)),
                            SizedBox(height: 4),
                            Text('Shard Status: Active', style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text('Shard Operations', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF2D3748))),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          ElevatedButton(onPressed: () {}, style: WebParityTheme.primaryButtonStyle, child: const Text('🔄 Rebalance')),
                          ElevatedButton(onPressed: () {}, style: WebParityTheme.warningButtonStyle, child: const Text('⚙️ Configure')),
                          ElevatedButton(onPressed: () {}, style: WebParityTheme.dangerButtonStyle, child: const Text('⏹️ Stop Shard')),
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

class _ShardCard extends StatelessWidget {
  final String title;
  final String? content;
  final Widget? child;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const _ShardCard({
    required this.title,
    this.content,
    this.child,
    this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE9ECEF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF1E3C72),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          if (content != null)
            Text(
              content!,
              style: const TextStyle(fontSize: 14, color: Color(0xFF4A5568)),
            ),
          if (child != null) child!,
          if (buttonText != null && onButtonPressed != null)
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onButtonPressed,
                  style: WebParityTheme.primaryButtonStyle,
                  child: Text(buttonText!),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
