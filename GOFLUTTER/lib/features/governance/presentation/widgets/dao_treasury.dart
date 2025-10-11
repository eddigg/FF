
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/stubs/stub_blocs_clean.dart';
import 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart';
import '../../../../shared/widgets/common_widgets.dart' as glass_card;

class DAOTreasury extends StatelessWidget {
  const DAOTreasury({super.key});

  @override
  Widget build(BuildContext context) {
    return glass_card.GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('💰 DAO Treasury', style: WebParityTheme.panelTitleStyle),
            const SizedBox(height: 12),
            BlocBuilder<GovernanceBloc, GovernanceState>(
              builder: (context, state) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFF1C40F), Color(0xFFF39C12)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Column(
                        children: [
                          Text(
                            '12,548.75',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'ATLAS Tokens',
                            style: TextStyle(fontSize: 14, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Treasury Info',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                      ),
                    ),
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
                          Text('Managed By: DAO Treasury Contract', style: TextStyle(fontSize: 14)),
                          SizedBox(height: 4),
                          Text('Last Distribution: 5 days ago', style: TextStyle(fontSize: 14)),
                          SizedBox(height: 4),
                          Text('Next Distribution: In 9 days', style: TextStyle(fontSize: 14)),
                        ],
                      ),
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
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Text(title, style: WebParityTheme.panelTitleStyle),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final Map<String, String>? stats;
  final VoidCallback? onRefresh;
  final String? buttonText;
  final Widget? child;

  const _InfoCard({required this.title, this.stats, this.onRefresh, this.buttonText, this.child});

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
          Text(title, style: const TextStyle(color: Color(0xFF1E3C72), fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          if (stats != null)
            ...stats!.entries.map((e) => _StatItem(label: e.key, value: e.value)),
          if (child != null) child!,
          if (onRefresh != null && buttonText != null)
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: onRefresh, style: WebParityTheme.primaryButtonStyle, child: Text(buttonText!)),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF28A745))),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const _ActionButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(onPressed: onPressed, style: WebParityTheme.primaryButtonStyle.copyWith(padding: MaterialStateProperty.all(const EdgeInsets.all(8))), child: Text(text, style: const TextStyle(fontSize: 13))),
      ),
    );
  }
}
