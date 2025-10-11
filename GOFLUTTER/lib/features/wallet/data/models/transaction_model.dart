import 'package:equatable/equatable.dart';

class TransactionModel extends Equatable {
  final String hash;
  final String from;
  final String to;
  final double amount;
  final int timestamp;
  final String message;

  const TransactionModel({
    required this.hash,
    required this.from,
    required this.to,
    required this.amount,
    required this.timestamp,
    this.message = '',
  });

  @override
  List<Object> get props => [hash, from, to, amount, timestamp, message];

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      hash: json['hash'] ?? '',
      from: json['from'] ?? '',
      to: json['to'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      timestamp: json['timestamp'] ?? 0,
      message: json['message'] ?? '',
    );
  }
}
