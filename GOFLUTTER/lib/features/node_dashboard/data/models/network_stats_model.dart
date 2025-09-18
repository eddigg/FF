
import 'package:equatable/equatable.dart';

class NetworkStatsModel extends Equatable {
  final int totalValidators;
  final String networkHashRate;
  final String avgBlockTime;
  final String networkDifficulty;

  const NetworkStatsModel({
    required this.totalValidators,
    required this.networkHashRate,
    required this.avgBlockTime,
    required this.networkDifficulty,
  });

  @override
  List<Object> get props => [
        totalValidators,
        networkHashRate,
        avgBlockTime,
        networkDifficulty,
      ];

  factory NetworkStatsModel.fromJson(Map<String, dynamic> json) {
    return NetworkStatsModel(
      totalValidators: json['totalValidators'] ?? 0,
      networkHashRate: json['networkHashRate'] ?? '',
      avgBlockTime: json['avgBlockTime'] ?? '',
      networkDifficulty: json['networkDifficulty'] ?? '',
    );
  }
}
