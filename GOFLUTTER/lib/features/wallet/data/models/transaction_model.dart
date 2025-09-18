
import 'package:equatable/equatable.dart';

class TransactionModel extends Equatable {
  final String hash;
  final String from;
  final String to;
  final double amount;
  final int timestamp;

  const TransactionModel({
    required this.hash,
    required this.from,
    required this.to,
    required this.amount,
    required this.timestamp,
  });

  @override
  List<Object> get props => [hash, from, to, amount, timestamp];

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      hash: json['hash'] ?? '',
      from: json['from'] ?? '',
      to: json['to'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      timestamp: json['timestamp'] ?? 0,
    );
  }
}
