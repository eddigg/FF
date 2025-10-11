import 'package:flutter/material.dart';
import 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' as glass_card;
import 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart';

class ContractInteractionSection extends StatelessWidget {
  const ContractInteractionSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Controllers would be in a StatefulWidget
    final addressController = TextEditingController();
    final callerController = TextEditingController();
    final gasController = TextEditingController(text: '1000');

    return glass_card.GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _PanelTitle(title: '⚡ Contract Interaction'),
          _buildTextField(label: 'Contract Address:', controller: addressController),
          ElevatedButton(
            onPressed: () {
              // For stub implementation, we just show a snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Loading contract info...')),
              );
            }, 
            style: WebParityTheme.secondaryButtonStyle, 
            child: const Text('Load Contract Info')
          ),
          const SizedBox(height: 16),
          _buildTextField(label: 'Caller Address:', controller: callerController),
          _buildTextField(label: 'Gas Limit:', controller: gasController, isNumeric: true),
          const SizedBox(height: 16),
          const Text('Available Functions:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          // TODO: Dynamically build function call widgets based on loaded contract info
        ],
      ),
    );
  }

  Widget _buildTextField({required String label, required TextEditingController controller, bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF4A5568))),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
            decoration: WebParityTheme.inputDecoration(''),
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