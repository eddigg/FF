
import 'package:equatable/equatable.dart';

class ReputationDataModel extends Equatable {
  final int score;
  final String level;
  final String description;
  final List<String> badges;
  final Map<String, dynamic> metrics;

  const ReputationDataModel({
    required this.score,
    required this.level,
    required this.description,
    required this.badges,
    required this.metrics,
  });

  @override
  List<Object> get props => [score, level, description, badges, metrics];

  factory ReputationDataModel.fromJson(Map<String, dynamic> json) {
    return ReputationDataModel(
      score: json['score'] ?? 0,
      level: json['level'] ?? '',
      description: json['description'] ?? '',
      badges: List<String>.from(json['badges'] ?? []),
      metrics: json['metrics'] ?? {},
    );
  }
}
