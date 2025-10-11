
import 'package:flutter/material.dart';
import 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' as glass_card;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/stubs/stub_blocs_clean.dart';
import 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart';

class PrivacySecuritySection extends StatelessWidget {
  const PrivacySecuritySection({super.key});

  @override
  Widget build(BuildContext context) {
    return glass_card.GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🔒 Privacy & Security', style: WebParityTheme.panelTitleStyle),
            const SizedBox(height: 12),
            BlocBuilder<HealthBloc, HealthState>(
              builder: (context, state) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Encryption: 🔒 AES-256', style: TextStyle(fontSize: 14)),
                          SizedBox(height: 4),
                          Text('Key Storage: 🛡️ Hardware Secure', style: TextStyle(fontSize: 14)),
                          SizedBox(height: 4),
                          Text('Access Logs: 📋 Enabled', style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: null,
                            style: WebParityTheme.primaryButtonStyle,
                            child: const Text('🔐 Audit'),
                          ),
                          ElevatedButton(
                            onPressed: null,
                            style: WebParityTheme.warningButtonStyle,
                            child: const Text('🔄 Rotate Keys'),
                          ),
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
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(title, style: WebParityTheme.panelTitleStyle),
    );
  }
}

class _PrivacyCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final bool isFullWidth;

  const _PrivacyCard({required this.title, required this.children, this.isFullWidth = false});

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
          ...children,
        ],
      ),
    );
  }
}
