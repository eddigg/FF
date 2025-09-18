import 'package:atlas_blockchain_flutter/features/social/domain/entities/post.dart';

abstract class SocialRepository {
  Future<List<Post>> getFeed(String userId);
  Future<Post> createPost(String userId, String content, List<String> tags);
  Future<bool> likePost(String userId, String postId);
  Future<List<Post>> getTrendingPosts();
  Future<List<String>> getTrendingTopics();
}