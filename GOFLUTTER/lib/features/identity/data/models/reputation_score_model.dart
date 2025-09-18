import 'package:atlas_blockchain_flutter/features/identity/domain/entities/user_identity.dart';

class ReputationScoreModel extends ReputationScore {
  const ReputationScoreModel({
    required super.overall,
    required super.commerce,
    required super.lastUpdated,
  });

  factory ReputationScoreModel.fromJson(Map<String, dynamic> json) {
    return ReputationScoreModel(
      overall: (json['overall'] as num).toDouble(),
      commerce: (json['commerce'] as num).toDouble(),
      lastUpdated: DateTime.parse(json['last_updated'] as String),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'overall': overall,
      'commerce': commerce,
      'last_updated': lastUpdated.toIso8601String(),
    };
  }
}