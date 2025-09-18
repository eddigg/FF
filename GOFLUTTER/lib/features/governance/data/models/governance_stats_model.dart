
import 'package:equatable/equatable.dart';

class GovernanceStatsModel extends Equatable {
  final int activeProposals;
  final int totalVoters;
  final int totalVotingPower;
  final int quorumRequired;

  const GovernanceStatsModel({
    required this.activeProposals,
    required this.totalVoters,
    required this.totalVotingPower,
    required this.quorumRequired,
  });

  @override
  List<Object> get props => [
        activeProposals,
        totalVoters,
        totalVotingPower,
        quorumRequired,
      ];

  factory GovernanceStatsModel.fromJson(Map<String, dynamic> json) {
    return GovernanceStatsModel(
      activeProposals: json['activeProposals'] ?? 0,
      totalVoters: json['totalVoters'] ?? 0,
      totalVotingPower: json['totalVotingPower'] ?? 0,
      quorumRequired: json['quorumRequired'] ?? 0,
    );
  }
}
