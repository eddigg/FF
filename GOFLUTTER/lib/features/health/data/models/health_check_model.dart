
import 'package:equatable/equatable.dart';

class HealthCheckModel extends Equatable {
  final String name;
  final String status;
  final String message;

  const HealthCheckModel({
    required this.name,
    required this.status,
    required this.message,
  });

  @override
  List<Object> get props => [name, status, message];

  factory HealthCheckModel.fromJson(Map<String, dynamic> json) {
    return HealthCheckModel(
      name: json['name'] ?? '',
      status: json['status'] ?? '',
      message: json['message'] ?? '',
    );
  }
}
