import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/governance_bloc.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/common_widgets.dart';

class GovernanceOverview extends StatelessWidget {
  const GovernanceOverview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('🏛️ Governance Overview', style: AppTextStyles.h4),
            const SizedBox(height: AppSpacing.md),
            const Text('📊 Governance Statistics', style: AppTextStyles.h5),
            const SizedBox(height: AppSpacing.sm),
            BlocBuilder<GovernanceBloc, dynamic>(
              builder: (context, state) {
                if (state is GovernanceLoaded) {
                  return Column(
                    children: [
                      _buildStatItem('Active Proposals', state.governanceStats.activeProposals.toString()),
                      _buildStatItem('Total Voters', state.governanceStats.totalVoters.toString()),
                      _buildStatItem('Voting Power', state.governanceStats.totalVotingPower.toString()),
                      _buildStatItem('Quorum Required', state.governanceStats.quorumRequired.toString()),
                      const SizedBox(height: AppSpacing.sm),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GradientButton(
                          text: '🔄 Refresh Stats',
                          onPressed: () {
                            context.read<GovernanceBloc>().add(LoadGovernanceData());
                          },
                          gradient: AppColors.primaryGradient,
                          width: 120,
                        ),
                      ),
                    ],
                  );
                } else if (state is GovernanceLoading) {
                  return const CircularProgressIndicator();
                } else {
                  return const Text('Error loading stats');
                }
              },
            ),
            const SizedBox(height: AppSpacing.md),
            const Text('⚙️ Governance Parameters', style: AppTextStyles.h5),
            const SizedBox(height: AppSpacing.sm),
            BlocBuilder<GovernanceBloc, dynamic>(
              builder: (context, state) {
                if (state is GovernanceLoaded) {
                  return Column(
                    children: [
                      _buildStatItem('Min Proposal Duration', state.governanceParams.minDuration.toString()),
                      _buildStatItem('Max Proposal Duration', state.governanceParams.maxDuration.toString()),
                      _buildStatItem('Min Stake to Propose', state.governanceParams.minStake.toString()),
                      _buildStatItem('Voting Threshold', state.governanceParams.votingThreshold.toString()),
                      const SizedBox(height: AppSpacing.sm),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GradientButton(
                          text: '⚙️ Load Parameters',
                          onPressed: () {
                            context.read<GovernanceBloc>().add(LoadGovernanceData());
                          },
                          gradient: AppColors.primaryGradient,
                          width: 150,
                        ),
                      ),
                    ],
                  );
                } else if (state is GovernanceLoading) {
                  return const CircularProgressIndicator();
                } else {
                  return const Text('Error loading parameters');
                }
              },
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