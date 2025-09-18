import 'package:equatable/equatable.dart';

/// Transaction entity for wallet transactions
class Transaction extends Equatable {
  final String id;
  final String from;
  final String to;
  final double amount;
  final double fee;
  final String? message;
  final DateTime timestamp;
  final TransactionStatus status;

  const Transaction({
    required this.id,
    required this.from,
    required this.to,
    required this.amount,
    required this.fee,
    this.message,
    required this.timestamp,
    required this.status,
  });

  /// Creates a copy of the transaction with updated values
  Transaction copyWith({
    String? id,
    String? from,
    String? to,
    double? amount,
    double? fee,
    String? message,
    DateTime? timestamp,
    TransactionStatus? status,
  }) {
    return Transaction(
      id: id ?? this.id,
      from: from ?? this.from,
      to: to ?? this.to,
      amount: amount ?? this.amount,
      fee: fee ?? this.fee,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
    );
  }

  /// Converts the transaction to a JSON-serializable map
  Map<String, dynamic> toJson() => {
        'id': id,
        'from': from,
        'to': to,
        'amount': amount,
        'fee': fee,
        'message': message,
        'timestamp': timestamp.toIso8601String(),
        'status': status.toString(),
      };

  /// Creates a transaction from a JSON map
  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json['id'] as String,
        from: json['from'] as String,
        to: json['to'] as String,
        amount: (json['amount'] as num).toDouble(),
        fee: (json['fee'] as num).toDouble(),
        message: json['message'] as String?,
        timestamp: DateTime.parse(json['timestamp'] as String),
        status: _parseStatus(json['status'] as String),
      );

  /// Parses a status string to a TransactionStatus enum
  static TransactionStatus _parseStatus(String status) {
    switch (status) {
      case 'TransactionStatus.pending':
        return TransactionStatus.pending;
      case 'TransactionStatus.confirmed':
        return TransactionStatus.confirmed;
      case 'TransactionStatus.failed':
        return TransactionStatus.failed;
      default:
        return TransactionStatus.pending;
    }
  }

  @override
  List<Object?> get props => [id, from, to, amount, fee, message, timestamp, status];
}

/// Enum for transaction status
enum TransactionStatus {
  pending,
  confirmed,
  failed,
}