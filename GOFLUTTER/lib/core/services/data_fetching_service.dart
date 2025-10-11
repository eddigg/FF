import 'dart:convert';
import '../network/api_client.dart';
import '../utils/logger.dart';
import 'wallet_management_service.dart';

/// Service for fetching data from the blockchain API, ported from JavaScript functionality
class DataFetchingService {
  final ApiClient _apiClient;
  final WalletManagementService _walletService;

  DataFetchingService(this._apiClient, this._walletService);

  /// Fetches wallet balance for the given address
  Future<String> fetchWalletBalance(String address) async {
    try {
      final response = await _apiClient.dio.get('/balance?address=$address');
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return data['balance']?.toString() ?? '0';
      } else {
        throw Exception('Failed to fetch wallet balance: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.logError('Failed to fetch wallet balance', e);
      return 'Error';
    }
  }

  /// Fetches recent transactions from the mempool
  Future<List<dynamic>> fetchRecentTransactions({int limit = 5}) async {
    try {
      final response = await _apiClient.dio.get('/mempool?limit=$limit');
      if (response.statusCode == 200) {
        final data = response.data as List;
        return data;
      } else {
        throw Exception('Failed to fetch recent transactions: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.logError('Failed to fetch recent transactions', e);
      return [];
    }
  }

  /// Fetches network data (peers)
  Future<Map<String, dynamic>> fetchNetworkData() async {
    try {
      final response = await _apiClient.dio.get('/peers');
      if (response.statusCode == 200) {
        final data = response.data as List;
        return {
          'peers': data,
          'count': data.length,
        };
      } else {
        throw Exception('Failed to fetch network data: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.logError('Failed to fetch network data', e);
      return {
        'peers': [],
        'count': 0,
      };
    }
  }

  /// Fetches blockchain data (blocks)
  Future<Map<String, dynamic>> fetchBlockchainData({int limit = 10}) async {
    try {
      final response = await _apiClient.dio.get('/blocks?limit=$limit');
      if (response.statusCode == 200) {
        final data = response.data as List;
        // Count total transactions
        int totalTx = 0;
        for (var block in data) {
          if (block is Map<String, dynamic> && block['Transactions'] is List) {
            totalTx += block['Transactions'].length as int;
          }
        }
        
        return {
          'blocks': data,
          'blockCount': data.length,
          'transactionCount': totalTx,
        };
      } else {
        throw Exception('Failed to fetch blockchain data: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.logError('Failed to fetch blockchain data', e);
      return {
        'blocks': [],
        'blockCount': 0,
        'transactionCount': 0,
      };
    }
  }

  /// Fetches validator information for the current wallet
  Future<Map<String, dynamic>> fetchValidatorInfo() async {
    try {
      final address = await _walletService.getWalletAddress();
      if (address == '(not loaded)') {
        return {
          'stake': '0',
          'rank': 'Not a validator',
        };
      }
      
      final response = await _apiClient.dio.get('/validator?address=$address');
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return {
          'stake': data['stake']?.toString() ?? '0',
          'rank': data['rank']?.toString() ?? 'Not a validator',
        };
      } else {
        throw Exception('Failed to fetch validator info: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.logError('Failed to fetch validator info', e);
      return {
        'stake': 'Error',
        'rank': 'Error',
      };
    }
  }

  /// Fetches network architecture information
  Future<Map<String, dynamic>> fetchNetworkArchitecture() async {
    try {
      final response = await _apiClient.dio.get('/network/architecture');
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to fetch network architecture: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.logError('Failed to fetch network architecture', e);
      return {};
    }
  }

  /// Updates node status
  Future<Map<String, dynamic>> updateNodeStatus() async {
    try {
      final response = await _apiClient.dio.get('/status');
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to update node status: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.logError('Failed to update node status', e);
      return {};
    }
  }

  /// Requests faucet tokens for the current wallet
  Future<Map<String, dynamic>> requestFaucetTokens() async {
    try {
      final address = await _walletService.getWalletAddress();
      if (address == '(not loaded)') {
        throw Exception('Wallet not loaded');
      }
      
      final response = await _apiClient.dio.post(
        '/faucet',
        data: jsonEncode({'address': address}),
      );
      
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to request faucet tokens: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.logError('Failed to request faucet tokens', e);
      rethrow;
    }
  }

  /// Submits a transaction to the blockchain
  Future<Map<String, dynamic>> submitTransaction(Map<String, dynamic> transaction) async {
    try {
      final response = await _apiClient.dio.post(
        '/submit-transaction',
        data: jsonEncode(transaction),
      );
      
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to submit transaction: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.logError('Failed to submit transaction', e);
      rethrow;
    }
  }
}
