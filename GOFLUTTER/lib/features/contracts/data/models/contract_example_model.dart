
import 'package:equatable/equatable.dart';

class ContractExampleModel extends Equatable {
  final String name;
  final String description;
  final String? code;

  const ContractExampleModel({
    required this.name,
    required this.description,
    this.code,
  });

  @override
  List<Object> get props => [name, description];

  factory ContractExampleModel.fromJson(Map<String, dynamic> json) {
    return ContractExampleModel(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      code: json['code'],
    );
  }
}
