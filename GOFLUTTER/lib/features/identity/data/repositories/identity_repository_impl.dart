import '../models/user_profile_model.dart';
import '../models/kyc_status_model.dart';
import '../models/privacy_settings_model.dart';
import '../models/verification_option_model.dart';
import '../models/activity_model.dart';
import '../models/reputation_data_model.dart';
import '../models/activity_metrics_model.dart';
import 'identity_repository.dart';
import '../data_sources/identity_api_client.dart';

class IdentityRepositoryImpl implements IdentityRepository {
  final IdentityApiClient apiClient;

  IdentityRepositoryImpl({required this.apiClient});

  @override
  Future<UserProfileModel> getUserProfile() async {
    final data = await apiClient.fetchUserProfile();
    return UserProfileModel.fromJson(data);
  }

  @override
  Future<KycStatusModel> getKycStatus() async {
    final data = await apiClient.fetchKycStatus();
    return KycStatusModel.fromJson(data);
  }

  @override
  Future<PrivacySettingsModel> getPrivacySettings() async {
    final data = await apiClient.fetchPrivacySettings();
    return PrivacySettingsModel.fromJson(data);
  }

  @override
  Future<List<VerificationOptionModel>> getVerificationOptions() async {
    final data = await apiClient.fetchVerificationOptions();
    return data.map((item) => VerificationOptionModel.fromJson(item)).toList();
  }

  @override
  Future<List<ActivityModel>> getActivityHistory() async {
    final data = await apiClient.fetchActivityHistory();
    return data.map((item) => ActivityModel.fromJson(item)).toList();
  }

  @override
  Future<ReputationDataModel> getReputationData() async {
    final data = await apiClient.fetchReputationData();
    return ReputationDataModel.fromJson(data);
  }

  @override
  Future<ActivityMetricsModel> getActivityMetrics() async {
    final data = await apiClient.fetchActivityMetrics();
    return ActivityMetricsModel.fromJson(data);
  }

  @override
  Future<UserProfileModel> updateUserProfile(UserProfileModel profile) async {
    final data = await apiClient.updateUserProfile(profile.toJson());
    return UserProfileModel.fromJson(data);
  }

  @override
  Future<UserProfileModel> updateSocialLinks(Map<String, String> socialLinks) async {
    final data = await apiClient.updateSocialLinks(socialLinks);
    return UserProfileModel.fromJson(data);
  }

  @override
  Future<KycStatusModel> submitKYC(String address, Map<String, dynamic> kycData) async {
    final data = await apiClient.submitKYC(address, kycData);
    return KycStatusModel.fromJson(data);
  }

  @override
  Future<KycStatusModel> checkKYCStatus(String address) async {
    final data = await apiClient.checkKYCStatus(address);
    return KycStatusModel.fromJson(data);
  }
}