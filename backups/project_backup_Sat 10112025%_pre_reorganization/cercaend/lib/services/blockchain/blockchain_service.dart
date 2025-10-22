import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

/// Blockchain service for integrating with ATLAS blockchain
class BlockchainService {
  static const String _baseUrl = 'http://localhost:8080';
  final http.Client _client;

  BlockchainService({http.Client? client}) : _client = client ?? http.Client();

  /// Connect wallet to ATLAS blockchain
  Future<WalletConnectionResponse> connectWallet(WalletConnectRequest request) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/flutterflow/connect-wallet'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return WalletConnectionResponse.fromJson(data);
      } else {
        throw BlockchainException('Failed to connect wallet: ${response.statusCode}');
      }
    } catch (e) {
      throw BlockchainException('Connection error: $e');
    }
  }

  /// Get wallet information
  Future<WalletInfoResponse> getWalletInfo(String address) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/flutterflow/wallet-info?address=$address'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return WalletInfoResponse.fromJson(data);
      } else {
        throw BlockchainException('Failed to get wallet info: ${response.statusCode}');
      }
    } catch (e) {
      throw BlockchainException('Connection error: $e');
    }
  }

  /// Send blockchain transaction
  Future<SendTransactionResponse> sendTransaction(SendTransactionRequest request) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/flutterflow/send-transaction'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return SendTransactionResponse.fromJson(data);
      } else {
        throw BlockchainException('Failed to send transaction: ${response.statusCode}');
      }
    } catch (e) {
      throw BlockchainException('Connection error: $e');
    }
  }

  /// Get transaction history
  Future<TransactionHistoryResponse> getTransactionHistory(String address) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/flutterflow/transaction-history?address=$address'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return TransactionHistoryResponse.fromJson(data);
      } else {
        throw BlockchainException('Failed to get transaction history: ${response.statusCode}');
      }
    } catch (e) {
      throw BlockchainException('Connection error: $e');
    }
  }

  /// Authenticate wallet session
  Future<AuthResponse> authenticate(String sessionToken, String address) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/flutterflow/authenticate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'sessionToken': sessionToken,
          'address': address,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AuthResponse.fromJson(data);
      } else {
        throw BlockchainException('Authentication failed: ${response.statusCode}');
      }
    } catch (e) {
      throw BlockchainException('Connection error: $e');
    }
  }

  /// Disconnect wallet
  Future<DisconnectResponse> disconnect(String sessionToken, String address) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/flutterflow/disconnect'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'sessionToken': sessionToken,
          'address': address,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return DisconnectResponse.fromJson(data);
      } else {
        throw BlockchainException('Failed to disconnect: ${response.statusCode}');
      }
    } catch (e) {
      throw BlockchainException('Connection error: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}

/// Request/Response models
class WalletConnectRequest {
  final String action; // 'create', 'import', 'connect'
  final String? privateKey;
  final String? address;
  final String? sessionId;

  WalletConnectRequest({
    required this.action,
    this.privateKey,
    this.address,
    this.sessionId,
  });

  Map<String, dynamic> toJson() => {
    'action': action,
    if (privateKey != null) 'privateKey': privateKey,
    if (address != null) 'address': address,
    if (sessionId != null) 'sessionId': sessionId,
  };
}

class WalletConnectionResponse {
  final bool success;
  final String message;
  final WalletData data;

  WalletConnectionResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory WalletConnectionResponse.fromJson(Map<String, dynamic> json) {
    return WalletConnectionResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: WalletData.fromJson(json['data'] ?? {}),
    );
  }
}

class WalletData {
  final String address;
  final String sessionToken;
  final double balance;
  final bool isValidator;

  WalletData({
    required this.address,
    required this.sessionToken,
    required this.balance,
    required this.isValidator,
  });

  factory WalletData.fromJson(Map<String, dynamic> json) {
    return WalletData(
      address: json['address'] ?? '',
      sessionToken: json['sessionToken'] ?? '',
      balance: (json['balance'] ?? 0).toDouble(),
      isValidator: json['isValidator'] ?? false,
    );
  }
}

class WalletInfoResponse {
  final bool success;
  final WalletInfoData data;

  WalletInfoResponse({
    required this.success,
    required this.data,
  });

  factory WalletInfoResponse.fromJson(Map<String, dynamic> json) {
    return WalletInfoResponse(
      success: json['success'] ?? false,
      data: WalletInfoData.fromJson(json['data'] ?? {}),
    );
  }
}

class WalletInfoData {
  final String address;
  final double balance;
  final bool isValidator;
  final List<TransactionData> recentTransactions;
  final int nonce;

  WalletInfoData({
    required this.address,
    required this.balance,
    required this.isValidator,
    required this.recentTransactions,
    required this.nonce,
  });

  factory WalletInfoData.fromJson(Map<String, dynamic> json) {
    return WalletInfoData(
      address: json['address'] ?? '',
      balance: (json['balance'] ?? 0).toDouble(),
      isValidator: json['isValidator'] ?? false,
      recentTransactions: (json['recentTransactions'] as List<dynamic>?)
          ?.map((tx) => TransactionData.fromJson(tx))
          .toList() ?? [],
      nonce: json['nonce'] ?? 0,
    );
  }
}

class SendTransactionRequest {
  final String from;
  final String to;
  final int amount;
  final int fee;
  final String? data;
  final String signature;
  final String sessionToken;

  SendTransactionRequest({
    required this.from,
    required this.to,
    required this.amount,
    required this.fee,
    this.data,
    required this.signature,
    required this.sessionToken,
  });

  Map<String, dynamic> toJson() => {
    'from': from,
    'to': to,
    'amount': amount,
    'fee': fee,
    if (data != null) 'data': data,
    'signature': signature,
    'sessionToken': sessionToken,
  };
}

class SendTransactionResponse {
  final bool success;
  final String message;
  final TransactionResultData data;

  SendTransactionResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SendTransactionResponse.fromJson(Map<String, dynamic> json) {
    return SendTransactionResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: TransactionResultData.fromJson(json['data'] ?? {}),
    );
  }
}

