import '../models/post_model.dart';
import '../models/trending_topic_model.dart';
import '../models/moderation_item_model.dart';
import '../models/user_profile_summary_model.dart';

abstract class SocialRepository {
  Future<List<PostModel>> getSocialFeed();
  Future<List<TrendingTopicModel>> getTrendingTopics();
  Future<List<ModerationItemModel>> getModerationQueue();
  Future<UserProfileSummaryModel> getUserProfileSummary();
  Future<List<String>> getSuggestedUsers();
  Future<void> createPost(String content);
  Future<void> likePost(String postId);
  Future<void> unlikePost(String postId);
  Future<void> addComment(String postId, String content);
  Future<void> repostPost(String postId);
  Future<List<PostModel>> getTrendingPosts();
}