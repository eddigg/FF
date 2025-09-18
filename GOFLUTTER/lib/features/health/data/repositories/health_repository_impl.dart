
import '../models/system_status_model.dart';
import '../models/health_check_model.dart';
import '../models/alert_model.dart';
import '../models/performance_trends_model.dart';
import '../models/performance_metrics_model.dart';
import '../models/test_environment_status_model.dart';
import '../models/backup_status_model.dart';
import '../models/backup_item_model.dart';
import 'health_repository.dart';
import '../data_sources/health_api_client.dart';

class HealthRepositoryImpl implements HealthRepository {
  final HealthApiClient apiClient;

  HealthRepositoryImpl({required this.apiClient});

  @override
  Future<SystemStatusModel> getSystemStatus() async {
    final data = await apiClient.fetchSystemStatus();
    return SystemStatusModel.fromJson(data);
  }

  @override
  Future<List<HealthCheckModel>> getHealthChecks() async {
    final data = await apiClient.fetchHealthChecks();
    return data.map((item) => HealthCheckModel.fromJson(item)).toList();
  }

  @override
  Future<List<AlertModel>> getAlerts() async {
    final data = await apiClient.fetchAlerts();
    return data.map((item) => AlertModel.fromJson(item)).toList();
  }

  @override
  Future<PerformanceTrendsModel> getPerformanceTrends() async {
    final data = await apiClient.fetchPerformanceTrends();
    return PerformanceTrendsModel.fromJson(data);
  }

  @override
  Future<PerformanceMetricsModel> getPerformanceMetrics() async {
    final data = await apiClient.fetchPerformanceMetrics();
    return PerformanceMetricsModel.fromJson(data);
  }

  @override
  Future<TestEnvironmentStatusModel> getTestEnvironmentStatus() async {
    final data = await apiClient.fetchTestEnvironmentStatus();
    return TestEnvironmentStatusModel.fromJson(data);
  }

  @override
  Future<BackupStatusModel> getBackupStatus() async {
    final data = await apiClient.fetchBackupStatus();
    return BackupStatusModel.fromJson(data);
  }

  @override
  Future<List<BackupItemModel>> getBackupHistory() async {
    final data = await apiClient.fetchBackupHistory();
    return data.map((item) => BackupItemModel.fromJson(item)).toList();
  }
}
