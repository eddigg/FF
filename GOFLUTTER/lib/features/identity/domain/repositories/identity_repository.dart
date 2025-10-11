import 'package:atlas_blockchain_flutter/features/identity/domain/entities/user_identity.dart';

abstract class IdentityRepository {
  Future<UserIdentity> getIdentity(String address);
  Future<UserIdentity> updateProfile(String address, Map<String, dynamic> profileData);
  Future<UserIdentity> updatePrivacySettings(String address, Map<String, dynamic> privacyData);
  Future<bool> verifyIdentity(String address, Map<String, dynamic> verificationData);
  Future<bool> submitKYC(String address, Map<String, dynamic> kycData);
}
