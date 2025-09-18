import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'secure_storage_implementation.dart';

/// API client for communicating with the ATLAS.BC backend
class ApiClient {
  final Dio _dio = Dio();
  final SecureStorage _secureStorage;
  
  ApiClient(this._secureStorage) {
    final baseUrl = dotenv.env['API_BASE_URL'] ?? 'https://api.atlas.bc/api';
    
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    // Add auth interceptor
    _dio.interceptors.add(_createAuthInterceptor());
    
    // Add logging interceptor in debug mode
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }
  
  /// Creates an authentication interceptor
  Interceptor _createAuthInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Get session token from secure storage
        final sessionToken = await _secureStorage.read(key: SecureStorage.keySessionToken);
        if (sessionToken != null) {
          options.headers['Authorization'] = 'Bearer $sessionToken';
        }
        return handler.next(options);
      },
      onError: (DioException error, handler) async {
        // Handle 401 Unauthorized errors
        if (error.response?.statusCode == 401) {
          // Try to refresh token or redirect to login
          final refreshToken = await _secureStorage.read(key: SecureStorage.keyRefreshToken);
          if (refreshToken != null) {
            try {
              // Attempt to refresh the token
              final response = await _dio.post(
                '/auth/refresh',
                data: {'refreshToken': refreshToken},
              );
              
              if (response.statusCode == 200) {
                final newToken = response.data['token'];
                await _secureStorage.write(key: SecureStorage.keySessionToken, value: newToken);
                
                // Retry the original request
                final opts = error.requestOptions;
                opts.headers['Authorization'] = 'Bearer $newToken';
                
                final retryResponse = await _dio.fetch(opts);
                return handler.resolve(retryResponse);
              }
            } catch (e) {
              // Refresh token failed, clear credentials
              await _secureStorage.clearStorage();
            }
          }
        }
        return handler.next(error);
      },
    );
  }
  
  /// Performs a GET request
  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  /// Performs a POST request
  Future<dynamic> post(String path, dynamic data) async {
    try {
      final response = await _dio.post(path, data: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  /// Performs a PUT request
  Future<dynamic> put(String path, dynamic data) async {
    try {
      final response = await _dio.put(path, data: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  /// Performs a DELETE request
  Future<dynamic> delete(String path, {dynamic data}) async {
    try {
      final response = await _dio.delete(path, data: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  /// Handles the API response
  dynamic _handleResponse(Response response) {
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return response.data;
    } else {
      throw ApiException(
        message: 'Request failed with status: ${response.statusCode}',
        statusCode: response.statusCode,
        data: response.data,
      );
    }
  }
  
  /// Handles API errors
  ApiException _handleError(DioException error) {
    String message = 'Unknown error occurred';
    
    if (error.type == DioExceptionType.connectionTimeout) {
      message = 'Connection timeout';
    } else if (error.type == DioExceptionType.receiveTimeout) {
      message = 'Receive timeout';
    } else if (error.type == DioExceptionType.sendTimeout) {
      message = 'Send timeout';
    } else if (error.type == DioExceptionType.badResponse) {
      message = 'Bad response';
    } else if (error.type == DioExceptionType.cancel) {
      message = 'Request cancelled';
    } else if (error.type == DioExceptionType.connectionError) {
      message = 'Connection error';
    }
    
    return ApiException(
      message: message,
      statusCode: error.response?.statusCode,
      data: error.response?.data,
    );
  }
  
  // ATLAS.BC API endpoints
  
  /// Creates a wallet
  Future<Map<String, dynamic>> createWallet() async {
    return await post('/flutterflow/connect-wallet', {'action': 'create'});
  }
  
  /// Imports an existing wallet
  Future<Map<String, dynamic>> importWallet(String privateKey) async {
    return await post('/flutterflow/connect-wallet', {
      'action': 'import',
      'privateKey': privateKey,
    });
  }
  
  /// Gets wallet information
  Future<Map<String, dynamic>> getWalletInfo(String address) async {
    return await get('/flutterflow/wallet-info', queryParameters: {'address': address});
  }
  
  /// Requests test tokens from the faucet
  Future<Map<String, dynamic>> requestTestTokens(String address) async {
    return await post('/faucet', {'address': address});
  }
  
  /// Sends a transaction
  Future<Map<String, dynamic>> sendTransaction(Map<String, dynamic> transaction) async {
    return await post('/flutterflow/send-transaction', transaction);
  }
  
  /// Creates a user identity
  Future<Map<String, dynamic>> createIdentity(String userId) async {
    return await post('/identity/create', {'userId': userId});
  }
}

/// Exception thrown when API requests fail
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;
  
  const ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });
  
  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}