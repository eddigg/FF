import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../../data/repositories/dashboard_repository.dart';
import '../../data/models/dashboard_model.dart';
import '../../../../core/network/api_client.dart';

// Events
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class LoadDashboardData extends DashboardEvent {}

class RefreshDashboardData extends DashboardEvent {}

class ChangeNode extends DashboardEvent {
  final int port;

  const ChangeNode(this.port);

  @override
  List<Object> get props => [port];
}

class StartPeriodicUpdates extends DashboardEvent {}

class StopPeriodicUpdates extends DashboardEvent {}

// States
abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashboardModel dashboardModel;

  const DashboardLoaded({required this.dashboardModel});

  @override
  List<Object> get props => [dashboardModel];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository dashboardRepository;
  final ApiClient apiClient;
  Timer? _refreshTimer;

  DashboardBloc({required this.dashboardRepository, required this.apiClient}) : super(DashboardInitial()) {
    on<LoadDashboardData>(_onLoadDashboardData);
    on<RefreshDashboardData>(_onRefreshDashboardData);
    on<ChangeNode>(_onChangeNode);
    on<StartPeriodicUpdates>(_onStartPeriodicUpdates);
    on<StopPeriodicUpdates>(_onStopPeriodicUpdates);
  }

  Future<void> _onLoadDashboardData(
    LoadDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    try {
      final dashboardModel = await dashboardRepository.getDashboardData();
      emit(DashboardLoaded(dashboardModel: dashboardModel));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onRefreshDashboardData(
    RefreshDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    // Just reload the data without showing loading state to avoid UI flicker
    try {
      final dashboardModel = await dashboardRepository.getDashboardData();
      emit(DashboardLoaded(dashboardModel: dashboardModel));
    } catch (e) {
      // Only emit error if we were previously in a loaded state
      if (state is DashboardLoaded) {
        emit(DashboardError(e.toString()));
      }
    }
  }

  Future<void> _onChangeNode(
    ChangeNode event,
    Emitter<DashboardState> emit,
  ) async {
    apiClient.updateBaseUrl('http://localhost:${event.port}');
    
    // Save the selected port to shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedNodePort', event.port);
    
    // Reload data after changing node
    await _onLoadDashboardData(LoadDashboardData(), emit);
  }

  Future<void> _onStartPeriodicUpdates(
    StartPeriodicUpdates event,
    Emitter<DashboardState> emit,
  ) async {
    // Cancel any existing timer
    _refreshTimer?.cancel();
    
    // Start periodic updates every 10 seconds
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      add(RefreshDashboardData());
    });
  }

  Future<void> _onStopPeriodicUpdates(
    StopPeriodicUpdates event,
    Emitter<DashboardState> emit,
  ) async {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  @override
  Future<void> close() {
    _refreshTimer?.cancel();
    return super.close();
  }
}
