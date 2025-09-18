import 'package:atlas_blockchain_flutter/features/identity/domain/entities/user_identity.dart';

class CredentialModel extends Credential {
  const CredentialModel({
    required super.id,
    required super.type,
    required super.issuer,
    required super.subject,
    required super.data,
    required super.issuedAt,
    required super.isRevoked,
  });

  factory CredentialModel.fromJson(Map<String, dynamic> json) {
    return CredentialModel(
      id: json['id'] as String,
      type: json['type'] as String,
      issuer: json['issuer'] as String,
      subject: json['subject'] as String,
      data: json['data'] as Map<String, dynamic>,
      issuedAt: DateTime.parse(json['issued_at'] as String),
      isRevoked: json['is_revoked'] as bool,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'issuer': issuer,
      'subject': subject,
      'data': data,
      'issued_at': issuedAt.toIso8601String(),
      'is_revoked': isRevoked,
    };
  }
}