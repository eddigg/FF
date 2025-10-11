import 'package:flutter/material.dart';
import 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' as glass_card;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/stubs/stub_blocs_clean.dart';
import 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart';

class HealthChecksSection extends StatelessWidget {
  const HealthChecksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return glass_card.GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🏥 Health Checks', style: WebParityTheme.panelTitleStyle),
            const SizedBox(height: 12),
            BlocBuilder<HealthBloc, HealthState>(
              builder: (context, state) {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 2.5,
                  ),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    final checks = [
                      {'name': 'API Server', 'status': '🟢'},
                      {'name': 'Database', 'status': '🟢'},
                      {'name': 'Network', 'status': '🟢'},
                      {'name': 'Storage', 'status': '🟡'},
                    ];
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(checks[index]['status']!, style: const TextStyle(fontSize: 16)),
                          const SizedBox(height: 4),
                          Text(checks[index]['name']!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}