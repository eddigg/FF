
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';

class HealthApiClient {
  final ApiClient _apiClient;

  HealthApiClient(this._apiClient);

  Future<Map<String, dynamic>> fetchSystemStatus() async {
    try {
      final response = await _apiClient.dio.get('/monitoring/status');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch system status: $e');
    }
  }

  Future<List<dynamic>> fetchHealthChecks() async {
    try {
      final response = await _apiClient.dio.get('/monitoring/health-checks');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch health checks: $e');
    }
  }

  Future<List<dynamic>> fetchAlerts() async {
    try {
      final response = await _apiClient.dio.get('/monitoring/alerts');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch alerts: $e');
    }
  }

  Future<Map<String, dynamic>> fetchPerformanceTrends() async {
    try {
      final response = await _apiClient.dio.get('/monitoring/trends');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch performance trends: $e');
    }
  }

  Future<Map<String, dynamic>> fetchPerformanceMetrics() async {
    try {
      final response = await _apiClient.dio.get('/monitoring/metrics');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch performance metrics: $e');
    }
  }

  Future<Map<String, dynamic>> fetchTestEnvironmentStatus() async {
    try {
      final response = await _apiClient.dio.get('/test-env-status');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch test environment status: $e');
    }
  }

  Future<Map<String, dynamic>> fetchBackupStatus() async {
    try {
      final response = await _apiClient.dio.get('/backup/status');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch backup status: $e');
    }
  }

  Future<List<dynamic>> fetchBackupHistory() async {
    try {
      final response = await _apiClient.dio.get('/backup/list');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch backup history: $e');
    }
  }
}
