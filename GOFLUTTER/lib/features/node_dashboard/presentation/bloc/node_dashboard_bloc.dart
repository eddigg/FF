import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/node_metrics_model.dart';
import '../../data/models/validator_model.dart';
import '../../data/models/network_stats_model.dart';
import '../../data/models/sharding_info_model.dart';
import '../../data/repositories/node_dashboard_repository.dart';

// Events
abstract class NodeDashboardEvent extends Equatable {
  const NodeDashboardEvent();

  @override
  List<Object> get props => [];
}

class LoadNodeDashboardData extends NodeDashboardEvent {}

// States
abstract class NodeDashboardState extends Equatable {
  const NodeDashboardState();

  @override
  List<Object> get props => [];
}

class NodeDashboardInitial extends NodeDashboardState {}

class NodeDashboardLoading extends NodeDashboardState {}

class NodeDashboardLoaded extends NodeDashboardState {
  final NodeMetricsModel nodeMetrics;
  final List<ValidatorModel> validators;
  final NetworkStatsModel networkStats;
  final ValidatorModel validatorInfo;
  final ShardingInfoModel shardingInfo;
  final List<dynamic> peers; // Peer information for monitoring
  final List<String> nodeLogs; // Node operation logs

  const NodeDashboardLoaded({
    required this.nodeMetrics,
    required this.validators,
    required this.networkStats,
    required this.validatorInfo,
    required this.shardingInfo,
    this.peers = const [], // Default empty list
    this.nodeLogs = const [], // Default empty list
  });

  @override
  List<Object> get props => [
        nodeMetrics,
        validators,
        networkStats,
        validatorInfo,
        shardingInfo,
        peers,
        nodeLogs,
      ];
}

class NodeDashboardError extends NodeDashboardState {
  final String message;

  const NodeDashboardError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class NodeDashboardBloc extends Bloc<NodeDashboardEvent, NodeDashboardState> {
  final NodeDashboardRepository nodeDashboardRepository;

  NodeDashboardBloc({required this.nodeDashboardRepository}) : super(NodeDashboardInitial()) {
    on<LoadNodeDashboardData>(_onLoadNodeDashboardData);
  }

  Future<void> _onLoadNodeDashboardData(
    LoadNodeDashboardData event,
    Emitter<NodeDashboardState> emit,
  ) async {
    emit(NodeDashboardLoading());
    try {
      final nodeMetrics = await nodeDashboardRepository.getNodeMetrics();
      final validators = await nodeDashboardRepository.getValidators();
      final networkStats = await nodeDashboardRepository.getNetworkStats();
      final validatorInfo = await nodeDashboardRepository.getValidatorInfo();
      final shardingInfo = await nodeDashboardRepository.getShardingInfo();

      emit(NodeDashboardLoaded(
        nodeMetrics: nodeMetrics,
        validators: validators,
        networkStats: networkStats,
        validatorInfo: validatorInfo,
        shardingInfo: shardingInfo,
      ));
    } catch (e) {
      emit(NodeDashboardError(e.toString()));
    }
  }
}
