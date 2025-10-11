import 'package:atlas_blockchain_flutter/features/identity/domain/entities/user_identity.dart';

class KYCInfoModel extends KYCInfo {
  const KYCInfoModel({
    required super.level,
    required super.verified,
    super.verificationDate,
    required super.documents,
  });

  factory KYCInfoModel.fromJson(Map<String, dynamic> json) {
    var documentsList = json['documents'] as List?;
    List<String> documents = documentsList != null
        ? documentsList.map((d) => d as String).toList()
        : [];

    return KYCInfoModel(
      level: json['level'] as String,
      verified: json['verified'] as bool,
      verificationDate: json['verification_date'] != null
          ? DateTime.parse(json['verification_date'] as String)
          : null,
      documents: documents,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'verified': verified,
      'verification_date':
          verificationDate?.toIso8601String(),
      'documents': documents,
    };
  }
}
