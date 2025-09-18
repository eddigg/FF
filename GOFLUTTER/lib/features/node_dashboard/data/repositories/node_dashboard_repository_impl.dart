
import '../models/node_metrics_model.dart';
import '../models/validator_model.dart';
import '../models/network_stats_model.dart';
import '../models/sharding_info_model.dart';
import 'node_dashboard_repository.dart';
import '../data_sources/node_dashboard_api_client.dart';

class NodeDashboardRepositoryImpl implements NodeDashboardRepository {
  final NodeDashboardApiClient apiClient;

  NodeDashboardRepositoryImpl({required this.apiClient});

  @override
  Future<NodeMetricsModel> getNodeMetrics() async {
    final data = await apiClient.fetchNodeMetrics();
    return NodeMetricsModel.fromJson(data);
  }

  @override
  Future<List<ValidatorModel>> getValidators() async {
    final data = await apiClient.fetchValidators();
    return data.map((item) => ValidatorModel.fromJson(item)).toList();
  }

  @override
  Future<NetworkStatsModel> getNetworkStats() async {
    final data = await apiClient.fetchNetworkStats();
    return NetworkStatsModel.fromJson(data);
  }

  @override
  Future<ValidatorModel> getValidatorInfo() async {
    final data = await apiClient.fetchValidatorInfo();
    return ValidatorModel.fromJson(data);
  }

  @override
  Future<ShardingInfoModel> getShardingInfo() async {
    final data = await apiClient.fetchShardingInfo();
    return ShardingInfoModel.fromJson(data);
  }
}
