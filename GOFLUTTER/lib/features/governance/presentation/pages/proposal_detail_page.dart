import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/glass_card.dart' as glass_card;
import '../../../../shared/widgets/common_widgets.dart';
import '../../data/models/proposal_model.dart';
import '../bloc/governance_bloc.dart';
import '../../data/repositories/governance_repository.dart';

class ProposalDetailPage extends StatelessWidget {
  final String proposalId;

  const ProposalDetailPage({Key? key, required this.proposalId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GovernanceBloc(governanceRepository: context.read<GovernanceRepository>())
        ..add(LoadGovernanceData()), // For now, just load all data
      child: ProposalDetailView(proposalId: proposalId),
    );
  }
}

class ProposalDetailView extends StatelessWidget {
  final String proposalId;

  const ProposalDetailView({Key? key, required this.proposalId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.containerPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: BlocBuilder<GovernanceBloc, dynamic>(
                  builder: (context, state) {
                    if (state is GovernanceLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is GovernanceLoaded) {
                      // Find the proposal by ID
                      final proposal = state.proposals.firstWhere(
                        (p) => p.id == proposalId,
                        orElse: () => ProposalModel(
                          id: proposalId,
                          description: 'Proposal not found',
                          state: 'Unknown',
                          votesFor: 0,
                          votesAgainst: 0,
                          startBlock: 0,
                          endBlock: 0,
                        ),
                      );
                      return _buildProposalDetail(context, proposal);
                    } else if (state is GovernanceError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Error loading proposal: ${state.message}',
                              style: AppTextStyles.body1.copyWith(
                                color: AppColors.error,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            GradientButton(
                              text: 'Retry',
                              onPressed: () {
                                context.read<GovernanceBloc>()
                                  .add(LoadGovernanceData());
                              },
                            ),
                          ],
                        ),
                      );
                    }
                    return const Center(child: Text('No data available'));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => AppColors.cardGradient.createShader(bounds),
          child: Text(
            'Proposal Details',
            style: AppTextStyles.h2.copyWith(
              color: Colors.white,
              fontSize: 32,
            ),
          ),
        ),
        GradientButton(
          text: 'Back',
          icon: Icons.arrow_back,
          onPressed: () => context.go('/governance'),
        ),
      ],
    );
  }

  Widget _buildProposalDetail(BuildContext context, ProposalModel proposal) {
    final totalVotes = proposal.votesFor + proposal.votesAgainst;
    final forPercentage = totalVotes > 0 ? (proposal.votesFor / totalVotes) * 100 : 0.0;
    final againstPercentage = totalVotes > 0 ? (proposal.votesAgainst / totalVotes) * 100 : 0.0;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          glass_card.GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Proposal header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                          ),
                          child: const Text(
                            'Governance',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          proposal.id,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: _getStateColor(proposal.state).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                      ),
                      child: Text(
                        proposal.state.toUpperCase(),
                        style: AppTextStyles.caption.copyWith(
                          color: _getStateColor(proposal.state),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                
                // Title
                Text(
                  proposal.description,
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                
                // Description
                Text(
                  'Proposal details would be shown here.',
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                
                // Proposer
                Row(
                  children: [
                    const Icon(Icons.account_circle, color: AppColors.textMuted, size: 16),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'Proposed by: ${_shortenAddress('0x1234...5678')}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                
                // Dates
                Row(
                  children: [
                    const Icon(Icons.access_time, color: AppColors.textMuted, size: 16),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'Start Block: ${proposal.startBlock} | End Block: ${proposal.endBlock}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          
          // Voting Results
          glass_card.GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Voting Results',
                  style: AppTextStyles.h4.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                
                // For votes
                _buildVoteBar(
                  'For',
                  proposal.votesFor,
                  forPercentage,
                  AppColors.success,
                ),
                const SizedBox(height: AppSpacing.sm),
                
                // Against votes
                _buildVoteBar(
                  'Against',
                  proposal.votesAgainst,
                  againstPercentage,
                  AppColors.error,
                ),
                const SizedBox(height: AppSpacing.md),
                
                // Total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Votes',
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${proposal.votesFor + proposal.votesAgainst}',
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          
          // Vote Actions
          glass_card.GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cast Your Vote',
                  style: AppTextStyles.h4.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                
                Row(
                  children: [
                    Expanded(
                      child: GradientButton(
                        text: 'Vote For',
                        onPressed: () {
                          // TODO: Implement vote for
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Voting functionality coming soon')),
                          );
                        },
                        gradient: AppColors.successGradient,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: GradientButton(
                        text: 'Vote Against',
                        onPressed: () {
                          // TODO: Implement vote against
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Voting functionality coming soon')),
                          );
                        },
                        gradient: AppColors.warningGradient, // Using warning gradient instead of error
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoteBar(String label, int votes, double percentage, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTextStyles.body1.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              '$votes votes ($percentage%)',
              style: AppTextStyles.body1.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.backgroundMid, // Using backgroundMid instead of cardBackground
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage / 100,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getStateColor(String state) {
    switch (state.toLowerCase()) {
      case 'active':
      case 'voting':
        return AppColors.success;
      case 'passed':
        return AppColors.primary;
      case 'rejected':
        return AppColors.error;
      case 'executed':
        return AppColors.warning;
      default:
        return AppColors.textMuted;
    }
  }

  String _shortenAddress(String address) {
    if (address.length <= 10) return address;
    return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
  }
}