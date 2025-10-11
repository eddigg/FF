import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final String id;
  final String author;
  final String content;
  final DateTime timestamp;
  final int likes;
  final int comments;
  final int reposts;
  final List<String> tags;

  const Post({
    required this.id,
    required this.author,
    required this.content,
    required this.timestamp,
    required this.likes,
    required this.comments,
    required this.reposts,
    required this.tags,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    var tagsList = json['tags'] as List?;
    List<String> tags = tagsList != null
        ? tagsList.map((t) => t as String).toList()
        : [];

    return Post(
      id: json['id'] as String,
      author: json['author'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      likes: json['likes'] as int,
      comments: json['comments'] as int,
      reposts: json['reposts'] as int,
      tags: tags,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'likes': likes,
      'comments': comments,
      'reposts': reposts,
      'tags': tags,
    };
  }

  Post copyWith({
    String? id,
    String? author,
    String? content,
    DateTime? timestamp,
    int? likes,
    int? comments,
    int? reposts,
    List<String>? tags,
  }) {
    return Post(
      id: id ?? this.id,
      author: author ?? this.author,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      reposts: reposts ?? this.reposts,
      tags: tags ?? this.tags,
    );
  }

  @override
  List<Object?> get props => [
        id,
        author,
        content,
        timestamp,
        likes,
        comments,
        reposts,
        tags,
      ];
}
