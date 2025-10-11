import 'package:equatable/equatable.dart';

class TransactionModel extends Equatable {
  final String hash;
  final String from;
  final String to;
  final double amount;
  final double fee;
  final int timestamp;
  final int nonce;
  final String data;
  final String signature;

  const TransactionModel({
    required this.hash,
    required this.from,
    required this.to,
    required this.amount,
    required this.fee,
    required this.timestamp,
    required this.nonce,
    required this.data,
    required this.signature,
  });

  @override
  List<Object> get props => [
        hash,
        from,
        to,
        amount,
        fee,
        timestamp,
        nonce,
        data,
        signature,
      ];

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      hash: json['Hash'] ?? '',
      from: json['Sender'] ?? '',
      to: json['Recipient'] ?? '',
      amount: (json['Amount'] ?? 0.0).toDouble(),
      fee: (json['Fee'] ?? 0.0).toDouble(),
      timestamp: json['Timestamp'] ?? 0,
      nonce: json['Nonce'] ?? 0,
      data: json['Data'] ?? '',
      signature: json['Signature'] ?? '',
    );
  }
}
