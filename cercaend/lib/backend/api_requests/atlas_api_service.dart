import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_manager.dart';

class AtlasApiService {
  static const String _baseUrl = 'http://localhost:8080'; // Default API port for Atlas Blockchain
  
  // Wallet connection methods
  static Future<ApiCallResponse> connectWallet({
    required String action, // "create", "import", or "connect"
    String? privateKey,
    String? address,
  }) async {
    final url = '$_baseUrl/flutterflow/connect-wallet';
    
    final body = {
      'action': action,
      if (privateKey != null) 'privateKey': privateKey,
      if (address != null) 'address': address,
    };
    
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );
      
      return ApiCallResponse(
        response.body,
        response.headers,
        response.statusCode,
        response: response,
      );
    } catch (e) {
      return ApiCallResponse(
        '{"error": "Failed to connect wallet: ${e.toString()}"}',
        {}, // Empty headers
        500,
      );
    }
  }
  
  // Authenticate session
  static Future<ApiCallResponse> authenticate({
    required String sessionToken,
    required String address,
  }) async {
    final url = '$_baseUrl/flutterflow/authenticate';
    
    final body = {
      'sessionToken': sessionToken,
      'address': address,
    };
    
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );
      
      return ApiCallResponse(
        response.body,
        response.headers,
        response.statusCode,
        response: response,
      );
    } catch (e) {
      return ApiCallResponse(
        '{"error": "Authentication failed: ${e.toString()}"}',
        {}, // Empty headers
        500,
      );
    }
  }
  
  // Get wallet info
  static Future<ApiCallResponse> getWalletInfo({
    required String address,
  }) async {
    final url = '$_baseUrl/flutterflow/wallet-info?address=$address';
    
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      
      return ApiCallResponse(
        response.body,
        response.headers,
        response.statusCode,
        response: response,
      );
    } catch (e) {
      return ApiCallResponse(
        '{"error": "Failed to get wallet info: ${e.toString()}"}',
        {}, // Empty headers
        500,
      );
    }
  }
  
  // Send transaction
  static Future<ApiCallResponse> sendTransaction({
    required String from,
    required String to,
    required int amount,
    required int fee,
    String? data,
    required String signature,
    required String sessionToken,
  }) async {
    final url = '$_baseUrl/flutterflow/send-transaction';
    
    final body = {
      'from': from,
      'to': to,
      'amount': amount,
      'fee': fee,
      if (data != null) 'data': data,
      'signature': signature,
      'sessionToken': sessionToken,
    };
    
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );
      
      return ApiCallResponse(
        response.body,
        response.headers,
        response.statusCode,
        response: response,
      );
    } catch (e) {
      return ApiCallResponse(
        '{"error": "Failed to send transaction: ${e.toString()}"}',
        {}, // Empty headers
        500,
      );
    }
  }
  
  // Get transaction history
  static Future<ApiCallResponse> getTransactionHistory({
    required String address,
  }) async {
    final url = '$_baseUrl/flutterflow/transaction-history?address=$address';
    
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      
      return ApiCallResponse(
        response.body,
        response.headers,
        response.statusCode,
        response: response,
      );
    } catch (e) {
      return ApiCallResponse(
        '{"error": "Failed to get transaction history: ${e.toString()}"}',
        {}, // Empty headers
        500,
      );
    }
  }
  
  // Disconnect wallet
  static Future<ApiCallResponse> disconnect({
    required String sessionToken,
    required String address,
  }) async {
    final url = '$_baseUrl/flutterflow/disconnect';
    
    final body = {
      'sessionToken': sessionToken,
      'address': address,
    };
    
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );
      
      return ApiCallResponse(
        response.body,
        response.headers,
        response.statusCode,
        response: response,
      );
    } catch (e) {
      return ApiCallResponse(
        '{"error": "Failed to disconnect wallet: ${e.toString()}"}',
        {}, // Empty headers
        500,
      );
    }
  }
  
  // Request faucet tokens
  static Future<http.Response> requestFaucetTokens({
    required String address,
  }) async {
    final url = '$_baseUrl/faucet';
    
    final body = {
      'address': address,
    };
    
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );
      
      return response;
    } catch (e) {
      // Return a mock response with error
      return http.Response(
        '{"error": "Failed to request faucet tokens: ${e.toString()}"}',
        500,
      );
    }
  }
}