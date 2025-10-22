// shared/models/wallet_model.dart
import 'package:equatable/equatable.dart';

class WalletModel extends Equatable {
  final String address;
  final double balance;
  final List<TransactionModel> transactions;

  const WalletModel({
    required this.address,
    required this.balance,
    required this.transactions,
  });

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'balance': balance,
      'transactions': transactions.map((t) => t.toJson()).toList(),
    };
  }

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      address: json['address'],
      balance: json['balance'],
      transactions: (json['transactions'] as List).map((t) => TransactionModel.fromJson(t)).toList(),
    );
  }

  @override
  List<Object> get props => [address, balance, transactions];
}

class TransactionModel extends Equatable {
  final String hash;
  final String from;
  final String to;
  final double amount;
  final DateTime timestamp;

  const TransactionModel({
    required this.hash,
    required this.from,
    required this.to,
    required this.amount,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'hash': hash,
      'from': from,
      'to': to,
      'amount': amount,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      hash: json['hash'],
      from: json['from'],
      to: json['to'],
      amount: json['amount'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  @override
  List<Object> get props => [hash, from, to, amount, timestamp];
}
