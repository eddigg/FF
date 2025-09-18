import '../../core/network/api_client.dart';
import '../../core/network/base_api_client.dart';
import '../../core/network/api_exceptions.dart' as network_exceptions;

class BlockchainApiService extends BaseApiClient {
  BlockchainApiService(ApiClient apiClient) : super(apiClient);

  // Get balance for an address
  Future<double> getBalance(String address) async {
    try {
      final response = await get<Map<String, dynamic>>('balance', queryParameters: {'address': address});
      if (response.containsKey('balance')) {
        return (response['balance'] as int).toDouble();
      }
      throw network_exceptions.ApiException(message: 'Invalid response format', statusCode: 500);
    } catch (e) {
      throw network_exceptions.ApiException(message: 'Failed to get balance: ${e.toString()}');
    }
  }

  // Request faucet tokens
  Future<bool> requestFaucet(String address) async {
    try {
      final response = await post<Map<String, dynamic>>('faucet', data: {
        'address': address,
      });
      return response.containsKey('status') && response['status'] == 'Faucet tokens credited';
    } catch (e) {
      throw network_exceptions.ApiException(message: 'Failed to request faucet: ${e.toString()}');
    }
  }

  // Register as validator
  Future<bool> registerValidator({
    required String address,
    required int stake,
    required Map<String, dynamic> kycData,
  }) async {
    try {
      final response = await post<Map<String, dynamic>>('register-validator', data: {
        'address': address,
        'stake': stake,
        'kyc': kycData,
      });
      return response.containsKey('status') && response['status'] == 'Validator registered successfully';
    } catch (e) {
      throw network_exceptions.ApiException(message: 'Failed to register validator: ${e.toString()}');
    }
  }

  // Submit a transaction
  Future<Map<String, dynamic>> submitTransaction({
    required String from,
    required String to,
    required int amount,
    required int fee,
    String? data,
    String? signature,
  }) async {
    try {
      final response = await post<Map<String, dynamic>>('submit-transaction', data: {
        'sender': from,
        'recipient': to,
        'amount': amount,
        'fee': fee,
        'data': data,
        'signature': signature,
      });
      return response;
    } catch (e) {
      throw network_exceptions.ApiException(message: 'Failed to submit transaction: ${e.toString()}');
    }
  }

  // Get transaction history
  Future<List<Map<String, dynamic>>> getTransactionHistory(String address) async {
    try {
      final response = await get<Map<String, dynamic>>('flutterflow/transaction-history', queryParameters: {'address': address});
      if (response.containsKey('data') && response['data'] is Map) {
        final data = response['data'] as Map<String, dynamic>;
        if (data.containsKey('transactions') && data['transactions'] is List) {
          return List<Map<String, dynamic>>.from(data['transactions'].map((item) => item as Map<String, dynamic>));
        }
      }
      return [];
    } catch (e) {
      throw network_exceptions.ApiException(message: 'Failed to get transaction history: ${e.toString()}');
    }
  }

  // Get block information
  Future<Map<String, dynamic>?> getBlock(String hash) async {
    try {
      final response = await get<Map<String, dynamic>>('block', queryParameters: {'hash': hash});
      return response;
    } catch (e) {
      // Return null if block not found
      return null;
    }
  }

  // Get list of blocks
  Future<List<Map<String, dynamic>>> getBlocks({int limit = 10, int offset = 0}) async {
    try {
      final response = await get<List<dynamic>>('blocks', queryParameters: {'limit': limit, 'offset': offset});
      return List<Map<String, dynamic>>.from(response.map((item) => item as Map<String, dynamic>));
    } catch (e) {
      throw network_exceptions.ApiException(message: 'Failed to get blocks: ${e.toString()}');
    }
  }

  // Get list of validators
  Future<List<Map<String, dynamic>>> getValidators() async {
    try {
      final response = await get<List<dynamic>>('validators');
      return List<Map<String, dynamic>>.from(response.map((item) => item as Map<String, dynamic>));
    } catch (e) {
      throw network_exceptions.ApiException(message: 'Failed to get validators: ${e.toString()}');
    }
  }

  // Get validator information
  Future<Map<String, dynamic>?> getValidator(String address) async {
    try {
      final response = await get<Map<String, dynamic>>('validator', queryParameters: {'address': address});
      return response;
    } catch (e) {
      // Return null if validator not found
      return null;
    }
  }

  // Get mempool transactions
  Future<List<Map<String, dynamic>>> getMempool() async {
    try {
      final response = await get<List<dynamic>>('mempool');
      return List<Map<String, dynamic>>.from(response.map((item) => item as Map<String, dynamic>));
    } catch (e) {
      throw network_exceptions.ApiException(message: 'Failed to get mempool: ${e.toString()}');
    }
  }

  // Get node status
  Future<Map<String, dynamic>> getStatus() async {
    try {
      final response = await get<Map<String, dynamic>>('status');
      return response;
    } catch (e) {
      throw network_exceptions.ApiException(message: 'Failed to get status: ${e.toString()}');
    }
  }

  // FlutterFlow integration endpoints
  Future<Map<String, dynamic>> flutterFlowConnectWallet(String address) async {
    try {
      final response = await post<Map<String, dynamic>>('flutterflow/connect-wallet', data: {
        'address': address,
      });
      return response;
    } catch (e) {
      throw network_exceptions.ApiException(message: 'Failed to connect wallet: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> flutterFlowAuthenticate({
    required String address,
    required String sessionToken,
  }) async {
    try {
      final response = await post<Map<String, dynamic>>('flutterflow/authenticate', data: {
        'address': address,
        'sessionToken': sessionToken,
      });
      return response;
    } catch (e) {
      throw network_exceptions.ApiException(message: 'Failed to authenticate: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> flutterFlowWalletInfo({
    required String address,
    required String sessionToken,
  }) async {
    try {
      final response = await post<Map<String, dynamic>>('flutterflow/wallet-info', data: {
        'address': address,
        'sessionToken': sessionToken,
      });
      return response;
    } catch (e) {
      throw network_exceptions.ApiException(message: 'Failed to get wallet info: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> flutterFlowSendTransaction({
    required String from,
    required String to,
    required int amount,
    required int fee,
    String? data,
    String? signature,
    required String sessionToken,
  }) async {
    try {
      final response = await post<Map<String, dynamic>>('flutterflow/send-transaction', data: {
        'from': from,
        'to': to,
        'amount': amount,
        'fee': fee,
        'data': data,
        'signature': signature,
        'sessionToken': sessionToken,
      });
      return response;
    } catch (e) {
      throw network_exceptions.ApiException(message: 'Failed to send transaction: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> flutterFlowDisconnect({
    required String address,
    required String sessionToken,
  }) async {
    try {
      final response = await post<Map<String, dynamic>>('flutterflow/disconnect', data: {
        'address': address,
        'sessionToken': sessionToken,
      });
      return response;
    } catch (e) {
      throw network_exceptions.ApiException(message: 'Failed to disconnect: ${e.toString()}');
    }
  }
}