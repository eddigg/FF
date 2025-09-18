
import 'package:equatable/equatable.dart';

class TestEnvironmentStatusModel extends Equatable {
  final int nodes;
  final int wallets;
  final int transactions;
  final int blocks;

  const TestEnvironmentStatusModel({
    required this.nodes,
    required this.wallets,
    required this.transactions,
    required this.blocks,
  });

  @override
  List<Object> get props => [nodes, wallets, transactions, blocks];

  factory TestEnvironmentStatusModel.fromJson(Map<String, dynamic> json) {
    return TestEnvironmentStatusModel(
      nodes: json['nodes'] ?? 0,
      wallets: json['wallets'] ?? 0,
      transactions: json['transactions'] ?? 0,
      blocks: json['blocks'] ?? 0,
    );
  }
}
