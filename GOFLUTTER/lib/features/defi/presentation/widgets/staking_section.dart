import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/defi_bloc.dart';
import '../../data/models/staking_option_model.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/common_widgets.dart';

class StakingSection extends StatefulWidget {
  const StakingSection({Key? key}) : super(key: key);

  @override
  State<StakingSection> createState() => _StakingSectionState();
}

class _StakingSectionState extends State<StakingSection> {
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Staking', style: AppTextStyles.h4),
            const SizedBox(height: AppSpacing.md),
            BlocBuilder<DeFiBloc, DeFiState>(
              builder: (context, state) {
                if (state is DeFiLoaded) {
                  return GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: state.stakingOptions.map((option) => _buildStakingCard(context, option)).toList(),
                  );
                } else if (state is DeFiLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return const Center(child: Text('Error loading staking options'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStakingCard(BuildContext context, StakingOptionModel option) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            option.reward,
            style: AppTextStyles.h3.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            option.period,
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Min: \$${option.minStake}',
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: AppSpacing.md),
          GradientButton(
            text: 'Stake Now',
            onPressed: () {
              _showStakeDialog(context, option);
            },
          ),
        ],
      ),
    );
  }

  void _showStakeDialog(BuildContext context, StakingOptionModel option) {
    _amountController.clear();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Stake in ${option.reward} Pool'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Minimum stake: \$${option.minStake}'),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount to stake',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final amount = double.tryParse(_amountController.text);
                if (amount != null && amount >= option.minStake) {
                  // In a real implementation, we would get the user's address
                  final userAddress = '0x1234567890abcdef'; // Placeholder address
                  
                  context.read<DeFiBloc>().add(StakeTokens(
                    address: userAddress,
                    poolId: option.id,
                    amount: amount,
                  ));
                  
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tokens staked successfully!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid amount or below minimum stake')),
                  );
                }
              },
              child: const Text('Stake'),
            ),
          ],
        );
      },
    );
  }
}