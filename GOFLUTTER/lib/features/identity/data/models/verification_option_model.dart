
import 'package:equatable/equatable.dart';

class VerificationOptionModel extends Equatable {
  final String name;
  final String status;
  final String icon;

  const VerificationOptionModel({
    required this.name,
    required this.status,
    required this.icon,
  });

  @override
  List<Object> get props => [name, status, icon];

  factory VerificationOptionModel.fromJson(Map<String, dynamic> json) {
    return VerificationOptionModel(
      name: json['name'] ?? '',
      status: json['status'] ?? '',
      icon: json['icon'] ?? '',
    );
  }
}
