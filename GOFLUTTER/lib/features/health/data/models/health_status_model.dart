import 'package:atlas_blockchain_flutter/features/health/domain/entities/health_status.dart';

class HealthStatusModel extends HealthStatus {
  const HealthStatusModel({
    required super.nodeStatus,
    required super.blockHeight,
    required super.lastBlockTime,
    required super.difficulty,
    required super.hashRate,
    required super.memoryUsage,
    required super.diskUsage,
    required super.cpuUsage,
    required super.networkLatency,
    required super.totalTransactions,
    required super.pendingTransactions,
  });

  factory HealthStatusModel.fromJson(Map<String, dynamic> json) {
    return HealthStatusModel(
      nodeStatus: json['nodeStatus'] as String,
      blockHeight: json['blockHeight'] as int,
      lastBlockTime: DateTime.parse(json['lastBlockTime'] as String),
      difficulty: (json['difficulty'] as num).toDouble(),
      hashRate: (json['hashRate'] as num).toDouble(),
      memoryUsage: (json['memoryUsage'] as num).toDouble(),
      diskUsage: (json['diskUsage'] as num).toDouble(),
      cpuUsage: (json['cpuUsage'] as num).toDouble(),
      networkLatency: json['networkLatency'] as int,
      totalTransactions: json['totalTransactions'] as int,
      pendingTransactions: json['pendingTransactions'] as int,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'nodeStatus': nodeStatus,
      'blockHeight': blockHeight,
      'lastBlockTime': lastBlockTime.toIso8601String(),
      'difficulty': difficulty,
      'hashRate': hashRate,
      'memoryUsage': memoryUsage,
      'diskUsage': diskUsage,
      'cpuUsage': cpuUsage,
      'networkLatency': networkLatency,
      'totalTransactions': totalTransactions,
      'pendingTransactions': pendingTransactions,
    };
  }
}
