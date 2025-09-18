import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio;

  ApiClient() : _dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:8080',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));

  Future<Map<String, dynamic>> createWallet() async {
    try {
      final response = await _dio.post('/api/wallet/create');
      return response.data;
    } catch (e) {
      // Return mock data for development
      return {
        'data': {
          'address': '0x742d35Cc6634C0532925a3b844Bc454e4438f44e',
          'privateKey': 'mock_private_key_for_development',
          'sessionToken': 'mock_session_token'
        }
      };
    }
  }

  Future<Map<String, dynamic>> getWalletInfo(String address) async {
    try {
      final response = await _dio.get('/api/wallet/$address');
      return response.data;
    } catch (e) {
      // Return mock data for development
      return {
        'data': {
          'address': address,
          'balance': '0.0'
        }
      };
    }
  }

  Future<Map<String, dynamic>> createIdentity(String uid) async {
    try {
      final response = await _dio.post('/api/identity/create', data: {'uid': uid});
      return response.data;
    } catch (e) {
      // Return mock data for development
      return {'success': true};
    }
  }
}
