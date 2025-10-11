import 'package:flutter/material.dart';
import 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' as glass_card;
import 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart';

class ContractExamplesSection extends StatelessWidget {
  const ContractExamplesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return glass_card.GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _PanelTitle(title: '📚 Contract Examples'),
          _ExampleCard(
            title: '🪙 Simple Token',
            description: 'A basic token contract with transfer and balance functions',
            onTap: () {
              // For stub implementation, we just show a snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Loading Simple Token example...')),
              );
            },
          ),
          _ExampleCard(
            title: '🗳️ Voting System',
            description: 'A simple voting contract for proposals',
            onTap: () {
              // For stub implementation, we just show a snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Loading Voting System example...')),
              );
            },
          ),
          _ExampleCard(
            title: '🔒 Escrow Service',
            description: 'An escrow contract for secure transactions',
            onTap: () {
              // For stub implementation, we just show a snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Loading Escrow Service example...')),
              );
            },
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

class _ExampleCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onTap;

  const _ExampleCard({required this.title, required this.description, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2D3748))),
              const SizedBox(height: 8),
              Text(description, style: const TextStyle(color: Color(0xFF718096), fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}