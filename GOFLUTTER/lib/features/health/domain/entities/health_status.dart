import 'package:equatable/equatable.dart';

class HealthStatus extends Equatable {
  final String nodeStatus;
  final int blockHeight;
  final DateTime lastBlockTime;
  final double difficulty;
  final double hashRate;
  final double memoryUsage;
  final double diskUsage;
  final double cpuUsage;
  final int networkLatency;
  final int totalTransactions;
  final int pendingTransactions;

  const HealthStatus({
    required this.nodeStatus,
    required this.blockHeight,
    required this.lastBlockTime,
    required this.difficulty,
    required this.hashRate,
    required this.memoryUsage,
    required this.diskUsage,
    required this.cpuUsage,
    required this.networkLatency,
    required this.totalTransactions,
    required this.pendingTransactions,
  });

  factory HealthStatus.fromJson(Map<String, dynamic> json) {
    return HealthStatus(
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

  HealthStatus copyWith({
    String? nodeStatus,
    int? blockHeight,
    DateTime? lastBlockTime,
    double? difficulty,
    double? hashRate,
    double? memoryUsage,
    double? diskUsage,
    double? cpuUsage,
    int? networkLatency,
    int? totalTransactions,
    int? pendingTransactions,
  }) {
    return HealthStatus(
      nodeStatus: nodeStatus ?? this.nodeStatus,
      blockHeight: blockHeight ?? this.blockHeight,
      lastBlockTime: lastBlockTime ?? this.lastBlockTime,
      difficulty: difficulty ?? this.difficulty,
      hashRate: hashRate ?? this.hashRate,
      memoryUsage: memoryUsage ?? this.memoryUsage,
      diskUsage: diskUsage ?? this.diskUsage,
      cpuUsage: cpuUsage ?? this.cpuUsage,
      networkLatency: networkLatency ?? this.networkLatency,
      totalTransactions: totalTransactions ?? this.totalTransactions,
      pendingTransactions: pendingTransactions ?? this.pendingTransactions,
    );
  }

  @override
  List<Object?> get props => [
        nodeStatus,
        blockHeight,
        lastBlockTime,
        difficulty,
        hashRate,
        memoryUsage,
        diskUsage,
        cpuUsage,
        networkLatency,
        totalTransactions,
        pendingTransactions,
      ];
}