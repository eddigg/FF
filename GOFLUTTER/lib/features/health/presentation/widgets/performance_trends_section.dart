
import 'package:flutter/material.dart';
import 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' as glass_card;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/stubs/stub_blocs_clean.dart';
import 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart';

class PerformanceTrendsSection extends StatelessWidget {
  const PerformanceTrendsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return glass_card.GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📈 Performance Trends', style: WebParityTheme.panelTitleStyle),
            const SizedBox(height: 12),
            BlocBuilder<HealthBloc, HealthState>(
              builder: (context, state) {
                return Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Performance Chart Placeholder\n(📈📉📊)',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendCard extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const _TrendCard({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    Color valueBgColor;
    Color valueTextColor;
    if (value == 'increasing') {
      valueBgColor = const Color(0xFFD4EDDA);
      valueTextColor = const Color(0xFF155724);
    } else if (value == 'decreasing') {
      valueBgColor = const Color(0xFFF8D7DA);
      valueTextColor = const Color(0xFF721C24);
    } else {
      valueBgColor = const Color(0xFFD1ECF1);
      valueTextColor = const Color(0xFF0C5460);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE9ECEF)),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: valueBgColor, borderRadius: BorderRadius.circular(12)),
            child: Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: valueTextColor)),
          ),
        ],
      ),
    );
  }
}
