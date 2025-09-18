
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/identity_bloc.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/common_widgets.dart';

class IdentitySidebar extends StatelessWidget {
  final String selectedSection;
  final ValueChanged<String> onSectionSelected;

  const IdentitySidebar({
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
            _buildNavItem(context, 'profile', '👤 Profile'),
            _buildNavItem(context, 'kyc', '🆔 KYC Verification'),
            _buildNavItem(context, 'privacy', '🔒 Privacy Settings'),
            _buildNavItem(context, 'verification', '✅ Identity Verification'),
            _buildNavItem(context, 'activity', '📊 Activity History'),
            _buildNavItem(context, 'reputation', '⭐ Reputation Score'),
            const SizedBox(height: AppSpacing.xl),
            BlocBuilder<IdentityBloc, IdentityState>(
              builder: (context, state) {
                if (state is IdentityLoaded) {
                  return Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: AppColors.primary,
                        child: Text(
                          state.userProfile.username[0].toUpperCase(),
                          style: const TextStyle(fontSize: 32, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(state.userProfile.username, style: AppTextStyles.h4),
                      const SizedBox(height: AppSpacing.xs),
                      Text(state.userProfile.status, style: AppTextStyles.body2),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem('Reputation', state.reputationData.score.toString()),
                          _buildStatItem('Verification', state.userProfile.verificationLevel),
                        ],
                      ),
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
    return Column(
      children: [
        Text(value, style: AppTextStyles.h4),
        Text(title, style: AppTextStyles.caption),
      ],
    );
  }
}
