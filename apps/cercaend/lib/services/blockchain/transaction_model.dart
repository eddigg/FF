class Transaction {
  final String id;
  final String from;
  final String to;
  final double amount;
  final DateTime timestamp;
  final String status;
  final String? hash;

  Transaction({
    required this.id,
    required this.from,
    required this.to,
    required this.amount,
    required this.timestamp,
    required this.status,
    this.hash,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? '',
      from: json['from'] ?? '',
      to: json['to'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      status: json['status'] ?? 'pending',
      hash: json['hash'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'from': from,
      'to': to,
      'amount': amount,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
      'hash': hash,
    };
  }
}
