import 'package:atlas_blockchain_flutter/features/identity/data/models/user_profile_model.dart';
import 'package:atlas_blockchain_flutter/features/identity/data/models/credential_model.dart';
import 'package:atlas_blockchain_flutter/features/identity/data/models/attestation_model.dart';
import 'package:atlas_blockchain_flutter/features/identity/data/models/privacy_settings_model.dart';
import 'package:atlas_blockchain_flutter/features/identity/data/models/kyc_info_model.dart';
import 'package:atlas_blockchain_flutter/features/identity/data/models/reputation_score_model.dart';
import 'package:atlas_blockchain_flutter/features/identity/data/models/activity_metrics_model.dart';
import 'package:equatable/equatable.dart';

class UserIdentityModel extends Equatable {
  final String address;
  final String username;
  final String email;
  final UserProfileModel profile;
  final List<CredentialModel> credentials;
  final List<AttestationModel> attestations;
  final PrivacySettingsModel privacySettings;
  final KYCInfoModel kyc;
  final ReputationScoreModel reputation;
  final ActivityMetricsModel activity;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  const UserIdentityModel({
    required this.address,
    required this.username,
    required this.email,
    required this.profile,
    required this.credentials,
    required this.attestations,
    required this.privacySettings,
    required this.kyc,
    required this.reputation,
    required this.activity,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
  });

  factory UserIdentityModel.fromJson(Map<String, dynamic> json) {
    var credentialsList = json['credentials'] as List?;
    List<CredentialModel> credentials = credentialsList != null
        ? credentialsList.map((c) => CredentialModel.fromJson(c)).toList()
        : [];

    var attestationsList = json['attestations'] as List?;
    List<AttestationModel> attestations = attestationsList != null
        ? attestationsList.map((a) => AttestationModel.fromJson(a)).toList()
        : [];

    return UserIdentityModel(
      address: json['address'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      profile: UserProfileModel.fromJson(json['profile']),
      credentials: credentials,
      attestations: attestations,
      privacySettings: PrivacySettingsModel.fromJson(json['privacy_settings']),
      kyc: KYCInfoModel.fromJson(json['kyc']),
      reputation: ReputationScoreModel.fromJson(json['reputation']),
      activity: ActivityMetricsModel.fromJson(json['activity']),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      isActive: json['is_active'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'username': username,
      'email': email,
      'profile': profile.toJson(),
      'credentials': credentials.map((c) => c.toJson()).toList(),
      'attestations': attestations.map((a) => a.toJson()).toList(),
      'privacy_settings': privacySettings.toJson(),
      'kyc': kyc.toJson(),
      'reputation': reputation.toJson(),
      'activity': activity.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_active': isActive,
    };
  }

  @override
  List<Object?> get props => [
        address,
        username,
        email,
        profile,
        credentials,
        attestations,
        privacySettings,
        kyc,
        reputation,
        activity,
        createdAt,
        updatedAt,
        isActive,
      ];
}
