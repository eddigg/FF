import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/social_bloc.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/common_widgets.dart';

class TrendingTopicsSection extends StatelessWidget {
  const TrendingTopicsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('🔥 Trending Topics', style: AppTextStyles.h4),
            const SizedBox(height: AppSpacing.md),
            BlocBuilder<SocialBloc, SocialState>(
              builder: (context, state) {
                if (state is SocialLoaded) {
                  if (state.trendingTopics.isEmpty) {
                    return const Text(
                      'No trending topics at the moment.',
                      style: AppTextStyles.body1,
                    );
                  }

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
                } else if (state is SocialError) {
                  return Text(
                    'Error loading trending topics: ${state.message}',
                    style: AppTextStyles.body1,
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}