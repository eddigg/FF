import 'dart:convert';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;

import 'api_client_implementation.dart';
import 'secure_storage_implementation.dart';

/// Service for managing wallet operations
class WalletService {
  final ApiClient _apiClient;
  final SecureStorage _secureStorage;
  final Web3Client _web3Client;
  
  WalletService(
    this._apiClient,
    this._secureStorage,
  ) : _web3Client = Web3Client(
         'https://rpc.atlas.bc',
         http.Client(),
       );
  
  /// Creates a new wallet
  Future<WalletResponse> createWallet() async {
    try {
      final response = await _apiClient.createWallet();
      
      final walletResponse = WalletResponse.fromJson(response);
      
      // Store wallet credentials securely
      await _secureStorage.storeWalletCredentials(
        privateKey: walletResponse.privateKey,
        address: walletResponse.address,
        sessionToken: walletResponse.sessionToken,
      );
      
      return walletResponse;
    } catch (e) {
      if (e is ApiException) {
        throw WalletException('Failed to create wallet: ${e.message}', e.statusCode);
      }
      throw WalletException('Failed to create wallet', null);
    }
  }
  
  /// Gets wallet information
  Future<WalletInfo> getWalletInfo() async {
    try {
      // Get wallet address from secure storage
      final address = await _secureStorage.read(key: SecureStorage.keyWalletAddress);
      
      if (address == null) {
        throw WalletException('No wallet found', null);
      }
      
      final response = await _apiClient.getWalletInfo(address);
      return WalletInfo.fromJson(response);
    } catch (e) {
      if (e is ApiException) {
        throw WalletException('Failed to get wallet info: ${e.message}', e.statusCode);
      }
      throw WalletException('Failed to get wallet info', null);
    }
  }
  
  /// Requests test tokens from the faucet
  Future<String> requestTestTokens() async {
    try {
      // Get wallet address from secure storage
      final address = await _secureStorage.read(key: SecureStorage.keyWalletAddress);
      
      if (address == null) {
        throw WalletException('No wallet found', null);
      }
      
      final response = await _apiClient.requestTestTokens(address);
      return response['message'] ?? 'Test tokens requested successfully';
    } catch (e) {
      if (e is ApiException) {
        throw WalletException('Failed to request test tokens: ${e.message}', e.statusCode);
      }
      throw WalletException('Failed to request test tokens', null);
    }
  }
  
  /// Sends a transaction
  Future<String> sendTransaction({
    required String to,
    required double amount,
    String? data,
  }) async {
    try {
      // Get wallet credentials
      final credentials = await _secureStorage.getWalletCredentials();
      
      if (credentials['privateKey'] == null || credentials['address'] == null) {
        throw WalletException('No wallet credentials found', null);
      }
      
      // Create transaction object
      final transaction = {
        'from': credentials['address'],
        'to': to,
        'amount': amount.toString(),
        'data': data,
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      };
      
      // Sign the transaction
      final signature = await _signTransaction(transaction, credentials['privateKey']!);
      
      // Add signature to transaction
      transaction['signature'] = signature;
      
      // Send transaction to API
      final response = await _apiClient.sendTransaction(transaction);
      
      return response['transactionHash'] ?? '';
    } catch (e) {
      if (e is ApiException) {
        throw WalletException('Failed to send transaction: ${e.message}', e.statusCode);
      }
      throw WalletException('Failed to send transaction: ${e.toString()}', null);
    }
  }
  
  /// Imports an existing wallet
  Future<WalletResponse> importWallet(String privateKey) async {
    try {
      final response = await _apiClient.importWallet(privateKey);
      
      final walletResponse = WalletResponse.fromJson(response);
      
      // Store wallet credentials securely
      await _secureStorage.storeWalletCredentials(
        privateKey: walletResponse.privateKey,
        address: walletResponse.address,
        sessionToken: walletResponse.sessionToken,
      );
      
      return walletResponse;
    } catch (e) {
      if (e is ApiException) {
        throw WalletException('Failed to import wallet: ${e.message}', e.statusCode);
      }
      throw WalletException('Failed to import wallet', null);
    }
  }
  
  /// Signs a transaction using the private key
  Future<String> _signTransaction(Map<String, dynamic> transaction, String privateKey) async {
    try {
      // Convert transaction to bytes
      final transactionBytes = utf8.encode(jsonEncode(transaction));
      
      // Create credentials from private key
      final credentials = EthPrivateKey.fromHex(privateKey);
      
      // Sign the transaction
      final signature = await _web3Client.signPersonalMessage(
        credentials,
        Uint8List.fromList(transactionBytes),
      );
      
      // Return the signature as a hex string
      return bytesToHex(signature, include0x: true);
    } catch (e) {
      throw WalletException('Failed to sign transaction: ${e.toString()}', null);
    }
  }
  
  /// Clears wallet data
  Future<void> clearWallet() async {
    await _secureStorage.clearWalletCredentials();
  }
}

/// Exception thrown when wallet operations fail
class WalletException implements Exception {
  final String message;
  final int? statusCode;
  
  const WalletException(this.message, this.statusCode);
  
  @override
  String toString() => 'WalletException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

/// Response from wallet creation or import
class WalletResponse {
  final String address;
  final String privateKey;
  final String sessionToken;
  
  WalletResponse({
    required this.address,
    required this.privateKey,
    required this.sessionToken,
  });
  
  factory WalletResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return WalletResponse(
      address: data['address'] as String,
      privateKey: data['privateKey'] as String,
      sessionToken: data['sessionToken'] as String,
    );
  }
  
  Map<String, dynamic> toJson() => {
    'address': address,
    'privateKey': privateKey,
    'sessionToken': sessionToken,
  };
}

/// Wallet information
class WalletInfo {
  final String address;
  final double balance;
  final int nonce;
  final List<Transaction> recentTransactions;
  
  WalletInfo({
    required this.address,
    required this.balance,
    required this.nonce,
    required this.recentTransactions,
  });
  
  factory WalletInfo.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    
    List<Transaction> transactions = [];
    if (data['recentTransactions'] != null) {
      transactions = (data['recentTransactions'] as List)
          .map((item) => Transaction.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    
    return WalletInfo(
      address: data['address'] as String,
      balance: (data['balance'] as num).toDouble(),
      nonce: data['nonce'] as int,
      recentTransactions: transactions,
    );
  }
  
  Map<String, dynamic> toJson() => {
    'address': address,
    'balance': balance,
    'nonce': nonce,
    'recentTransactions': recentTransactions.map((tx) => tx.toJson()).toList(),
  };
}

/// Transaction model
class Transaction {
  final String hash;
  final String from;
  final String to;
  final double amount;
  final String? data;
  final DateTime timestamp;
  final String status;
  
  Transaction({
    required this.hash,
    required this.from,
    required this.to,
    required this.amount,
    this.data,
    required this.timestamp,
    required this.status,
  });
  
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      hash: json['hash'] as String,
      from: json['from'] as String,
      to: json['to'] as String,
      amount: (json['amount'] as num).toDouble(),
      data: json['data'] as String?,
      timestamp: DateTime.fromMillisecondsSinceEpoch(int.parse(json['timestamp'] as String)),
      status: json['status'] as String,
    );
  }
  
  Map<String, dynamic> toJson() => {
    'hash': hash,
    'from': from,
    'to': to,
    'amount': amount,
    'data': data,
    'timestamp': timestamp.millisecondsSinceEpoch.toString(),
    'status': status,
  };
}