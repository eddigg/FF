import 'package:flutter/material.dart';
import 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' as glass_card;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/stubs/stub_blocs_clean.dart';
import 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart';

class NodeControlsSection extends StatelessWidget {
  const NodeControlsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return glass_card.GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Node Controls', style: WebParityTheme.panelTitleStyle),
            const SizedBox(height: 12),
            BlocBuilder<NodeDashboardBloc, NodeDashboardState>(
              builder: (context, state) {
                if (state is NodeDashboardLoaded) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Node Management', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF2D3748))),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          ElevatedButton(onPressed: () {}, style: WebParityTheme.primaryButtonStyle, child: const Text('▶️ Start')),
                          ElevatedButton(onPressed: () {}, style: WebParityTheme.warningButtonStyle, child: const Text('⏸️ Pause')),
                          ElevatedButton(onPressed: () {}, style: WebParityTheme.dangerButtonStyle, child: const Text('⏹️ Stop')),
                          ElevatedButton(onPressed: () {}, style: WebParityTheme.successButtonStyle, child: const Text('🔄 Sync')),
                        ],
                      ),
                      const SizedBox(height: 15),
                      const Text('Validator Management', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF2D3748))),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          ElevatedButton(onPressed: () {}, style: WebParityTheme.warningButtonStyle, child: const Text('⚖️ Stake')),
                          ElevatedButton(onPressed: () {}, style: WebParityTheme.successButtonStyle, child: const Text('📊 Export')),
                        ],
                      ),
                      const SizedBox(height: 15),
                      const Text('Node Logs', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF2D3748))),
                      const SizedBox(height: 8),
                      Container(
                        height: 150,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2C3E50),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListView(
                          children: const [
                            Text('[INFO] Network dashboard initialized', style: TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'monospace')),
                            Text('[INFO] Connecting to blockchain network...', style: TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'monospace')),
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