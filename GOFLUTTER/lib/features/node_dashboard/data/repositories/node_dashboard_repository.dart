
import '../models/node_metrics_model.dart';
import '../models/validator_model.dart';
import '../models/network_stats_model.dart';
import '../models/sharding_info_model.dart';

abstract class NodeDashboardRepository {
  Future<NodeMetricsModel> getNodeMetrics();
  Future<List<ValidatorModel>> getValidators();
  Future<NetworkStatsModel> getNetworkStats();
  Future<ValidatorModel> getValidatorInfo();
  Future<ShardingInfoModel> getShardingInfo();
}
