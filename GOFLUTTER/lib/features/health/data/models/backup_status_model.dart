
import 'package:equatable/equatable.dart';

class BackupStatusModel extends Equatable {
  final String status;
  final String lastBackup;
  final String nextBackup;
  final bool autoBackup;
  final int totalBackups;
  final String totalSize;
  final int verifiedBackups;
  final int corruptedBackups;

  const BackupStatusModel({
    required this.status,
    required this.lastBackup,
    required this.nextBackup,
    required this.autoBackup,
    required this.totalBackups,
    required this.totalSize,
    required this.verifiedBackups,
    required this.corruptedBackups,
  });

  @override
  List<Object> get props => [
        status,
        lastBackup,
        nextBackup,
        autoBackup,
        totalBackups,
        totalSize,
        verifiedBackups,
        corruptedBackups,
      ];

  factory BackupStatusModel.fromJson(Map<String, dynamic> json) {
    return BackupStatusModel(
      status: json['status'] ?? '',
      lastBackup: json['lastBackup'] ?? '',
      nextBackup: json['nextBackup'] ?? '',
      autoBackup: json['autoBackup'] ?? false,
      totalBackups: json['totalBackups'] ?? 0,
      totalSize: json['totalSize'] ?? '',
      verifiedBackups: json['verifiedBackups'] ?? 0,
      corruptedBackups: json['corruptedBackups'] ?? 0,
    );
  }
}
