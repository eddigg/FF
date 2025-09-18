
import 'package:equatable/equatable.dart';

class GovernanceParametersModel extends Equatable {
  final int minDuration;
  final int maxDuration;
  final int minStake;
  final double votingThreshold;

  const GovernanceParametersModel({
    required this.minDuration,
    required this.maxDuration,
    required this.minStake,
    required this.votingThreshold,
  });

  @override
  List<Object> get props => [
        minDuration,
        maxDuration,
        minStake,
        votingThreshold,
      ];

  factory GovernanceParametersModel.fromJson(Map<String, dynamic> json) {
    return GovernanceParametersModel(
      minDuration: json['minDuration'] ?? 0,
      maxDuration: json['maxDuration'] ?? 0,
      minStake: json['minStake'] ?? 0,
      votingThreshold: (json['votingThreshold'] ?? 0.0).toDouble(),
    );
  }
}
