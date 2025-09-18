import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/defi_bloc.dart';
import '../../data/models/lending_pool_model.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/common_widgets.dart';

class LendingSection extends StatelessWidget {
  const LendingSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Lending & Borrowing', style: AppTextStyles.h4),
            const SizedBox(height: AppSpacing.md),
            BlocBuilder<DeFiBloc, DeFiState>(
              builder: (context, state) {
                if (state is DeFiLoaded) {
                  return Column(
                    children: state.lendingPools.map((pool) => _buildPoolCard(context, pool)).toList(),
                  );
                } else if (state is DeFiLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return const Center(child: Text('Error loading lending pools'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPoolCard(BuildContext context, LendingPoolModel pool) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pool header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                pool.name,
                style: AppTextStyles.h5,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Text(
                  '${pool.supplyAPY}% APY',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // Pool stats grid
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.sm,
            mainAxisSpacing: AppSpacing.sm,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildPoolStat('Supply APY', '${pool.supplyAPY}%'),
              _buildPoolStat('Borrow APY', '${pool.borrowAPY}%'),
              _buildPoolStat('Total Supply', '\$${(pool.totalSupply / 1000000).toStringAsFixed(1)}M'),
              _buildPoolStat('Utilization', '${pool.utilization}%'),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // Action buttons
          Row(
            children: [
              Expanded(
                child: GradientButton(
                  text: 'Supply',
                  onPressed: () {
                    // TODO: Implement supply functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Supply functionality coming soon')),
                    );
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: GradientButton(
                  text: 'Borrow',
                  gradient: AppColors.secondaryGradient,
                  onPressed: () {
                    // TODO: Implement borrow functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Borrow functionality coming soon')),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPoolStat(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            label,
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}