import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/contracts_bloc.dart';
import '../widgets/contract_deployment_section.dart';
import '../widgets/contract_examples_section.dart';
import '../widgets/contract_interaction_section.dart';
import '../widgets/deployed_contracts_section.dart';
import '../../data/repositories/contracts_repository_impl.dart';
import '../../data/data_sources/contracts_api_client.dart';
import '../../../../core/network/api_client.dart';
import '../../../../shared/themes/web_parity_theme.dart';
import '../../../../shared/widgets/web_scaffold.dart';

class ContractsPage extends StatelessWidget {
  const ContractsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create the dependencies
    final contractsApiClient = ContractsApiClient(ApiClient()); // Create a new instance
    final contractsRepository = ContractsRepositoryImpl(apiClient: contractsApiClient);

    return WebScaffold(
      title: 'Smart Contract VM',
      showBackButton: true,
      child: BlocProvider(
        create: (context) => ContractsBloc(contractsRepository: contractsRepository)..add(LoadContractsData()),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(WebParityTheme.containerPadding),
            child: Column(
              children: const [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: ContractDeploymentSection()),
                    SizedBox(width: WebParityTheme.spacingMd),
                    Expanded(child: ContractExamplesSection()),
                  ],
                ),
                SizedBox(height: WebParityTheme.spacingMd),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: ContractInteractionSection()),
                    SizedBox(width: WebParityTheme.spacingMd),
                    Expanded(child: DeployedContractsSection()),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}