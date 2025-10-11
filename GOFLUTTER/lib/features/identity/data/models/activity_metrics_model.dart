import 'package:equatable/equatable.dart';

class ActivityMetricsModel extends Equatable {
  final int postsCreated;
  final int commentsMade;
  final int likesGiven;
  final int likesReceived;
  final int transactions;
  final int proposalsCreated;
  final int votesCast;
  final DateTime lastActive;
  final int streakDays;
  final int totalTokensEarned;

  const ActivityMetricsModel({
    required this.postsCreated,
    required this.commentsMade,
    required this.likesGiven,
    required this.likesReceived,
    required this.transactions,
    required this.proposalsCreated,
    required this.votesCast,
    required this.lastActive,
    required this.streakDays,
    required this.totalTokensEarned,
  });

  @override
  List<Object?> get props => [
        postsCreated,
        commentsMade,
        likesGiven,
        likesReceived,
        transactions,
        proposalsCreated,
        votesCast,
        lastActive,
        streakDays,
        totalTokensEarned,
      ];

  factory ActivityMetricsModel.fromJson(Map<String, dynamic> json) {
    return ActivityMetricsModel(
      postsCreated: json['posts_created'] as int,
      commentsMade: json['comments_made'] as int,
      likesGiven: json['likes_given'] as int,
      likesReceived: json['likes_received'] as int,
      transactions: json['transactions'] as int,
      proposalsCreated: json['proposals_created'] as int,
      votesCast: json['votes_cast'] as int,
      lastActive: DateTime.parse(json['last_active'] as String),
      streakDays: json['streak_days'] as int,
      totalTokensEarned: json['total_tokens_earned'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'posts_created': postsCreated,
      'comments_made': commentsMade,
      'likes_given': likesGiven,
      'likes_received': likesReceived,
      'transactions': transactions,
      'proposals_created': proposalsCreated,
      'votes_cast': votesCast,
      'last_active': lastActive.toIso8601String(),
      'streak_days': streakDays,
      'total_tokens_earned': totalTokensEarned,
    };
  }
}
