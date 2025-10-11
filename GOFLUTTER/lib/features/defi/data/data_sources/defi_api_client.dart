import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';

class DeFiApiClient {
  final ApiClient _apiClient;

  DeFiApiClient(this._apiClient);

  Future<Map<String, dynamic>> fetchPortfolioData() async {
    try {
      final response = await _apiClient.dio.get('/defi/portfolio');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch portfolio data: $e');
    }
  }

  Future<List<dynamic>> fetchLendingPools() async {
    try {
      final response = await _apiClient.dio.get('/defi/lending');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch lending pools: $e');
    }
  }

  Future<List<dynamic>> fetchTradingPairs() async {
    try {
      final response = await _apiClient.dio.get('/defi/trading');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch trading pairs: $e');
    }
  }

  Future<List<dynamic>> fetchStakingOptions() async {
    try {
      final response = await _apiClient.dio.get('/defi/staking');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch staking options: $e');
    }
  }

  Future<List<dynamic>> fetchLiquidityPools() async {
    try {
      final response = await _apiClient.dio.get('/defi/liquidity');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch liquidity pools: $e');
    }
  }

  Future<List<dynamic>> fetchYieldFarms() async {
    try {
      final response = await _apiClient.dio.get('/defi/yield-farming');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch yield farms: $e');
    }
  }

  Future<Map<String, dynamic>> stakeTokens({
    required String address,
    required String poolId,
    required double amount,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '/defi/stake',
        data: {
          'address': address,
          'poolId': poolId,
          'amount': amount,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to stake tokens: $e');
    }
  }

  Future<Map<String, dynamic>> unstakeTokens({
    required String address,
    required String poolId,
    required double amount,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '/defi/unstake',
        data: {
          'address': address,
          'poolId': poolId,
          'amount': amount,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to unstake tokens: $e');
    }
  }

  Future<Map<String, dynamic>> claimRewards({
    required String address,
    required String poolId,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '/defi/claim-rewards',
        data: {
          'address': address,
          'poolId': poolId,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to claim rewards: $e');
    }
  }
}
