import 'package:dio/dio.dart';
import 'dart:async';
import '../../../../core/network/api_client.dart';
import '../../../../core/utils/logger.dart';

class DashboardApiClient {
  final ApiClient _apiClient;
  // Cache for dashboard data
  Map<String, dynamic>? _cachedData;
  DateTime? _lastFetchTime;
  static const Duration _cacheDuration = Duration(seconds: 5); // Cache for 5 seconds

  DashboardApiClient(this._apiClient);

  Future<Map<String, dynamic>> fetchDashboardData() async {
    // Check if we have valid cached data
    if (_cachedData != null && 
        _lastFetchTime != null && 
        DateTime.now().difference(_lastFetchTime!) < _cacheDuration) {
      return _cachedData!;
    }

    try {
      final Map<String, dynamic> dashboardData = {};

      // Fetch data from /status
      try {
        final statusResponse = await _apiClient.dio.get('/status');
        dashboardData['nodeStatus'] = statusResponse.data['mode'] ?? 'connected';
      } catch (e) {
        AppLogger.logError('Error fetching /status', e);
        dashboardData['nodeStatus'] = 'unknown';
      }

      // Fetch data from /network/architecture
      try {
        final networkArchitectureResponse = await _apiClient.dio.get('/network/architecture');
        dashboardData['networkArchitecture'] = networkArchitectureResponse.data;
      } catch (e) {
        AppLogger.logError('Error fetching /network/architecture', e);
        // Provide fallback data structure
        dashboardData['networkArchitecture'] = {
          'nodeTypes': {
            'validators': {'count': 0, 'active': 0, 'description': 'Loading...'},
            'observers': {'count': 0, 'description': 'Loading...'},
            'fullNodes': {'count': 0, 'description': 'Loading...'},
          },
          'p2pProtocol': {
            'type': 'Loading...',
            'version': '0.0',
            'discovery': 'Loading...',
            'transport': 'Loading...',
            'description': 'Loading real-time network data...',
          },
          'consensusMechanism': {
            'type': 'Loading...',
            'blockTime': '0s',
            'finality': 'Loading...',
            'description': 'Loading real-time network data...',
          },
          'networkTopology': {
            'type': 'Loading...',
            'maxPeers': 0,
            'connections': 'Loading...',
            'description': 'Loading real-time network data...',
          },
          'securityFeatures': {
            'encryption': 'Loading...',
            'authentication': 'Loading...',
            'rateLimiting': 'Loading...',
            'slashing': 'Loading...',
            'description': 'Loading real-time network data...',
          },
        };
      }

      // Fetch data from /peers
      try {
        final peersResponse = await _apiClient.dio.get('/peers');
        dashboardData['peerCount'] = (peersResponse.data as List).length;
      } catch (e) {
        AppLogger.logError('Error fetching /peers', e);
        dashboardData['peerCount'] = 0;
      }

      // Fetch data from /blocks
      try {
        final blocksResponse = await _apiClient.dio.get('/blocks?limit=10');
        final blocks = blocksResponse.data as List;
        dashboardData['recentBlocks'] = blocks;
        dashboardData['blockCount'] = blocks.length;
        int totalTransactions = 0;
        for (var block in blocks) {
          if (block['Transactions'] is List) {
            totalTransactions += (block['Transactions'] as List).length;
          }
        }
        dashboardData['transactionCount'] = totalTransactions;
      } catch (e) {
        AppLogger.logError('Error fetching /blocks', e);
        dashboardData['recentBlocks'] = [];
        dashboardData['blockCount'] = 0;
        dashboardData['transactionCount'] = 0;
      }

      // Mock network latency as it's not directly available
      dashboardData['networkLatency'] = 50.0; // Placeholder

      // Cache the data
      _cachedData = dashboardData;
      _lastFetchTime = DateTime.now();

      return dashboardData;
    } on DioException catch (e) {
      // If we have cached data, return it even if the request fails
      if (_cachedData != null) {
        return _cachedData!;
      }
      throw Exception('Failed to fetch dashboard data: $e');
    }
  }

  // Method to clear cache when needed
  void clearCache() {
    _cachedData = null;
    _lastFetchTime = null;
  }
}