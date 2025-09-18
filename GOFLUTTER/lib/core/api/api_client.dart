import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message (Status Code: $statusCode)';
}

class ApiClient {
  final String baseUrl;
  final http.Client _httpClient;

  ApiClient({required this.baseUrl, http.Client? httpClient}) 
      : _httpClient = httpClient ?? http.Client();

  Future<Map<String, dynamic>> get(String endpoint, {Map<String, String>? headers}) async {
    try {
      final response = await _httpClient.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers ?? {'Content-Type': 'application/json'},
      );
      
      return _processResponse(response);
    } catch (e) {
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> post(String endpoint, {Map<String, dynamic>? body, Map<String, String>? headers}) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers ?? {'Content-Type': 'application/json'},
        body: body != null ? json.encode(body) : null,
      );
      
      return _processResponse(response);
    } catch (e) {
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> put(String endpoint, {Map<String, dynamic>? body, Map<String, String>? headers}) async {
    try {
      final response = await _httpClient.put(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers ?? {'Content-Type': 'application/json'},
        body: body != null ? json.encode(body) : null,
      );
      
      return _processResponse(response);
    } catch (e) {
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> delete(String endpoint, {Map<String, String>? headers}) async {
    try {
      final response = await _httpClient.delete(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers ?? {'Content-Type': 'application/json'},
      );
      
      return _processResponse(response);
    } catch (e) {
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  Map<String, dynamic> _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {};
      }
      try {
        return json.decode(response.body);
      } catch (e) {
        throw ApiException('Failed to parse response: ${e.toString()}');
      }
    } else {
      String message = 'Request failed with status: ${response.statusCode}';
      try {
        final errorBody = json.decode(response.body);
        if (errorBody.containsKey('message')) {
          message = errorBody['message'];
        } else if (errorBody.containsKey('error')) {
          message = errorBody['error'];
        }
      } catch (_) {}
      
      throw ApiException(message, statusCode: response.statusCode);
    }
  }

  void dispose() {
    _httpClient.close();
  }
}