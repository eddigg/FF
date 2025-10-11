import 'package:equatable/equatable.dart';

class GovernanceProposal extends Equatable {
  final String id;
  final String proposer;
  final String title;
  final String description;
  final String category; // "platform", "defi", "social", "technical", "economic"
  final List<GovernanceAction> actions;
  final String state; // "draft", "active", "passed", "failed", "executed", "cancelled"
  final int votesFor;
  final int votesAgainst;
  final int votesAbstain;
  final int totalVotes;
  final bool quorumMet;
  final int startBlock;
  final int endBlock;
  final DateTime? executedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const GovernanceProposal({
    required this.id,
    required this.proposer,
    required this.title,
    required this.description,
    required this.category,
    required this.actions,
    required this.state,
    required this.votesFor,
    required this.votesAgainst,
    required this.votesAbstain,
    required this.totalVotes,
    required this.quorumMet,
    required this.startBlock,
    required this.endBlock,
    this.executedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GovernanceProposal.fromJson(Map<String, dynamic> json) {
    var actionsList = json['actions'] as List;
    List<GovernanceAction> actions = actionsList
        .map((action) => GovernanceAction.fromJson(action))
        .toList();

    return GovernanceProposal(
      id: json['id'] as String,
      proposer: json['proposer'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      actions: actions,
      state: json['state'] as String,
      votesFor: json['votes_for'] as int? ?? 0,
      votesAgainst: json['votes_against'] as int? ?? 0,
      votesAbstain: json['votes_abstain'] as int? ?? 0,
      totalVotes: json['total_votes'] as int? ?? 0,
      quorumMet: json['quorum_met'] as bool? ?? false,
      startBlock: json['start_block'] as int? ?? 0,
      endBlock: json['end_block'] as int? ?? 0,
      executedAt: json['executed_at'] != null
          ? DateTime.parse(json['executed_at'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'proposer': proposer,
      'title': title,
      'description': description,
      'category': category,
      'actions': actions.map((action) => action.toJson()).toList(),
      'state': state,
      'votes_for': votesFor,
      'votes_against': votesAgainst,
      'votes_abstain': votesAbstain,
      'total_votes': totalVotes,
      'quorum_met': quorumMet,
      'start_block': startBlock,
      'end_block': endBlock,
      'executed_at': executedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  GovernanceProposal copyWith({
    String? id,
    String? proposer,
    String? title,
    String? description,
    String? category,
    List<GovernanceAction>? actions,
    String? state,
    int? votesFor,
    int? votesAgainst,
    int? votesAbstain,
    int? totalVotes,
    bool? quorumMet,
    int? startBlock,
    int? endBlock,
    DateTime? executedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GovernanceProposal(
      id: id ?? this.id,
      proposer: proposer ?? this.proposer,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      actions: actions ?? this.actions,
      state: state ?? this.state,
      votesFor: votesFor ?? this.votesFor,
      votesAgainst: votesAgainst ?? this.votesAgainst,
      votesAbstain: votesAbstain ?? this.votesAbstain,
      totalVotes: totalVotes ?? this.totalVotes,
      quorumMet: quorumMet ?? this.quorumMet,
      startBlock: startBlock ?? this.startBlock,
      endBlock: endBlock ?? this.endBlock,
      executedAt: executedAt ?? this.executedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        proposer,
        title,
        description,
        category,
        actions,
        state,
        votesFor,
        votesAgainst,
        votesAbstain,
        totalVotes,
        quorumMet,
        startBlock,
        endBlock,
        executedAt,
        createdAt,
        updatedAt,
      ];
}

class GovernanceAction extends Equatable {
  final String type;
  final String target;
  final Map<String, dynamic> data;
  final String description;
  final String impact; // "low", "medium", "high", "critical"

  const GovernanceAction({
    required this.type,
    required this.target,
    required this.data,
    required this.description,
    required this.impact,
  });

  factory GovernanceAction.fromJson(Map<String, dynamic> json) {
    return GovernanceAction(
      type: json['type'] as String,
      target: json['target'] as String,
      data: json['data'] as Map<String, dynamic>? ?? {},
      description: json['description'] as String? ?? '',
      impact: json['impact'] as String? ?? 'medium',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'target': target,
      'data': data,
      'description': description,
      'impact': impact,
    };
  }

  @override
  List<Object?> get props => [type, target, data, description, impact];
}

class GovernanceVote extends Equatable {
  final String id;
  final String proposalId;
  final String voter;
  final String choice; // "for", "against", "abstain"
  final int weight;
  final String? reason;
  final DateTime timestamp;
  final bool delegated;
  final String? delegate;

  const GovernanceVote({
    required this.id,
    required this.proposalId,
    required this.voter,
    required this.choice,
    required this.weight,
    this.reason,
    required this.timestamp,
    required this.delegated,
    this.delegate,
  });

  factory GovernanceVote.fromJson(Map<String, dynamic> json) {
    return GovernanceVote(
      id: json['id'] as String,
      proposalId: json['proposal_id'] as String,
      voter: json['voter'] as String,
      choice: json['choice'] as String,
      weight: json['weight'] as int? ?? 0,
      reason: json['reason'] as String?,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
      delegated: json['delegated'] as bool? ?? false,
      delegate: json['delegate'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'proposal_id': proposalId,
      'voter': voter,
      'choice': choice,
      'weight': weight,
      'reason': reason,
      'timestamp': timestamp.toIso8601String(),
      'delegated': delegated,
      'delegate': delegate,
    };
  }

  @override
  List<Object?> get props => [
        id,
        proposalId,
        voter,
        choice,
        weight,
        reason,
        timestamp,
        delegated,
        delegate,
      ];
}
