import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/defi_bloc.dart';
import '../../data/models/trading_pair_model.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/common_widgets.dart';

class TradingSection extends StatelessWidget {
  const TradingSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('DEX Trading', style: AppTextStyles.h4),
            const SizedBox(height: AppSpacing.md),
            BlocBuilder<DeFiBloc, DeFiState>(
              builder: (context, state) {
                if (state is DeFiLoaded) {
                  return Column(
                    children: [
                      // Trading pairs
                      _buildTradingPairsSection(context, state.tradingPairs),
                      const SizedBox(height: AppSpacing.md),
                      // Quick trade form
                      _buildQuickTradeForm(context),
                    ],
                  );
                } else if (state is DeFiLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return const Center(child: Text('Error loading trading pairs'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTradingPairsSection(BuildContext context, List<TradingPairModel> tradingPairs) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Available Trading Pairs', style: AppTextStyles.h5),
            const SizedBox(height: AppSpacing.md),
            Column(
              children: tradingPairs.map((pair) => _buildTradingPairItem(context, pair)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTradingPairItem(BuildContext context, TradingPairModel pair) {
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
          Text(
            pair.symbol,
            style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${pair.price.toStringAsFixed(2)}',
                style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                '${pair.change >= 0 ? '+' : ''}${pair.change.toStringAsFixed(2)}%',
                style: AppTextStyles.caption.copyWith(
                  color: pair.change >= 0 ? AppColors.success : AppColors.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickTradeForm(BuildContext context) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Quick Trade', style: AppTextStyles.h5),
            const SizedBox(height: AppSpacing.md),
            // From Token
            const Text('From Token', style: AppTextStyles.caption),
            const SizedBox(height: AppSpacing.xs),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'ATLAS', child: Text('ATLAS')),
                DropdownMenuItem(value: 'ETH', child: Text('ETH')),
                DropdownMenuItem(value: 'USDC', child: Text('USDC')),
              ],
              onChanged: (value) {},
            ),
            const SizedBox(height: AppSpacing.md),
            // Amount
            const Text('Amount', style: AppTextStyles.caption),
            const SizedBox(height: AppSpacing.xs),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '0.0',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppSpacing.md),
            // To Token
            const Text('To Token', style: AppTextStyles.caption),
            const SizedBox(height: AppSpacing.xs),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'USDC', child: Text('USDC')),
                DropdownMenuItem(value: 'ATLAS', child: Text('ATLAS')),
                DropdownMenuItem(value: 'ETH', child: Text('ETH')),
              ],
              onChanged: (value) {},
            ),
            const SizedBox(height: AppSpacing.md),
            GradientButton(
              text: 'Trade',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Trade executed successfully!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}