
import 'package:equatable/equatable.dart';

class ValidatorModel extends Equatable {
  final String address;
  final double stake;
  final bool isActive;
  final String? status;
  final int? rank;
  final String? nodeMode;

  const ValidatorModel({
    required this.address,
    required this.stake,
    required this.isActive,
    this.status,
    this.rank,
    this.nodeMode,
  });

  @override
  List<Object> get props => [address, stake, isActive];

  factory ValidatorModel.fromJson(Map<String, dynamic> json) {
    return ValidatorModel(
      address: json['address'] ?? '',
      stake: (json['stake'] ?? 0.0).toDouble(),
      isActive: json['isActive'] ?? false,
      status: json['status'],
      rank: json['rank'],
      nodeMode: json['nodeMode'],
    );
  }
}
