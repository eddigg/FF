
import 'package:equatable/equatable.dart';

class StakingOptionModel extends Equatable {
  final String id;
  final String name;
  final String reward;
  final String period;
  final int minStake;

  const StakingOptionModel({
    required this.id,
    required this.name,
    required this.reward,
    required this.period,
    required this.minStake,
  });

  @override
  List<Object> get props => [id, name, reward, period, minStake];

  factory StakingOptionModel.fromJson(Map<String, dynamic> json) {
    return StakingOptionModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      reward: json['reward'] ?? '',
      period: json['period'] ?? '',
      minStake: json['minStake'] ?? 0,
    );
  }
}
