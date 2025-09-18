import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/defi_bloc.dart';
import '../../data/models/portfolio_data_model.dart';
import '../../data/models/asset_model.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/common_widgets.dart';

class PortfolioSection extends StatelessWidget {
  const PortfolioSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Portfolio Overview', style: AppTextStyles.h4),
            const SizedBox(height: AppSpacing.md),
            BlocBuilder<DeFiBloc, DeFiState>(
              builder: (context, state) {
                if (state is DeFiLoaded) {
                  return Column(
                    children: [
                      // Portfolio summary cards
                      _buildPortfolioSummary(state.portfolioData),
                      const SizedBox(height: AppSpacing.md),
                      // Assets list
                      const Text('Your Assets', style: AppTextStyles.h5),
                      const SizedBox(height: AppSpacing.sm),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.portfolioData.assets.length,
                        itemBuilder: (context, index) {
                          final asset = state.portfolioData.assets[index];
                          return _buildAssetItem(asset);
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      // Recent transactions
                      const Text('Recent Transactions', style: AppTextStyles.h5),
                      const SizedBox(height: AppSpacing.sm),
                      const Text(
                        'No recent transactions',
                        style: AppTextStyles.caption,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                } else if (state is DeFiLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return const Center(child: Text('Error loading portfolio'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPortfolioSummary(PortfolioDataModel portfolioData) {
    return Column(
      children: [
        // Total value
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              Text(
                '\$${portfolioData.totalValue.toStringAsFixed(2)}',
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${portfolioData.change >= 0 ? '+' : ''}${portfolioData.change.toStringAsFixed(2)}%',
                style: AppTextStyles.caption.copyWith(
                  color: portfolioData.change >= 0 ? AppColors.success : AppColors.error,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        // Stats grid
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: AppSpacing.sm,
          mainAxisSpacing: AppSpacing.sm,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildStatCard('Staked', '\$${portfolioData.staked.toStringAsFixed(2)}'),
            _buildStatCard('Lent', '\$${portfolioData.lent.toStringAsFixed(2)}'),
            _buildStatCard('Rewards', '\$${portfolioData.rewards.toStringAsFixed(2)}'),
            _buildStatCard('APY', '${portfolioData.apy.toStringAsFixed(1)}%'),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value) {
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
            style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            label,
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }

  Widget _buildAssetItem(AssetModel asset) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                asset.symbol,
                style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                asset.amount.toStringAsFixed(2),
                style: AppTextStyles.caption,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${asset.value.toStringAsFixed(2)}',
                style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                '${asset.change >= 0 ? '+' : ''}${asset.change.toStringAsFixed(2)}%',
                style: AppTextStyles.caption.copyWith(
                  color: asset.change >= 0 ? AppColors.success : AppColors.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}