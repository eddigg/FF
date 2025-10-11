import 'package:equatable/equatable.dart';

class PostModel extends Equatable {
  final String id;
  final String author;
  final String content;
  final String time;
  final int likes;
  final bool isLiked;
  final List<CommentModel> comments;
  final int reposts;
  final List<String> tags;

  const PostModel({
    required this.id,
    required this.author,
    required this.content,
    required this.time,
    required this.likes,
    required this.isLiked,
    required this.comments,
    required this.reposts,
    required this.tags,
  });

  @override
  List<Object> get props => [id, author, content, time, likes, isLiked, comments, reposts, tags];

  factory PostModel.fromJson(Map<String, dynamic> json) {
    var commentsList = json['comments'] as List?;
    List<CommentModel> comments = commentsList != null
        ? commentsList.map((c) => CommentModel.fromJson(c)).toList()
        : [];

    var tagsList = json['tags'] as List?;
    List<String> tags = tagsList != null
        ? List<String>.from(tagsList)
        : [];

    return PostModel(
      id: json['id'] ?? '',
      author: json['author'] ?? '',
      content: json['content'] ?? '',
      time: json['time'] ?? '',
      likes: json['likes'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      comments: comments,
      reposts: json['reposts'] ?? 0,
      tags: tags,
    );
  }
}

class CommentModel extends Equatable {
  final String id;
  final String author;
  final String content;
  final String time;
  final int likes;

  const CommentModel({
    required this.id,
    required this.author,
    required this.content,
    required this.time,
    required this.likes,
  });

  @override
  List<Object> get props => [id, author, content, time, likes];

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] ?? '',
      author: json['author'] ?? '',
      content: json['content'] ?? '',
      time: json['time'] ?? '',
      likes: json['likes'] ?? 0,
    );
  }
}
