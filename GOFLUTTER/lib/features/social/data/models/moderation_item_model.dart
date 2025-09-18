
import 'package:equatable/equatable.dart';

class ModerationItemModel extends Equatable {
  final String id;
  final String type;
  final String content;
  final String author;

  const ModerationItemModel({
    required this.id,
    required this.type,
    required this.content,
    required this.author,
  });

  @override
  List<Object> get props => [id, type, content, author];

  factory ModerationItemModel.fromJson(Map<String, dynamic> json) {
    return ModerationItemModel(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      content: json['content'] ?? '',
      author: json['author'] ?? '',
    );
  }
}
