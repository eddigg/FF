import 'package:atlas_blockchain_flutter/features/identity/domain/entities/user_identity.dart';

class AttestationModel extends Attestation {
  const AttestationModel({
    required super.id,
    required super.attester,
    required super.subject,
    required super.claim,
    required super.data,
    required super.issuedAt,
    required super.expiresAt,
    required super.isValid,
  });

  factory AttestationModel.fromJson(Map<String, dynamic> json) {
    return AttestationModel(
      id: json['id'] as String,
      attester: json['attester'] as String,
      subject: json['subject'] as String,
      claim: json['claim'] as String,
      data: json['data'] as Map<String, dynamic>,
      issuedAt: DateTime.parse(json['issued_at'] as String),
      expiresAt: DateTime.parse(json['expires_at'] as String),
      isValid: json['is_valid'] as bool,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attester': attester,
      'subject': subject,
      'claim': claim,
      'data': data,
      'issued_at': issuedAt.toIso8601String(),
      'expires_at': expiresAt.toIso8601String(),
      'is_valid': isValid,
    };
  }
}
