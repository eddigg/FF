
import 'package:equatable/equatable.dart';
import 'transaction_model.dart';

class WalletModel extends Equatable {
  final String address;
  final double balance;
  final List<TransactionModel> transactions;

  const WalletModel({
    required this.address,
    required this.balance,
    required this.transactions,
  });

  @override
  List<Object> get props => [address, balance, transactions];

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      address: json['address'] ?? '',
      balance: (json['balance'] ?? 0.0).toDouble(),
      transactions: (json['transactions'] as List?)
              ?.map((item) => TransactionModel.fromJson(item))
              .toList() ??
          [],
    );
  }
}
