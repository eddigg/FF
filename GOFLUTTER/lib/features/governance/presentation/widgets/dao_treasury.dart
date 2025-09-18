import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/governance_bloc.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/common_widgets.dart';

class DAOTreasury extends StatelessWidget {
  const DAOTreasury({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('💰 DAO Treasury', style: AppTextStyles.h4),
            const SizedBox(height: AppSpacing.md),
            BlocBuilder<GovernanceBloc, dynamic>(
              builder: (context, state) {
                if (state is GovernanceLoaded) {
                  return Column(
                    children: [
                      _buildStatItem('Total Balance', '${state.treasuryInfo.balance} ATLAS'),
                      _buildStatItem('Pending Proposals', state.treasuryInfo.pendingProposals.toString()),
                      _buildStatItem('Executed This Month', state.treasuryInfo.executedThisMonth.toString()),
                      const SizedBox(height: AppSpacing.sm),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GradientButton(
                          text: '💰 Load Treasury',
                          onPressed: () {
                            context.read<GovernanceBloc>().add(LoadGovernanceData());
                          },
                          gradient: AppColors.primaryGradient,
                          width: 130,
                        ),
                      ),
                    ],
                  );
                } else if (state is GovernanceLoading) {
                  return const CircularProgressIndicator();
                } else {
                  return const Text('Error loading treasury info');
                }
              },
            ),
            const SizedBox(height: AppSpacing.md),
            const Text('🎯 Treasury Actions', style: AppTextStyles.h5),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                GradientButton(
                  text: '💸 Transfer Funds',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Treasury transfer functionality coming soon')),
                    );
                  },
                  width: 140,
                ),
                GradientButton(
                  text: '📊 Allocate Budget',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Treasury allocation functionality coming soon')),
                    );
                  },
                  width: 140,
                ),
                GradientButton(
                  text: '📋 Generate Report',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Treasury report functionality coming soon')),
                    );
                  },
                  width: 140,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.body2),
          Text(value, style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}