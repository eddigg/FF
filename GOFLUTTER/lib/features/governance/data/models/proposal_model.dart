
import 'package:equatable/equatable.dart';

class ProposalModel extends Equatable {
  final String id;
  final String description;
  final String state;
  final int votesFor;
  final int votesAgainst;
  final int startBlock;
  final int endBlock;

  const ProposalModel({
    required this.id,
    required this.description,
    required this.state,
    required this.votesFor,
    required this.votesAgainst,
    required this.startBlock,
    required this.endBlock,
  });

  @override
  List<Object> get props => [
        id,
        description,
        state,
        votesFor,
        votesAgainst,
        startBlock,
        endBlock,
      ];

  factory ProposalModel.fromJson(Map<String, dynamic> json) {
    return ProposalModel(
      id: json['ID'] ?? '',
      description: json['Description'] ?? '',
      state: json['State'] ?? '',
      votesFor: json['VotesFor'] ?? 0,
      votesAgainst: json['VotesAgainst'] ?? 0,
      startBlock: json['StartBlock'] ?? 0,
      endBlock: json['EndBlock'] ?? 0,
    );
  }
}
