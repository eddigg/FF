
import 'package:equatable/equatable.dart';

class TrendingTopicModel extends Equatable {
  final String name;
  final int count;

  const TrendingTopicModel({
    required this.name,
    required this.count,
  });

  @override
  List<Object> get props => [name, count];

  factory TrendingTopicModel.fromJson(Map<String, dynamic> json) {
    return TrendingTopicModel(
      name: json['name'] ?? '',
      count: json['count'] ?? 0,
    );
  }
}
