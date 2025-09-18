
import 'package:equatable/equatable.dart';

class YieldFarmModel extends Equatable {
  final String name;
  final double apy;
  final String reward;
  final double tvl;

  const YieldFarmModel({
    required this.name,
    required this.apy,
    required this.reward,
    required this.tvl,
  });

  @override
  List<Object> get props => [name, apy, reward, tvl];

  factory YieldFarmModel.fromJson(Map<String, dynamic> json) {
    return YieldFarmModel(
      name: json['name'] ?? '',
      apy: (json['apy'] ?? 0.0).toDouble(),
      reward: json['reward'] ?? '',
      tvl: (json['tvl'] ?? 0.0).toDouble(),
    );
  }
}
