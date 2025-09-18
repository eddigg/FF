
import 'package:equatable/equatable.dart';

class SystemStatusModel extends Equatable {
  final String uptime;
  final String version;
  final int totalBlocks;
  final int totalTransactions;
  final int activeValidators;
  final int poolSize;
  final String connectionStatus;

  const SystemStatusModel({
    required this.uptime,
    required this.version,
    required this.totalBlocks,
    required this.totalTransactions,
    required this.activeValidators,
    required this.poolSize,
    required this.connectionStatus,
  });

  @override
  List<Object> get props => [
        uptime,
        version,
        totalBlocks,
        totalTransactions,
        activeValidators,
        poolSize,
        connectionStatus,
      ];

  factory SystemStatusModel.fromJson(Map<String, dynamic> json) {
    return SystemStatusModel(
      uptime: json['uptime'] ?? '',
      version: json['version'] ?? '',
      totalBlocks: json['totalBlocks'] ?? 0,
      totalTransactions: json['totalTransactions'] ?? 0,
      activeValidators: json['activeValidators'] ?? 0,
      poolSize: json['poolSize'] ?? 0,
      connectionStatus: json['connectionStatus'] ?? '',
    );
  }
}
