import 'package:flutter/material.dart';
import 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' as glass_card;
import 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart';

class DeployedContractsSection extends StatelessWidget {
  const DeployedContractsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return glass_card.GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _PanelTitle(title: '📋 Deployed Contracts'),
          ElevatedButton(
            onPressed: () {
              // For stub implementation, we just show a snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Refreshing contracts...')),
              );
            }, 
            style: WebParityTheme.secondaryButtonStyle, 
            child: const Text('Refresh Contracts')
          ),
          const SizedBox(height: 16),
          // Show mock deployed contracts
          SizedBox(
            height: 300,
            child: _buildMockContractsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMockContractsList() {
    final mockContracts = [
      {
        'name': 'SimpleToken',
        'address': '0x742d35Cc6634C0532925a3b8D4C0532925a3b8D4',
      },
      {
        'name': 'VotingSystem',
        'address': '0x8ba1f109551bD432803012645Hac136c22C177e9',
      },
      {
        'name': 'EscrowService',
        'address': '0x9d3a7d8a3b8c4d7e8f9a0b1c2d3e4f5a6b7c8d9e',
      },
    ];

    return ListView.builder(
      itemCount: mockContracts.length,
      itemBuilder: (context, index) {
        final contract = mockContracts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            title: Text(contract['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(contract['address'] as String, style: const TextStyle(fontFamily: 'Courier New', fontSize: 12)),
            onTap: () {
              // For stub implementation, we just show a snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Loading info for ${contract['name']}...')),
              );
            },
          ),
        );
      },
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