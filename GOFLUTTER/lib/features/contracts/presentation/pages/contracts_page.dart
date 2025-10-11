import 'package:flutter/material.dart';
import 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' as glass_card;
import '../widgets/contract_deployment_section.dart';
import '../widgets/contract_examples_section.dart';
import '../widgets/contract_interaction_section.dart';
import '../widgets/deployed_contracts_section.dart';
import '../../../../shared/themes/web_parity_theme.dart';
import '../../../../shared/widgets/web_scaffold.dart';

class ContractsPage extends StatelessWidget {
  const ContractsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WebScaffold(
      title: 'Smart Contract VM',
      showBackButton: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(WebParityTheme.containerPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Smart Contract Virtual Machine',
                style: WebParityTheme.panelTitleStyle,
              ),
              const SizedBox(height: WebParityTheme.spacingLg),
              const Text(
                'Deploy, interact, and manage smart contracts on the Atlas Blockchain.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: WebParityTheme.spacingLg * 2),
              const ContractDeploymentSection(),
              const SizedBox(height: WebParityTheme.spacingLg),
              const ContractExamplesSection(),
              const SizedBox(height: WebParityTheme.spacingLg),
              const ContractInteractionSection(),
              const SizedBox(height: WebParityTheme.spacingLg),
              const DeployedContractsSection(),
            ],
          ),
        ),
      ),
    );
  }
}