import 'package:flutter/material.dart';
import 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' as glass_card;
import 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart';

class ContractDeploymentSection extends StatelessWidget {
  const ContractDeploymentSection({super.key});

  @override
  Widget build(BuildContext context) {
    // In a real implementation, controllers would be managed in a StatefulWidget
    final nameController = TextEditingController(text: 'MyAwesomeContract');
    final versionController = TextEditingController(text: '1.0');
    final ownerController = TextEditingController(text: '0x1234567890abcdef');
    final codeController = TextEditingController();

    return glass_card.GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _PanelTitle(title: '🚀 Deploy New Contract'),
          _buildTextField(label: 'Contract Name:', controller: nameController),
          _buildTextField(label: 'Version:', controller: versionController),
          _buildTextField(label: 'Owner Address:', controller: ownerController),
          _buildTextField(label: 'Contract Code (JSON):', controller: codeController, maxLines: 8),
          const SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton(onPressed: () {}, style: WebParityTheme.primaryButtonStyle, child: const Text('Deploy Contract')),
              const SizedBox(width: 10),
              ElevatedButton(onPressed: () {}, style: WebParityTheme.secondaryButtonStyle, child: const Text('Load Example')), // This button is illustrative
            ],
          ),
          // TODO: Add deployment status widget
        ],
      ),
    );
  }

  Widget _buildTextField({required String label, required TextEditingController controller, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF4A5568))),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            decoration: WebParityTheme.inputDecoration(''),
            style: maxLines > 1 ? const TextStyle(fontFamily: 'Courier New', fontSize: 12) : null,
          ),
        ],
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