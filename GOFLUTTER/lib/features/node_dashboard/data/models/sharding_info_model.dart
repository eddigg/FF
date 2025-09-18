
import 'package:equatable/equatable.dart';

class ShardingInfoModel extends Equatable {
  final String shardOverview;
  final String validatorAssignment;
  final String crossShardTransactions;
  final String shardStatistics;

  const ShardingInfoModel({
    required this.shardOverview,
    required this.validatorAssignment,
    required this.crossShardTransactions,
    required this.shardStatistics,
  });

  @override
  List<Object> get props => [
        shardOverview,
        validatorAssignment,
        crossShardTransactions,
        shardStatistics,
      ];

  factory ShardingInfoModel.fromJson(Map<String, dynamic> json) {
    return ShardingInfoModel(
      shardOverview: json['shardOverview'] ?? '',
      validatorAssignment: json['validatorAssignment'] ?? '',
      crossShardTransactions: json['crossShardTransactions'] ?? '',
      shardStatistics: json['shardStatistics'] ?? '',
    );
  }
}
