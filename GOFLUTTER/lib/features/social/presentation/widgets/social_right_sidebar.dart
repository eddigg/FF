import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/social_bloc.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/common_widgets.dart';

class SocialRightSidebar extends StatelessWidget {
  const SocialRightSidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      width: 300,
      margin: const EdgeInsets.all(AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Box
            TextField(
              decoration: const InputDecoration(
                hintText: '🔍 Search posts...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                // TODO: Implement search functionality
              },
            ),
            const SizedBox(height: AppSpacing.md),
            
            // Trending Topics
            const Text('🔥 Trending Now', style: AppTextStyles.h4),
            const SizedBox(height: AppSpacing.md),
            BlocBuilder<SocialBloc, SocialState>(
              builder: (context, state) {
                if (state is SocialLoaded) {
                  return Column(
                    children: state.trendingTopics.map((topic) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: GlassCard(
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  topic.name,
                                  style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.sm,
                                    vertical: AppSpacing.xs,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                  ),
                                  child: Text(
                                    topic.count.toString(),
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                } else if (state is SocialLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return Container();
                }
              },
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Suggested Users
            const Text('👥 Suggested Users', style: AppTextStyles.h4),
            const SizedBox(height: AppSpacing.md),
            BlocBuilder<SocialBloc, SocialState>(
              builder: (context, state) {
                if (state is SocialLoaded) {
                  return Column(
                    children: state.suggestedUsers.map((user) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: GlassCard(
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            child: Row(
                              children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: const BoxDecoration(
                                    gradient: AppColors.primaryGradient,
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      user.substring(0, 1).toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Text(
                                  user,
                                  style: AppTextStyles.body1,
                                ),
                                const Spacer(),
                                GradientButton(
                                  text: 'Follow',
                                  onPressed: () {
                                    // TODO: Implement follow functionality
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Followed $user!')),
                                    );
                                  },
                                  gradient: AppColors.primaryGradient,
                                  width: 70,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                } else if (state is SocialLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}