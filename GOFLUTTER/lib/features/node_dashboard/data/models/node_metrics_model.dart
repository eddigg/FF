
import 'package:equatable/equatable.dart';

class NodeMetricsModel extends Equatable {
  final String uptime;
  final int blocksProduced;
  final int transactionsProcessed;

  const NodeMetricsModel({
    required this.uptime,
    required this.blocksProduced,
    required this.transactionsProcessed,
  });

  @override
  List<Object> get props => [uptime, blocksProduced, transactionsProcessed];

  factory NodeMetricsModel.fromJson(Map<String, dynamic> json) {
    return NodeMetricsModel(
      uptime: json['uptime'] ?? '',
      blocksProduced: json['blocksProduced'] ?? 0,
      transactionsProcessed: json['transactionsProcessed'] ?? 0,
    );
  }
}
