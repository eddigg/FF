
import 'package:equatable/equatable.dart';

class PerformanceTrendsModel extends Equatable {
  final String tpsTrend;
  final String memoryTrend;
  final String cpuTrend;

  const PerformanceTrendsModel({
    required this.tpsTrend,
    required this.memoryTrend,
    required this.cpuTrend,
  });

  @override
  List<Object> get props => [tpsTrend, memoryTrend, cpuTrend];

  factory PerformanceTrendsModel.fromJson(Map<String, dynamic> json) {
    return PerformanceTrendsModel(
      tpsTrend: json['tpsTrend'] ?? '',
      memoryTrend: json['memoryTrend'] ?? '',
      cpuTrend: json['cpuTrend'] ?? '',
    );
  }
}
