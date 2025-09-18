
import 'package:equatable/equatable.dart';

class BackupItemModel extends Equatable {
  final String id;
  final String timestamp;
  final String size;
  final String status;

  const BackupItemModel({
    required this.id,
    required this.timestamp,
    required this.size,
    required this.status,
  });

  @override
  List<Object> get props => [id, timestamp, size, status];

  factory BackupItemModel.fromJson(Map<String, dynamic> json) {
    return BackupItemModel(
      id: json['id'] ?? '',
      timestamp: json['timestamp'] ?? '',
      size: json['size'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
