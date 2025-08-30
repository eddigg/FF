import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_manager.dart';

class FaucetService {
  static const String _baseUrl = 'http://localhost:8080'; // Default API port for Atlas Blockchain
  
  /// Request faucet tokens for a wallet address
  static Future<ApiCallResponse> requestFaucetTokens({
    required String walletAddress,
  }) async {
    final url = '$_baseUrl/faucet';
    
    final body = {
      'address': walletAddress,
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
        '{"error": "Failed to request faucet tokens: ${e.toString()}"}',
        {}, // Empty headers
        500,
      );
    }
  }
  
  /// Get faucet status information
  static Future<ApiCallResponse> getFaucetStatus() async {
    final url = '$_baseUrl/status';
    
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
        '{"error": "Failed to get faucet status: ${e.toString()}"}',
        {}, // Empty headers
        500,
      );
    }
  }
}