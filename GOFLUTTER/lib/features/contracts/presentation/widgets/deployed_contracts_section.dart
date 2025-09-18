import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/contracts_bloc.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/common_widgets.dart';
import '../../../../shared/widgets/custom_widgets.dart';

class DeployedContractsSection extends StatelessWidget {
  const DeployedContractsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EnhancedGlassCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Deployed Contracts', style: AppTextStyles.h4),
            const SizedBox(height: AppSpacing.md),
            GradientButton(
              text: 'Refresh Contracts',
              onPressed: () {
                context.read<ContractsBloc>().add(LoadContractsData());
              },
              gradient: AppColors.secondaryGradient,
            ),
            const SizedBox(height: AppSpacing.md),
            BlocBuilder<ContractsBloc, ContractsState>(
              builder: (context, state) {
                if (state is ContractsLoaded) {
                  if (state.deployedContracts.isEmpty) {
                    return const Text('No contracts deployed yet. Deploy your first contract above!');
                  }
                  
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.deployedContracts.length,
                    itemBuilder: (context, index) {
                      final contract = state.deployedContracts[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: EnhancedGlassCard(
                          child: ListTile(
                            title: Text(contract.name, style: AppTextStyles.h5),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Address: ${contract.address}', style: AppTextStyles.body2),
                                Text('Owner: ${contract.owner}', style: AppTextStyles.body2),
                                Text('Version: ${contract.version}', style: AppTextStyles.body2),
                                Text('Created: ${contract.createdAt.toString()}', style: AppTextStyles.caption),
                              ],
                            ),
                            onTap: () {
                              // Load contract info into interaction section
                              context.read<ContractsBloc>().add(LoadContractInfo(address: contract.address));
                              
                              // Also set the contract address in the interaction section
                              // This requires accessing the ContractInteractionSection state
                              // We'll use a different approach by sending an event
                            },
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is ContractsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return const Text('Error loading contracts');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}