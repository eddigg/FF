
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/defi_bloc.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/common_widgets.dart';

class DeFiSidebar extends StatelessWidget {
  final String selectedSection;
  final ValueChanged<String> onSectionSelected;

  const DeFiSidebar({
    Key? key,
    required this.selectedSection,
    required this.onSectionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      margin: const EdgeInsets.all(AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            _buildNavItem(context, 'portfolio', '📊 Portfolio'),
            _buildNavItem(context, 'lending', '💰 Lending'),
            _buildNavItem(context, 'trading', '📈 Trading'),
            _buildNavItem(context, 'staking', '🔒 Staking'),
            _buildNavItem(context, 'liquidity', '💧 Liquidity'),
            _buildNavItem(context, 'yield', '🌾 Yield Farming'),
            const SizedBox(height: AppSpacing.xl),
            BlocBuilder<DeFiBloc, DeFiState>(
              builder: (context, state) {
                if (state is DeFiLoaded) {
                  return Column(
                    children: [
                      const Text('Total Value', style: AppTextStyles.h4),
                      Text(state.portfolioData.totalValue.toStringAsFixed(2), style: AppTextStyles.h1),
                      const SizedBox(height: AppSpacing.md),
                      _buildStatItem('Staked', state.portfolioData.staked.toStringAsFixed(2)),
                      _buildStatItem('Lent', state.portfolioData.lent.toStringAsFixed(2)),
                      _buildStatItem('Rewards', state.portfolioData.rewards.toStringAsFixed(2)),
                      _buildStatItem('APY', '${state.portfolioData.apy.toStringAsFixed(2)}%'),
                    ],
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String section, String title) {
    final bool isSelected = selectedSection == section;
    return ListTile(
      leading: Text(title.substring(0, 2), style: const TextStyle(fontSize: 24)),
      title: Text(title.substring(2), style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w500)),
      selected: isSelected,
      onTap: () => onSectionSelected(section),
      selectedTileColor: AppColors.primary.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
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
