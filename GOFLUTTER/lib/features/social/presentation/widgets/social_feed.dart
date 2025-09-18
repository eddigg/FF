import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/social_bloc.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/common_widgets.dart';

class SocialFeed extends StatefulWidget {
  const SocialFeed({Key? key}) : super(key: key);

  @override
  State<SocialFeed> createState() => _SocialFeedState();
}

class _SocialFeedState extends State<SocialFeed> {
  final Map<String, bool> _expandedComments = {};
  final Map<String, TextEditingController> _commentControllers = {};

  @override
  void dispose() {
    for (var controller in _commentControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _toggleLike(String postId, bool isLiked) {
    if (isLiked) {
      context.read<SocialBloc>().add(UnlikePost(postId: postId));
    } else {
      context.read<SocialBloc>().add(LikePost(postId: postId));
    }
  }

  void _toggleComments(String postId) {
    setState(() {
      _expandedComments[postId] = !(_expandedComments[postId] ?? false);
    });
  }

  void _addComment(String postId, String content) {
    if (content.trim().isEmpty) return;

    context.read<SocialBloc>().add(AddComment(postId: postId, content: content));

    // Clear the comment field
    _commentControllers[postId]?.clear();
  }

  void _repostPost(String postId) {
    context.read<SocialBloc>().add(RepostPost(postId: postId));
  }

  void _reportPost(String postId) {
    // TODO: Implement actual report functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post reported successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SocialBloc, SocialState>(
      builder: (context, state) {
        if (state is SocialLoaded) {
          if (state.posts.isEmpty) {
            return const GlassCard(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: Column(
                  children: [
                    Icon(
                      Icons.article_outlined,
                      size: 48,
                      color: AppColors.textMuted,
                    ),
                    SizedBox(height: AppSpacing.md),
                    Text(
                      'No posts yet. Be the first to post!',
                      style: AppTextStyles.body1,
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            children: state.posts.map((post) {
              final isLiked = post.isLiked;
              final commentsExpanded = _expandedComments[post.id] ?? false;
              
              // Initialize comment controller if not exists
              if (!_commentControllers.containsKey(post.id)) {
                _commentControllers[post.id] = TextEditingController();
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: GlassCard(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Post header
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Center(
                                child: Text(
                                  post.author.substring(0, 1).toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post.author,
                                  style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  post.time,
                                  style: AppTextStyles.caption,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        
                        // Post content
                        Text(
                          post.content,
                          style: AppTextStyles.body1,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        
                        // Post actions
                        Row(
                          children: [
                            TextButton.icon(
                              onPressed: () => _toggleLike(post.id, isLiked),
                              icon: Icon(
                                isLiked ? Icons.favorite : Icons.favorite_border,
                                color: isLiked ? AppColors.error : AppColors.textSecondary,
                              ),
                              label: Text('${post.likes}'),
                            ),
                            TextButton.icon(
                              onPressed: () => _toggleComments(post.id),
                              icon: const Icon(Icons.comment_outlined),
                              label: Text('${post.comments.length}'),
                            ),
                            TextButton.icon(
                              onPressed: () => _repostPost(post.id),
                              icon: const Icon(Icons.repeat),
                              label: Text('${post.reposts}'),
                            ),
                            TextButton.icon(
                              onPressed: () => _reportPost(post.id),
                              icon: const Icon(Icons.report_outlined),
                              label: const Text('Report'),
                            ),
                          ],
                        ),
                        
                        // Comments section
                        if (commentsExpanded) ...[
                          const Divider(),
                          ...post.comments.map((comment) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                              child: GlassCard(
                                child: Padding(
                                  padding: const EdgeInsets.all(AppSpacing.sm),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        comment.author,
                                        style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        comment.content,
                                        style: AppTextStyles.body2,
                                      ),
                                      Text(
                                        comment.time,
                                        style: AppTextStyles.caption,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          const SizedBox(height: AppSpacing.sm),
                          TextField(
                            controller: _commentControllers[post.id],
                            decoration: const InputDecoration(
                              hintText: 'Add a comment...',
                              border: OutlineInputBorder(),
                            ),
                            onSubmitted: (value) => _addComment(post.id, value),
                          ),
                        ],
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
          return GlassCard(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Error loading social feed: ${state.message}',
                    style: AppTextStyles.body1,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}