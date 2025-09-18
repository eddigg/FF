
import 'package:equatable/equatable.dart';

class ContractModel extends Equatable {
  final String name;
  final String address;
  final String owner;
  final String version;
  final DateTime createdAt;
  final List<dynamic> functions;

  const ContractModel({
    required this.name,
    required this.address,
    required this.owner,
    required this.version,
    required this.createdAt,
    required this.functions,
  });

  @override
  List<Object> get props => [
        name,
        address,
        owner,
        version,
        createdAt,
        functions,
      ];

  factory ContractModel.fromJson(Map<String, dynamic> json) {
    return ContractModel(
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      owner: json['owner'] ?? '',
      version: json['version'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch((json['created_at'] ?? 0) * 1000),
      functions: json['functions'] ?? [],
    );
  }
}
