import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/system_status_model.dart';
import '../../data/models/health_check_model.dart';
import '../../data/models/alert_model.dart';
import '../../data/models/performance_trends_model.dart';
import '../../data/models/performance_metrics_model.dart';
import '../../data/models/test_environment_status_model.dart';
import '../../data/models/backup_status_model.dart';
import '../../data/models/backup_item_model.dart';
import '../../data/repositories/health_repository_impl.dart';

// Events
abstract class HealthEvent extends Equatable {
  const HealthEvent();

  @override
  List<Object> get props => [];
}

class LoadHealthData extends HealthEvent {}

class RefreshHealthData extends HealthEvent {}

// States
abstract class HealthState extends Equatable {
  const HealthState();

  @override
  List<Object> get props => [];
}

class HealthInitial extends HealthState {}

class HealthLoading extends HealthState {}

class HealthLoaded extends HealthState {
  final SystemStatusModel systemStatus;
  final List<HealthCheckModel> healthChecks;
  final List<AlertModel> alerts;
  final PerformanceTrendsModel performanceTrends;
  final PerformanceMetricsModel performanceMetrics;
  final TestEnvironmentStatusModel testEnvironmentStatus;
  final BackupStatusModel backupStatus;
  final List<BackupItemModel> backupHistory;

  const HealthLoaded({
    required this.systemStatus,
    required this.healthChecks,
    required this.alerts,
    required this.performanceTrends,
    required this.performanceMetrics,
    required this.testEnvironmentStatus,
    required this.backupStatus,
    required this.backupHistory,
  });

  @override
  List<Object> get props => [
        systemStatus,
        healthChecks,
        alerts,
        performanceTrends,
        performanceMetrics,
        testEnvironmentStatus,
        backupStatus,
        backupHistory,
      ];
}

class HealthError extends HealthState {
  final String message;

  const HealthError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class HealthBloc extends Bloc<HealthEvent, HealthState> {
  final HealthRepositoryImpl healthRepository;

  HealthBloc({required this.healthRepository}) : super(HealthInitial()) {
    on<LoadHealthData>(_onLoadHealthData);
    on<RefreshHealthData>(_onRefreshHealthData);
  }

  Future<void> _onLoadHealthData(
    LoadHealthData event,
    Emitter<HealthState> emit,
  ) async {
    emit(HealthLoading());
    try {
      // Fetch all health data from repository
      final systemStatus = await healthRepository.getSystemStatus();
      final healthChecks = await healthRepository.getHealthChecks();
      final alerts = await healthRepository.getAlerts();
      final performanceTrends = await healthRepository.getPerformanceTrends();
      final performanceMetrics = await healthRepository.getPerformanceMetrics();
      final testEnvironmentStatus = await healthRepository.getTestEnvironmentStatus();
      final backupStatus = await healthRepository.getBackupStatus();
      final backupHistory = await healthRepository.getBackupHistory();

      emit(HealthLoaded(
        systemStatus: systemStatus,
        healthChecks: healthChecks,
        alerts: alerts,
        performanceTrends: performanceTrends,
        performanceMetrics: performanceMetrics,
        testEnvironmentStatus: testEnvironmentStatus,
        backupStatus: backupStatus,
        backupHistory: backupHistory,
      ));
    } catch (e) {
      emit(HealthError(e.toString()));
    }
  }

  Future<void> _onRefreshHealthData(
    RefreshHealthData event,
    Emitter<HealthState> emit,
  ) async {
    // Just reload all data
    add(LoadHealthData());
  }
}