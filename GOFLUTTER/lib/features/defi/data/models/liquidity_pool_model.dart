
import 'package:equatable/equatable.dart';

class LiquidityPoolModel extends Equatable {
  final String name;
  final double apy;
  final double tvl;
  final double yourShare;

  const LiquidityPoolModel({
    required this.name,
    required this.apy,
    required this.tvl,
    required this.yourShare,
  });

  @override
  List<Object> get props => [name, apy, tvl, yourShare];

  factory LiquidityPoolModel.fromJson(Map<String, dynamic> json) {
    return LiquidityPoolModel(
      name: json['name'] ?? '',
      apy: (json['apy'] ?? 0.0).toDouble(),
      tvl: (json['tvl'] ?? 0.0).toDouble(),
      yourShare: (json['yourShare'] ?? 0.0).toDouble(),
    );
  }
}
