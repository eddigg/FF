
import 'package:equatable/equatable.dart';

class PerformanceMetricsModel extends Equatable {
  final int tps;
  final int blockTime;
  final int memoryUsage;
  final int cpuUsage;
  final int networkLatency;
  final int activePeers;
  final int validatorCount;
  final int pendingTransactions;
  final int blockHeight;
  final int totalStaked;
  final int avgBlockSize;
  final int gasPrice;
  final int contractCount;

  const PerformanceMetricsModel({
    required this.tps,
    required this.blockTime,
    required this.memoryUsage,
    required this.cpuUsage,
    required this.networkLatency,
    required this.activePeers,
    required this.validatorCount,
    required this.pendingTransactions,
    required this.blockHeight,
    required this.totalStaked,
    required this.avgBlockSize,
    required this.gasPrice,
    required this.contractCount,
  });

  @override
  List<Object> get props => [
        tps,
        blockTime,
        memoryUsage,
        cpuUsage,
        networkLatency,
        activePeers,
        validatorCount,
        pendingTransactions,
        blockHeight,
        totalStaked,
        avgBlockSize,
        gasPrice,
        contractCount,
      ];

  factory PerformanceMetricsModel.fromJson(Map<String, dynamic> json) {
    return PerformanceMetricsModel(
      tps: json['tps'] ?? 0,
      blockTime: json['blockTime'] ?? 0,
      memoryUsage: json['memoryUsage'] ?? 0,
      cpuUsage: json['cpuUsage'] ?? 0,
      networkLatency: json['networkLatency'] ?? 0,
      activePeers: json['activePeers'] ?? 0,
      validatorCount: json['validatorCount'] ?? 0,
      pendingTransactions: json['pendingTransactions'] ?? 0,
      blockHeight: json['blockHeight'] ?? 0,
      totalStaked: json['totalStaked'] ?? 0,
      avgBlockSize: json['avgBlockSize'] ?? 0,
      gasPrice: json['gasPrice'] ?? 0,
      contractCount: json['contractCount'] ?? 0,
    );
  }
}