class TransactionResultData {
  final String transactionHash;
  final String from;
  final String to;
  final int amount;
  final String status;

  TransactionResultData({
    required this.transactionHash,
    required this.from,
    required this.to,
    required this.amount,
    required this.status,
  });

  factory TransactionResultData.fromJson(Map<String, dynamic> json) {
    return TransactionResultData(
      transactionHash: json['transactionHash'] ?? '',
      from: json['from'] ?? '',
      to: json['to'] ?? '',
      amount: json['amount'] ?? 0,
      status: json['status'] ?? '',
    );
  }
}

class TransactionHistoryResponse {
  final bool success;
  final TransactionHistoryData data;

  TransactionHistoryResponse({
    required this.success,
    required this.data,
  });

  factory TransactionHistoryResponse.fromJson(Map<String, dynamic> json) {
    return TransactionHistoryResponse(
      success: json['success'] ?? false,
      data: TransactionHistoryData.fromJson(json['data'] ?? {}),
    );
  }
}

class TransactionHistoryData {
  final String address;
  final List<TransactionData> transactions;
  final int totalCount;

  TransactionHistoryData({
    required this.address,
    required this.transactions,
    required this.totalCount,
  });

  factory TransactionHistoryData.fromJson(Map<String, dynamic> json) {
    return TransactionHistoryData(
      address: json['address'] ?? '',
      transactions: (json['transactions'] as List<dynamic>?)
          ?.map((tx) => TransactionData.fromJson(tx))
          .toList() ?? [],
      totalCount: json['totalCount'] ?? 0,
    );
  }
}

class TransactionData {
  final String hash;
  final int blockIndex;
  final String sender;
  final String recipient;
  final int amount;
  final int fee;
  final int timestamp;
  final String type;

  TransactionData({
    required this.hash,
    required this.blockIndex,
    required this.sender,
    required this.recipient,
    required this.amount,
    required this.fee,
    required this.timestamp,
    required this.type,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      hash: json['hash'] ?? '',
      blockIndex: json['blockIndex'] ?? 0,
      sender: json['sender'] ?? '',
      recipient: json['recipient'] ?? '',
      amount: json['amount'] ?? 0,
      fee: json['fee'] ?? 0,
      timestamp: json['timestamp'] ?? 0,
      type: json['type'] ?? '',
    );
  }
}

class AuthResponse {
  final bool success;
  final String message;
  final AuthData data;

  AuthResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: AuthData.fromJson(json['data'] ?? {}),
    );
  }
}

class AuthData {
  final String address;
  final double balance;
  final bool isValidator;

  AuthData({
    required this.address,
    required this.balance,
    required this.isValidator,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      address: json['address'] ?? '',
      balance: (json['balance'] ?? 0).toDouble(),
      isValidator: json['isValidator'] ?? false,
    );
  }
}

class DisconnectResponse {
  final bool success;
  final String message;
  final DisconnectData data;

  DisconnectResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory DisconnectResponse.fromJson(Map<String, dynamic> json) {
    return DisconnectResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: DisconnectData.fromJson(json['data'] ?? {}),
    );
  }
}

class DisconnectData {
  final String address;
  final int disconnectedAt;

  DisconnectData({
    required this.address,
    required this.disconnectedAt,
  });

  factory DisconnectData.fromJson(Map<String, dynamic> json) {
    return DisconnectData(
      address: json['address'] ?? '',
      disconnectedAt: json['disconnectedAt'] ?? 0,
    );
  }
}

/// Custom exception for blockchain errors
class BlockchainException implements Exception {
  final String message;
  BlockchainException(this.message);

  @override
  String toString() => 'BlockchainException: $message';
}