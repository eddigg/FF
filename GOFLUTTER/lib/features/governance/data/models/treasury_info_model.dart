
import 'package:equatable/equatable.dart';

class TreasuryInfoModel extends Equatable {
  final double balance;
  final int pendingProposals;
  final int executedThisMonth;

  const TreasuryInfoModel({
    required this.balance,
    required this.pendingProposals,
    required this.executedThisMonth,
  });

  @override
  List<Object> get props => [balance, pendingProposals, executedThisMonth];

  factory TreasuryInfoModel.fromJson(Map<String, dynamic> json) {
    return TreasuryInfoModel(
      balance: (json['balance'] ?? 0.0).toDouble(),
      pendingProposals: json['pendingProposals'] ?? 0,
      executedThisMonth: json['executedThisMonth'] ?? 0,
    );
  }
}
