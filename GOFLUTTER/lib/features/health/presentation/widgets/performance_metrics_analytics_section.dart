
import 'package:flutter/material.dart';
import 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' as glass_card;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/stubs/stub_blocs_clean.dart';
import 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart';

class PerformanceMetricsAnalyticsSection extends StatelessWidget {
  const PerformanceMetricsAnalyticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return glass_card.GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📈 Performance Metrics & Analytics', style: WebParityTheme.panelTitleStyle),
            const SizedBox(height: 12),
            BlocBuilder<HealthBloc, HealthState>(
              builder: (context, state) {
                return Column(
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        final metrics = [
                          {'name': 'CPU Usage', 'value': '42%', 'change': '↓ 2%'},
                          {'name': 'Memory', 'value': '6.2GB', 'change': '↑ 1.2GB'},
                          {'name': 'Network', 'value': '1.2Gbps', 'change': '→ 0.1Gbps'},
                          {'name': 'Disk I/O', 'value': '45MB/s', 'change': '↓ 3MB/s'},
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
                              Text(
                                metrics[index]['value']!,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                metrics[index]['name']!,
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                metrics[index]['change']!,
                                style: const TextStyle(fontSize: 12, color: Color(0xFF718096)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PanelTitle extends StatelessWidget {
  final String title;
  const _PanelTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(title, style: WebParityTheme.panelTitleStyle),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const _MetricCard({required this.label, required this.value, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE9ECEF)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('$value$unit', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF4299E1))),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 14, color: Color(0xFF6C757D))),
        ],
      ),
    );
  }
}

class _ChartContainer extends StatelessWidget {
  final String title;
  final String chartType;

  const _ChartContainer({required this.title, required this.chartType});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE9ECEF)),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D3748))),
          const SizedBox(height: 10),
          Expanded(
            child: Center(
              child: Text('${chartType.toUpperCase()} Chart Placeholder', style: const TextStyle(color: Color(0xFF6C757D), fontStyle: FontStyle.italic)),
            ), // Replace with actual chart widget
          ),
        ],
      ),
    );
  }
}
