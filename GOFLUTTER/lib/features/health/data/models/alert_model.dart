
import 'package:equatable/equatable.dart';

class AlertModel extends Equatable {
  final String message;
  final String level;
  final String timestamp;

  const AlertModel({
    required this.message,
    required this.level,
    required this.timestamp,
  });

  @override
  List<Object> get props => [message, level, timestamp];

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      message: json['message'] ?? '',
      level: json['level'] ?? '',
      timestamp: json['timestamp'] ?? '',
    );
  }
}
