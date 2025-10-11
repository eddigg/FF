import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';

class IdentityApiClient {
  final ApiClient _apiClient;

  IdentityApiClient(this._apiClient);

  Future<Map<String, dynamic>> fetchUserProfile() async {
    try {
      final response = await _apiClient.dio.get('/identity/profile');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch user profile: $e');
    }
  }

  Future<Map<String, dynamic>> fetchKycStatus() async {
    try {
      final response = await _apiClient.dio.get('/identity/kyc');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch KYC status: $e');
    }
  }

  Future<Map<String, dynamic>> fetchPrivacySettings() async {
    try {
      final response = await _apiClient.dio.get('/identity/privacy');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch privacy settings: $e');
    }
  }

  Future<List<dynamic>> fetchVerificationOptions() async {
    try {
      final response = await _apiClient.dio.get('/identity/verification');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch verification options: $e');
    }
  }

  Future<List<dynamic>> fetchActivityHistory() async {
    try {
      final response = await _apiClient.dio.get('/identity/activity');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch activity history: $e');
    }
  }

  Future<Map<String, dynamic>> fetchReputationData() async {
    try {
      final response = await _apiClient.dio.get('/identity/reputation');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch reputation data: $e');
    }
  }

  Future<Map<String, dynamic>> fetchActivityMetrics() async {
    try {
      final response = await _apiClient.dio.get('/identity/activity/metrics');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch activity metrics: $e');
    }
  }

  Future<Map<String, dynamic>> updateUserProfile(Map<String, dynamic> profileData) async {
    try {
      final response = await _apiClient.dio.put(
        '/identity/profile',
        data: profileData,
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  Future<Map<String, dynamic>> updateSocialLinks(Map<String, String> socialLinks) async {
    try {
      final response = await _apiClient.dio.put(
        '/identity/social-links',
        data: socialLinks,
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to update social links: $e');
    }
  }

  Future<Map<String, dynamic>> submitKYC(String address, Map<String, dynamic> kycData) async {
    try {
      final response = await _apiClient.dio.post(
        '/identity/kyc',
        data: {
          'address': address,
          'kycData': kycData,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to submit KYC: $e');
    }
  }

  Future<Map<String, dynamic>> checkKYCStatus(String address) async {
    try {
      final response = await _apiClient.dio.get('/identity/kyc/$address');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to check KYC status: $e');
    }
  }
}
