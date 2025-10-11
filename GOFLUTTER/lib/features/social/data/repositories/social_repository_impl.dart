import '../models/post_model.dart';
import '../models/trending_topic_model.dart';
import '../models/moderation_item_model.dart';
import '../models/user_profile_summary_model.dart';
import 'social_repository.dart';
import '../data_sources/social_api_client.dart';

class SocialRepositoryImpl implements SocialRepository {
  final SocialApiClient apiClient;

  SocialRepositoryImpl({required this.apiClient});

  @override
  Future<List<PostModel>> getSocialFeed() async {
    final data = await apiClient.fetchSocialFeed();
    return data.map((item) => PostModel.fromJson(item)).toList();
  }

  @override
  Future<List<TrendingTopicModel>> getTrendingTopics() async {
    final data = await apiClient.fetchTrendingTopics();
    return data.map((item) => TrendingTopicModel.fromJson(item)).toList();
  }

  @override
  Future<List<ModerationItemModel>> getModerationQueue() async {
    final data = await apiClient.fetchModerationQueue();
    return data.map((item) => ModerationItemModel.fromJson(item)).toList();
  }

  @override
  Future<UserProfileSummaryModel> getUserProfileSummary() async {
    final data = await apiClient.fetchUserProfileSummary();
    return UserProfileSummaryModel.fromJson(data);
  }

  @override
  Future<List<String>> getSuggestedUsers() async {
    final data = await apiClient.fetchSuggestedUsers();
    return List<String>.from(data);
  }

  @override
  Future<void> createPost(String content) async {
    await apiClient.createPost(content);
  }

  @override
  Future<void> likePost(String postId) async {
    await apiClient.likePost(postId);
  }

  @override
  Future<void> unlikePost(String postId) async {
    await apiClient.unlikePost(postId);
  }

  @override
  Future<void> addComment(String postId, String content) async {
    await apiClient.addComment(postId, content);
  }

  @override
  Future<void> repostPost(String postId) async {
    await apiClient.repostPost(postId);
  }

  @override
  Future<List<PostModel>> getTrendingPosts() async {
    final data = await apiClient.fetchTrendingPosts();
    return data.map((item) => PostModel.fromJson(item)).toList();
  }
  
  // Additional method implementations
  @override
  Future<void> toggleLikePost(String postId) async {
    // Check if post is already liked, then like or unlike accordingly
    // This is a simplified implementation
    await apiClient.likePost(postId);
  }

  @override
  Future<void> reportPost(String postId) async {
    // Simplified implementation - in a real app this would call the API
    print('Reporting post: $postId');
  }

  @override
  Future<void> moderateContent(String itemId, String action) async {
    // Simplified implementation - in a real app this would call the API
    print('Moderating content: $itemId with action: $action');
  }
}
