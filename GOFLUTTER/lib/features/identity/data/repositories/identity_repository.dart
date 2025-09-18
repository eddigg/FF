import '../models/user_profile_model.dart';
import '../models/kyc_status_model.dart';
import '../models/privacy_settings_model.dart';
import '../models/verification_option_model.dart';
import '../models/activity_model.dart';
import '../models/reputation_data_model.dart';
import '../models/activity_metrics_model.dart';

abstract class IdentityRepository {
  Future<UserProfileModel> getUserProfile();
  Future<KycStatusModel> getKycStatus();
  Future<PrivacySettingsModel> getPrivacySettings();
  Future<List<VerificationOptionModel>> getVerificationOptions();
  Future<List<ActivityModel>> getActivityHistory();
  Future<ReputationDataModel> getReputationData();
  Future<ActivityMetricsModel> getActivityMetrics();
  Future<UserProfileModel> updateUserProfile(UserProfileModel profile);
  Future<UserProfileModel> updateSocialLinks(Map<String, String> socialLinks);
  Future<KycStatusModel> submitKYC(String address, Map<String, dynamic> kycData);
  Future<KycStatusModel> checkKYCStatus(String address);
}