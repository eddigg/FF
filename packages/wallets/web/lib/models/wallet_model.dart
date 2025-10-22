// Simplified wallet model for demo
class WalletModel {
  final String address;
  final double balance;
  final List<Transaction> transactions;

  WalletModel({
    required this.address,
    required this.balance,
    required this.transactions,
  });
}

class Transaction {
  final String id;
  final String type;
  final double amount;
  final DateTime timestamp;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.timestamp,
  });
}