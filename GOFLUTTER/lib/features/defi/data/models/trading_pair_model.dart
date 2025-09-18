
import 'package:equatable/equatable.dart';

class TradingPairModel extends Equatable {
  final String symbol;
  final double price;
  final double change;
  final double volume;

  const TradingPairModel({
    required this.symbol,
    required this.price,
    required this.change,
    required this.volume,
  });

  @override
  List<Object> get props => [symbol, price, change, volume];

  factory TradingPairModel.fromJson(Map<String, dynamic> json) {
    return TradingPairModel(
      symbol: json['symbol'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      change: (json['change'] ?? 0.0).toDouble(),
      volume: (json['volume'] ?? 0.0).toDouble(),
    );
  }
}
