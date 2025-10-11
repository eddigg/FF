import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';

class SocialApiClient {
  final ApiClient _apiClient;

  SocialApiClient(this._apiClient);

  Future<List<dynamic>> fetchSocialFeed() async {
    try {
      final response = await _apiClient.dio.get('/social/feed');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch social feed: $e');
    }
  }

  Future<List<dynamic>> fetchTrendingTopics() async {
    try {
      final response = await _apiClient.dio.get('/social/trending');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch trending topics: $e');
    }
  }

  Future<List<dynamic>> fetchModerationQueue() async {
    try {
      final response = await _apiClient.dio.get('/social/moderation');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch moderation queue: $e');
    }
  }

  Future<Map<String, dynamic>> fetchUserProfileSummary() async {
    try {
      final response = await _apiClient.dio.get('/social/profile/summary');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch user profile summary: $e');
    }
  }

  Future<List<dynamic>> fetchSuggestedUsers() async {
    try {
      final response = await _apiClient.dio.get('/social/users/suggested');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch suggested users: $e');
    }
  }

  Future<void> createPost(String content) async {
    try {
      await _apiClient.dio.post('/social/post/create', data: {'content': content});
    } on DioException catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }

  Future<void> likePost(String postId) async {
    try {
      await _apiClient.dio.post('/social/post/$postId/like');
    } on DioException catch (e) {
      throw Exception('Failed to like post: $e');
    }
  }

  Future<void> unlikePost(String postId) async {
    try {
      await _apiClient.dio.delete('/social/post/$postId/like');
    } on DioException catch (e) {
      throw Exception('Failed to unlike post: $e');
    }
  }

  Future<void> addComment(String postId, String content) async {
    try {
      await _apiClient.dio.post('/social/post/$postId/comment', data: {'content': content});
    } on DioException catch (e) {
      throw Exception('Failed to add comment: $e');
    }
  }

  Future<void> repostPost(String postId) async {
    try {
      await _apiClient.dio.post('/social/post/$postId/repost');
    } on DioException catch (e) {
      throw Exception('Failed to repost: $e');
    }
  }

  Future<List<dynamic>> fetchTrendingPosts() async {
    try {
      final response = await _apiClient.dio.get('/social/posts/trending');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch trending posts: $e');
    }
  }
}
