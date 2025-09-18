import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/social_bloc.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/common_widgets.dart';

class ContentModerationSection extends StatelessWidget {
  const ContentModerationSection({Key? key}) : super(key: key);

  void _moderateContent(BuildContext context, String contentId, String action) {
    // TODO: Implement actual moderation functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Content $action successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('🛡️ Content Moderation', style: AppTextStyles.h4),
            const SizedBox(height: AppSpacing.md),
            BlocBuilder<SocialBloc, SocialState>(
              builder: (context, state) {
                if (state is SocialLoaded) {
                  if (state.moderationQueue.isEmpty) {
                    return const Text(
                      'No content pending moderation.',
                      style: AppTextStyles.body1,
                    );
                  }

                  return Column(
                    children: state.moderationQueue.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: GlassCard(
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.type.toUpperCase(),
                                        style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        item.content,
                                        style: AppTextStyles.caption,
                                      ),
                                      Text(
                                        'by ${item.author}',
                                        style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                                      ),
                                    ],
                                  ),
                                ),
                                GradientButton(
                                  text: 'Approve',
                                  onPressed: () => _moderateContent(context, item.id, 'approved'),
                                  gradient: AppColors.successGradient,
                                  width: 80,
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                GradientButton(
                                  text: 'Reject',
                                  onPressed: () => _moderateContent(context, item.id, 'rejected'),
                                  gradient: const LinearGradient(colors: [AppColors.error, AppColors.error]),
                                  width: 80,
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
                    'Error loading moderation queue: ${state.message}',
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