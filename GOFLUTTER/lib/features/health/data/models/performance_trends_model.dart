
import 'package:equatable/equatable.dart';

class PerformanceTrendsModel extends Equatable {
  final String tpsTrend;
  final String memoryTrend;
  final String cpuTrend;
  // Add dataPoints field as expected by UI
  final int dataPoints;

  const PerformanceTrendsModel({
    required this.tpsTrend,
    required this.memoryTrend,
    required this.cpuTrend,
    this.dataPoints = 0,
  });

  @override
  List<Object> get props => [tpsTrend, memoryTrend, cpuTrend, dataPoints];

  factory PerformanceTrendsModel.fromJson(Map<String, dynamic> json) {
    return PerformanceTrendsModel(
      tpsTrend: json['tpsTrend'] ?? '',
      memoryTrend: json['memoryTrend'] ?? '',
      cpuTrend: json['cpuTrend'] ?? '',
    );
  }
}
