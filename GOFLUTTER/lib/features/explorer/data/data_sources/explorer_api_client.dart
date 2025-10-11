import '../../../../core/network/api_client.dart';
import '../../../../core/network/base_api_client.dart';
import '../../../../core/network/api_exceptions.dart';

class ExplorerApiClient extends BaseApiClient {
  ExplorerApiClient(ApiClient apiClient) : super(apiClient);

  Future<List<dynamic>> fetchRecentBlocks({int limit = 20, bool useCache = true}) async {
    try {
      final result = await get<List<dynamic>>(
        '/blocks',
        queryParameters: {'limit': limit},
        cacheParams: {'limit': limit},
        useCache: useCache,
        cacheExpiry: 30 * 1000, // 30 seconds
      );
      
      return result;
    } catch (e) {
      throw ApiException(
        message: 'Failed to fetch recent blocks: $e',
        details: e,
      );
    }
  }

  Future<List<dynamic>> fetchRecentTransactions({int limit = 50, bool useCache = true}) async {
    try {
      final result = await get<List<dynamic>>(
        '/mempool',
        queryParameters: {'limit': limit},
        cacheParams: {'limit': limit},
        useCache: useCache,
        cacheExpiry: 30 * 1000, // 30 seconds
      );
      
      return result;
    } catch (e) {
      throw ApiException(
        message: 'Failed to fetch recent transactions: $e',
        details: e,
      );
    }
  }

  Future<List<dynamic>> search(String query, {int limit = 50}) async {
    try {
      final result = await get<List<dynamic>>(
        '/search',
        queryParameters: {'q': query, 'limit': limit},
        useCache: false, // Don't cache search results
      );
      
      return result;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Search failed: $e',
        details: e,
      );
    }
  }

  Future<List<dynamic>> fetchBlocksByAddress(String address, {int limit = 20, bool useCache = true}) async {
    try {
      final result = await get<List<dynamic>>(
        '/blocks',
        queryParameters: {'address': address, 'limit': limit},
        cacheParams: {'address': address, 'limit': limit},
        useCache: useCache,
        cacheExpiry: 60 * 1000, // 1 minute
      );
      
      return result;
    } catch (e) {
      throw ApiException(
        message: 'Failed to fetch blocks by address: $e',
        details: e,
      );
    }
  }

  Future<Map<String, dynamic>> fetchBlockByHash(String hash, {bool useCache = true}) async {
    try {
      final result = await get<Map<String, dynamic>>(
        '/blocks/$hash',
        cacheParams: {},
        useCache: useCache,
        cacheExpiry: 5 * 60 * 1000, // 5 minutes
      );
      
      return result;
    } on NotFoundException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to fetch block by hash: $e',
        details: e,
      );
    }
  }

  Future<Map<String, dynamic>> fetchBlockByNumber(int blockNumber, {bool useCache = true}) async {
    try {
      final result = await get<Map<String, dynamic>>(
        '/blocks/$blockNumber',
        cacheParams: {},
        useCache: useCache,
        cacheExpiry: 5 * 60 * 1000, // 5 minutes
      );
      
      return result;
    } on NotFoundException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to fetch block by number: $e',
        details: e,
      );
    }
  }

  Future<List<dynamic>> fetchTransactions({int limit = 50, bool useCache = true}) async {
    try {
      final result = await get<List<dynamic>>(
        '/transactions',
        queryParameters: {'limit': limit},
        cacheParams: {'limit': limit},
        useCache: useCache,
        cacheExpiry: 30 * 1000, // 30 seconds
      );
      
      return result;
    } catch (e) {
      throw ApiException(
        message: 'Failed to fetch transactions: $e',
        details: e,
      );
    }
  }

  Future<List<dynamic>> fetchTransactionsByAddress(String address, {int limit = 50, bool useCache = true}) async {
    try {
      final result = await get<List<dynamic>>(
        '/transactions',
        queryParameters: {'address': address, 'limit': limit},
        cacheParams: {'address': address, 'limit': limit},
        useCache: useCache,
        cacheExpiry: 60 * 1000, // 1 minute
      );
      
      return result;
    } catch (e) {
      throw ApiException(
        message: 'Failed to fetch transactions by address: $e',
        details: e,
      );
    }
  }

  /// Fetches detailed transaction information by hash
  Future<Map<String, dynamic>> fetchTransactionByHash(String hash, {bool useCache = true}) async {
    try {
      final result = await get<Map<String, dynamic>>(
        '/transactions/$hash',
        cacheParams: {},
        useCache: useCache,
        cacheExpiry: 5 * 60 * 1000, // 5 minutes
      );
      
      return result;
    } on NotFoundException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to fetch transaction: $e',
        details: e,
      );
    }
  }

  /// Fetches network statistics
  Future<Map<String, dynamic>> fetchNetworkStats({bool useCache = true}) async {
    try {
      final result = await get<Map<String, dynamic>>(
        '/network/stats',
        cacheParams: {},
        useCache: useCache,
        cacheExpiry: 60 * 1000, // 1 minute
      );
      
      return result;
    } catch (e) {
      throw ApiException(
        message: 'Failed to fetch network stats: $e',
        details: e,
      );
    }
  }
  
  /// Clear cache for explorer data
  Future<void> clearExplorerCache() async {
    try {
      // Clear common explorer cache keys
      await clearCache('/blocks');
      await clearCache('/mempool');
      await clearCache('/transactions');
      await clearCache('/network/stats');
    } catch (e) {
      // Silently ignore cache clearing errors
    }
  }
}
