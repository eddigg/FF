import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';

class NodeDashboardApiClient {
  final ApiClient _apiClient;

  NodeDashboardApiClient(this._apiClient);

  Future<Map<String, dynamic>> fetchNodeMetrics() async {
    try {
      final response = await _apiClient.dio.get('/status');
      return {
        'uptime': response.data['uptime'] ?? '',
        'blocksProduced': response.data['block_height'] ?? 0,
        'transactionsProcessed': response.data['total_transactions'] ?? 0,
      };
    } on DioException catch (e) {
      throw Exception('Failed to fetch node metrics: $e');
    }
  }

  Future<List<dynamic>> fetchValidators() async {
    try {
      final response = await _apiClient.dio.get('/validators');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch validators: $e');
    }
  }

  Future<Map<String, dynamic>> fetchNetworkStats() async {
    try {
      final response = await _apiClient.dio.get('/status');
      return {
        'totalValidators': response.data['total_validators'] ?? 0,
        'networkHashRate': response.data['network_hashrate'] ?? '',
        'avgBlockTime': response.data['avg_block_time'] ?? '',
        'networkDifficulty': response.data['network_difficulty'] ?? '',
      };
    } on DioException catch (e) {
      throw Exception('Failed to fetch network stats: $e');
    }
  }

  Future<Map<String, dynamic>> fetchValidatorInfo() async {
    try {
      // This would typically require the current user's wallet address
      // For now, we'll use a placeholder or assume it's fetched elsewhere
      final response = await _apiClient.dio.get('/validator?address=mock_address');
      return {
        'address': response.data['address'] ?? '',
        'stake': response.data['stake'] ?? 0.0,
        'isActive': response.data['is_active'] ?? false,
        'status': response.data['status'] ?? '',
        'rank': response.data['rank'] ?? 0,
        'nodeMode': response.data['node_mode'] ?? '',
      };
    } on DioException catch (e) {
      throw Exception('Failed to fetch validator info: $e');
    }
  }

  Future<Map<String, dynamic>> fetchShardingInfo() async {
    try {
      final response = await _apiClient.dio.get('/sharding/status');
      return {
        'shardOverview': response.data['overview'] ?? '',
        'validatorAssignment': response.data['assignment'] ?? '',
        'crossShardTransactions': response.data['cross_shard_tx'] ?? '',
        'shardStatistics': response.data['statistics'] ?? '',
      };
    } on DioException catch (e) {
      throw Exception('Failed to fetch sharding info: $e');
    }
  }
}
