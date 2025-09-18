
import 'package:equatable/equatable.dart';

class LendingPoolModel extends Equatable {
  final String name;
  final double supplyAPY;
  final double borrowAPY;
  final double totalSupply;
  final double totalBorrow;
  final int utilization;

  const LendingPoolModel({
    required this.name,
    required this.supplyAPY,
    required this.borrowAPY,
    required this.totalSupply,
    required this.totalBorrow,
    required this.utilization,
  });

  @override
  List<Object> get props => [
        name,
        supplyAPY,
        borrowAPY,
        totalSupply,
        totalBorrow,
        utilization,
      ];

  factory LendingPoolModel.fromJson(Map<String, dynamic> json) {
    return LendingPoolModel(
      name: json['name'] ?? '',
      supplyAPY: (json['supplyAPY'] ?? 0.0).toDouble(),
      borrowAPY: (json['borrowAPY'] ?? 0.0).toDouble(),
      totalSupply: (json['totalSupply'] ?? 0.0).toDouble(),
      totalBorrow: (json['totalBorrow'] ?? 0.0).toDouble(),
      utilization: json['utilization'] ?? 0,
    );
  }
}
