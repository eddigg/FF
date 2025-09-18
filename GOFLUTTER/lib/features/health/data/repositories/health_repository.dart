
import '../models/system_status_model.dart';
import '../models/health_check_model.dart';
import '../models/alert_model.dart';
import '../models/performance_trends_model.dart';
import '../models/performance_metrics_model.dart';
import '../models/test_environment_status_model.dart';
import '../models/backup_status_model.dart';
import '../models/backup_item_model.dart';

abstract class HealthRepository {
  Future<SystemStatusModel> getSystemStatus();
  Future<List<HealthCheckModel>> getHealthChecks();
  Future<List<AlertModel>> getAlerts();
  Future<PerformanceTrendsModel> getPerformanceTrends();
  Future<PerformanceMetricsModel> getPerformanceMetrics();
  Future<TestEnvironmentStatusModel> getTestEnvironmentStatus();
  Future<BackupStatusModel> getBackupStatus();
  Future<List<BackupItemModel>> getBackupHistory();
}
