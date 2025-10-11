import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/themes/app_spacing.dart';
import '../../../../shared/themes/app_text_styles.dart';
import '../../../../shared/themes/app_colors.dart';
// Remove real repository import
import '../../../../core/stubs/stub_blocs_clean.dart'; // Use stub BLoC instead

// Temporary workaround for widget import issues
class GlassCard extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsets? margin;
  final EdgeInsets? padding;

  const GlassCard({super.key, this.child, this.width, this.height, this.margin, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: child,
    );
  }
}

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final LinearGradient? gradient;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final IconData? icon;

  const GradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.gradient,
    this.padding,
    this.width,
    this.height,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: onPressed != null ? (gradient ?? LinearGradient(
          colors: [Colors.blue, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )) : null,
        color: onPressed == null ? Colors.grey : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) Icon(icon, color: Colors.white),
          if (icon != null) const SizedBox(width: 8),
          Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class ProposalDetailPage extends StatelessWidget {
  final String proposalId;

  const ProposalDetailPage({super.key, required this.proposalId});

  @override
  Widget build(BuildContext context) {
    // Use the stub BLoC directly instead of creating a new one with repository
    return ProposalDetailView(proposalId: proposalId);
  }
}

class ProposalDetailView extends StatelessWidget {
  final String proposalId;

  const ProposalDetailView({super.key, required this.proposalId});

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
                // Use the stub BLoC from the context
                child: BlocBuilder<GovernanceBloc, GovernanceState>(
                  builder: (context, state) {
                    // Since we're using stub BLoC, we'll show some mock data
                    return _buildProposalDetail(context);
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

  Widget _buildProposalDetail(BuildContext context) {
    // Mock data for the proposal
    final proposalId = this.proposalId;
    final totalVotes = 1250;
    final votesFor = 875;
    final votesAgainst = 375;
    final forPercentage = (votesFor / totalVotes) * 100;
    final againstPercentage = (votesAgainst / totalVotes) * 100;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlassCard(
            padding: const EdgeInsets.all(16),
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
                          proposalId,
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
                        color: _getStateColor('Active').withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                      ),
                      child: Text(
                        'ACTIVE',
                        style: AppTextStyles.caption.copyWith(
                          color: _getStateColor('Active'),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                
                // Title
                Text(
                  'Network Upgrade v2.0 Implementation',
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                
                // Description
                Text(
                  'This proposal outlines the implementation plan for Network Upgrade v2.0, which includes performance improvements, security enhancements, and new features for the Atlas Blockchain network.',
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
                      'Proposed by: ${_shortenAddress('0x742d35Cc6634C0532925a3b8D4C0532925a3b8D4')}',
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
                      'Start Block: 12345 | End Block: 15678',
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
          GlassCard(
            padding: const EdgeInsets.all(16),
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
                  votesFor,
                  forPercentage,
                  AppColors.success,
                ),
                const SizedBox(height: AppSpacing.sm),
                
                // Against votes
                _buildVoteBar(
                  'Against',
                  votesAgainst,
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
                      '$totalVotes',
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
          GlassCard(
            padding: const EdgeInsets.all(16),
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
                        gradient: LinearGradient(colors: [Colors.green, Colors.lightGreen]),
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
                        gradient: LinearGradient(colors: [Colors.orange, Colors.red]),
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