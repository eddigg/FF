import '../../../../core/network/api_client.dart';
import '../../../../core/network/base_api_client.dart';
import '../../../../core/network/api_exceptions.dart';
import '../../../../core/utils/logger.dart';

class WalletApiClient extends BaseApiClient {
  WalletApiClient(ApiClient apiClient) : super(apiClient);

  Future<Map<String, dynamic>> fetchWalletData({String? address, bool useCache = true}) async {
    try {
      // Use provided address or a default one
      final walletAddress = address ?? '0x1234567890abcdef';

      final Map<String, dynamic> walletData = {};
      walletData['address'] = walletAddress;

      // Fetch balance
      try {
        final balanceData = await get<Map<String, dynamic>>(
          '/balance',
          queryParameters: {'address': walletAddress},
          cacheParams: {'address': walletAddress},
          useCache: useCache,
          cacheExpiry: 2 * 60 * 1000, // 2 minutes
        );
        walletData['balance'] = balanceData['balance']?.toDouble() ?? 0.0;
      } catch (e) {
        walletData['balance'] = 0.0;
      }

      // Fetch recent transactions from mempool
      try {
        final transactionData = await get<List<dynamic>>(
          '/mempool',
          queryParameters: {'limit': 10, 'address': walletAddress},
          cacheParams: {'limit': 10, 'address': walletAddress},
          useCache: useCache,
          cacheExpiry: 2 * 60 * 1000, // 2 minutes
        );
        walletData['transactions'] = transactionData;
      } catch (e) {
        walletData['transactions'] = [];
      }

      return walletData;
    } catch (e) {
      throw ApiException(
        message: 'Failed to fetch wallet data: $e',
        details: e,
      );
    }
  }

  Future<void> sendTransaction(String recipient, double amount, String? message, {String? senderAddress}) async {
    try {
      // Use provided sender address or a default one
      final sender = senderAddress ?? '0x1234567890abcdef';

      await post<void>(
        '/submit-transaction',
        data: {
          'Sender': sender,
          'Recipient': recipient,
          'Amount': amount,
          'Fee': 0, // Assuming 0 fee for now
          'Timestamp': DateTime.now().millisecondsSinceEpoch ~/ 1000,
          'Nonce': 0, // Assuming 0 nonce for now, would need to fetch from backend
          'Data': message,
          'Signature': 'mock_signature', // Signature would be generated client-side in a real app
        },
        options: defaultOptions().copyWith(
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        ),
      );

      // Clear cache for this address since balance might have changed
      await clearCache('/balance', {'address': sender});
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to send transaction: $e',
        details: e,
      );
    }
  }

  /// Requests test tokens from the faucet
  Future<Map<String, dynamic>> requestTestTokens(String address) async {
    try {
      final response = await post<Map<String, dynamic>>(
        '/faucet',
        data: {
          'address': address,
        },
        options: defaultOptions().copyWith(
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        ),
      );

      // Clear cache for this address since balance will change
      await clearCache('/balance', {'address': address});
      
      return response;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to request test tokens: $e',
        details: e,
      );
    }
  }

  /// Fetches transaction history for an address with pagination
  Future<List<dynamic>> fetchTransactionHistory(String address, {int page = 1, int limit = 20, bool useCache = true}) async {
    try {
      final result = await get<List<dynamic>>(
        '/transactions',
        queryParameters: {'address': address, 'page': page, 'limit': limit},
        cacheParams: {'address': address, 'page': page, 'limit': limit},
        useCache: useCache,
        cacheExpiry: 3 * 60 * 1000, // 3 minutes
      );
      
      return result;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to fetch transaction history: $e',
        details: e,
      );
    }
  }

  /// Fetches wallet statistics
  Future<Map<String, dynamic>> fetchWalletStats(String address, {bool useCache = true}) async {
    try {
      final result = await get<Map<String, dynamic>>(
        '/wallet/stats',
        queryParameters: {'address': address},
        cacheParams: {'address': address},
        useCache: useCache,
        cacheExpiry: 5 * 60 * 1000, // 5 minutes
      );
      
      return result;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to fetch wallet stats: $e',
        details: e,
      );
    }
  }

  /// Registers as a validator
  Future<bool> registerAsValidator({
    required String address,
    required int stake,
    required Map<String, dynamic> kycData,
  }) async {
    try {
      final response = await post<Map<String, dynamic>>(
        '/register-validator',
        data: {
          'address': address,
          'stake': stake,
          'kyc': kycData,
        },
        options: defaultOptions().copyWith(
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        ),
      );
      
      return response.containsKey('status') && response['status'] == 'Validator registered successfully';
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to register as validator: $e',
        details: e,
      );
    }
  }

  /// Clear cache for a specific address
  Future<void> clearAddressCache(String address) async {
    try {
      await clearCache('/balance', {'address': address});
      await clearCache('/wallet/stats', {'address': address});
    } catch (e) {
      AppLogger.logError('Error clearing cache for address: $address', e);
    }
  }
}