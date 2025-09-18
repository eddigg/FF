
import 'package:equatable/equatable.dart';

class UserProfileSummaryModel extends Equatable {
  final String username;
  final int postsCount;
  final int followersCount;
  final int followingCount;

  const UserProfileSummaryModel({
    required this.username,
    required this.postsCount,
    required this.followersCount,
    required this.followingCount,
  });

  @override
  List<Object> get props => [
        username,
        postsCount,
        followersCount,
        followingCount,
      ];

  factory UserProfileSummaryModel.fromJson(Map<String, dynamic> json) {
    return UserProfileSummaryModel(
      username: json['username'] ?? '',
      postsCount: json['postsCount'] ?? 0,
      followersCount: json['followersCount'] ?? 0,
      followingCount: json['followingCount'] ?? 0,
    );
  }
}
