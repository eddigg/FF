import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/social_bloc.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/common_widgets.dart';

class SocialSidebar extends StatelessWidget {
  final String selectedSection;
  final ValueChanged<String> onSectionSelected;

  const SocialSidebar({
    Key? key,
    required this.selectedSection,
    required this.onSectionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sections = [
      {'key': 'feed', 'title': '📰 Social Feed', 'icon': '📰'},
      {'key': 'create', 'title': '✏️ Create Post', 'icon': '✏️'},
      {'key': 'trending', 'title': '🔥 Trending Topics', 'icon': '🔥'},
      {'key': 'moderation', 'title': '🛡️ Content Moderation', 'icon': '🛡️'},
    ];

    return GlassCard(
      width: 300,
      margin: const EdgeInsets.all(AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            ...sections.map((section) {
              final isSelected = selectedSection == section['key'];
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: GestureDetector(
                  onTap: () => onSectionSelected(section['key'] as String),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                    child: Row(
                      children: [
                        Text(
                          section['icon'] as String,
                          style: TextStyle(
                            fontSize: 20,
                            color: isSelected ? AppColors.primary : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          section['title'] as String,
                          style: AppTextStyles.body1.copyWith(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? AppColors.primary : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: AppSpacing.xl),
            // Profile Section
            BlocBuilder<SocialBloc, SocialState>(
              builder: (context, state) {
                if (state is SocialLoaded) {
                  return GlassCard(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: const BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.all(Radius.circular(40)),
                            ),
                            child: Center(
                              child: Text(
                                state.userProfileSummary.username.substring(0, 1).toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            state.userProfileSummary.username,
                            style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem(
                                'Posts',
                                state.userProfileSummary.postsCount.toString(),
                              ),
                              _buildStatItem(
                                'Followers',
                                state.userProfileSummary.followersCount.toString(),
                              ),
                              _buildStatItem(
                                'Following',
                                state.userProfileSummary.followingCount.toString(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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

  Widget _buildStatItem(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.h4.copyWith(color: AppColors.primary),
        ),
        Text(
          title,
          style: AppTextStyles.caption,
        ),
      ],
    );
  }
}