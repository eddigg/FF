import 'dart:async';
import 'dart:math';
import '../api/api_client.dart';
import '../../features/dashboard/data/models/network_architecture_model.dart';
import '../utils/logger.dart';

/// NetworkDataProvider for fetching real-time network architecture data
/// Implements the data fetching patterns from the web JavaScript implementation
class NetworkDataProvider {
  final ApiClient _apiClient;
  Timer? _refreshTimer;
  final Duration _refreshInterval;
  
  // Retry logic
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(seconds: 2);
  
  // Callbacks for data updates
  Function(NetworkArchitectureModel)? _onDataUpdated;
  Function(String)? _onError;
  
  NetworkDataProvider({
    required ApiClient apiClient,
    Duration refreshInterval = const Duration(seconds: 10),
  }) : _apiClient = apiClient, _refreshInterval = refreshInterval;

  /// Set callback for data updates
  void onDataUpdated(Function(NetworkArchitectureModel) callback) {
    _onDataUpdated = callback;
  }

  /// Set callback for error handling
  void onError(Function(String) callback) {
    _onError = callback;
  }

  /// Start periodic data fetching matching web JavaScript patterns exactly
  void startPeriodicUpdates() {
    // Cancel any existing timer
    _refreshTimer?.cancel();
    
    // Start periodic updates matching web version (10-second refresh cycle)
    // This matches the JavaScript implementation: setInterval(async () => {...}, 10000)
    _refreshTimer = Timer.periodic(_refreshInterval, (timer) {
      fetchAllData();
    });
    
    // Fetch initial data immediately, matching the web implementation pattern
    // The web version does: await Promise.all([fetchWalletBalance(address), fetchRecentTransactions(), fetchNetworkArchitecture(), updateNodeStatus()])
    fetchAllData();
  }

  /// Stop periodic data fetching
  void stopPeriodicUpdates() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  /// Fetch all data matching the web JavaScript implementation patterns with retry logic
  Future<void> fetchAllData() async {
    try {
      // Fetch multiple data sources in parallel like the web version does with Promise.all
      final results = await _retryOnFailure(() async {
        return await Future.wait([
          fetchNetworkArchitecture(),
          fetchPeers(),
          fetchBlockchainData(),
        ], eagerError: false);
      });
      
      // Process results
      final networkArchitecture = results[0] as NetworkArchitectureModel?; // Restored proper cast
      
      // Notify listeners of new data
      if (networkArchitecture != null) {
        _onDataUpdated?.call(networkArchitecture);
      }
    } catch (e) {
      AppLogger.logError('Failed to fetch all data after retries', e);
      _handleFetchError(e.toString());
    }
  }

  /// Fetch network architecture data from the API matching web fetch patterns with retry logic
  Future<NetworkArchitectureModel> fetchNetworkArchitecture() async {
    return await _retryOnFailure(() async {
      try {
        final response = await _apiClient.get('network/architecture');
        
        // Parse the response into our model
        final networkArchitecture = NetworkArchitectureModel.fromJson(response);
        
        return networkArchitecture;
      } catch (e) {
        AppLogger.logError('Failed to fetch network architecture', e);
        rethrow;
      }
    });
  }

  /// Fetch peers data matching web fetch patterns with retry logic
  Future<List<dynamic>> fetchPeers() async {
    return await _retryOnFailure(() async {
      try {
        final response = await _apiClient.get('peers');
        return response['peers'] as List<dynamic>;
      } catch (e) {
        AppLogger.logError('Failed to fetch peers', e);
        rethrow;
      }
    });
  }

  /// Fetch blockchain data matching web fetch patterns with retry logic
  Future<Map<String, dynamic>> fetchBlockchainData({int limit = 10}) async {
    return await _retryOnFailure(() async {
      try {
        final response = await _apiClient.get('blocks?limit=$limit');
        final blocks = response as List; // Kept necessary cast
        
        // Count total transactions like the web version does
        int totalTx = 0;
        for (var block in blocks) {
          if (block is Map<String, dynamic> && block['Transactions'] is List) {
            totalTx += (block['Transactions'] as List).length;
          }
        }
        
        return {
          'blocks': blocks,
          'blockCount': blocks.length,
          'transactionCount': totalTx,
        };
      } catch (e) {
        AppLogger.logError('Failed to fetch blockchain data', e);
        rethrow;
      }
    });
  }

  /// Fetch wallet balance matching web fetch patterns with retry logic
  Future<String> fetchWalletBalance(String address) async {
    return await _retryOnFailure(() async {
      try {
        final response = await _apiClient.get('balance?address=$address');
        return response['balance']?.toString() ?? '0';
      } catch (e) {
        AppLogger.logError('Failed to fetch wallet balance', e);
        rethrow;
      }
    });
  }

  /// Fetch recent transactions matching web fetch patterns with retry logic
  Future<List<dynamic>> fetchRecentTransactions({int limit = 5}) async {
    return await _retryOnFailure(() async {
      try {
        final response = await _apiClient.get('mempool?limit=$limit');
        return response as List; // Kept necessary cast
      } catch (e) {
        AppLogger.logError('Failed to fetch recent transactions', e);
        rethrow;
      }
    });
  }

  /// Fetch validator info matching web fetch patterns with retry logic
  Future<Map<String, dynamic>> fetchValidatorInfo(String address) async {
    return await _retryOnFailure(() async {
      try {
        final response = await _apiClient.get('validator?address=$address');
        return response as Map<String, dynamic>; // Kept necessary cast
      } catch (e) {
        AppLogger.logError('Failed to fetch validator info', e);
        rethrow;
      }
    });
  }

  /// Fetch node status matching web fetch patterns with retry logic
  Future<Map<String, dynamic>> fetchNodeStatus() async {
    return await _retryOnFailure(() async {
      try {
        final response = await _apiClient.get('status');
        return response as Map<String, dynamic>; // Kept necessary cast
      } catch (e) {
        AppLogger.logError('Failed to fetch node status', e);
        rethrow;
      }
    });
  }

  /// Retry a function with exponential backoff, matching web error handling patterns
  Future<T> _retryOnFailure<T>(Future<T> Function() function) async {
    int attempts = 0;
    while (true) {
      try {
        return await function();
      } catch (e) {
        attempts++;
        if (attempts >= _maxRetries) {
          // Log final error after all retries exhausted
          AppLogger.logError('All retries exhausted for function after $_maxRetries attempts', e);
          rethrow;
        }
        
        // Exponential backoff with jitter, matching web retry patterns
        final delay = _retryDelay * pow(2, attempts - 1);
        final jitter = Random().nextInt(1000); // Add up to 1 second of jitter
        await Future.delayed(delay + Duration(milliseconds: jitter));
        
        AppLogger.log('Retrying function after attempt $attempts failed: $e');
      }
    }
  }

  /// Handle fetch errors with fallback data matching web error states
  void _handleFetchError(String errorMessage) {
    // Create fallback data structure matching web error states
    final fallbackData = NetworkArchitectureModel.empty();
    
    // Notify listeners of error with fallback data
    _onDataUpdated?.call(fallbackData);
    _onError?.call(errorMessage);
  }

  /// Simulate network latency for testing
  Future<double> simulateNetworkLatency() async {
    // Simulate network latency between 20-100ms
    await Future.delayed(Duration(milliseconds: 20 + Random().nextInt(80)));
    return 20.0 + Random().nextDouble() * 80.0;
  }

  /// Dispose of resources
  void dispose() {
    _refreshTimer?.cancel();
  }
}
