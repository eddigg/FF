import 'package:equatable/equatable.dart';

class AssetModel extends Equatable {
  final String symbol;
  final String name;
  final double amount;
  final double value;
  final double change;

  const AssetModel({
    required this.symbol,
    required this.name,
    required this.amount,
    required this.value,
    required this.change,
  });

  @override
  List<Object> get props => [
        symbol,
        name,
        amount,
        value,
        change,
      ];

  factory AssetModel.fromJson(Map<String, dynamic> json) {
    return AssetModel(
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      value: (json['value'] ?? 0.0).toDouble(),
      change: (json['change'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'name': name,
      'amount': amount,
      'value': value,
      'change': change,
    };
  }
}
