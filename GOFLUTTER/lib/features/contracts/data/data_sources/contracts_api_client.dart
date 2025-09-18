
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';

class ContractsApiClient {
  final ApiClient _apiClient;

  ContractsApiClient(this._apiClient);

  Future<List<dynamic>> fetchDeployedContracts() async {
    try {
      final response = await _apiClient.dio.get('/contract/list');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch deployed contracts: $e');
    }
  }

  Future<List<dynamic>> fetchContractExamples() async {
    try {
      final response = await _apiClient.dio.get('/contract/examples');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch contract examples: $e');
    }
  }

  Future<Map<String, dynamic>> fetchContractInfo(String address) async {
    try {
      final response = await _apiClient.dio.get('/contract/info?address=$address');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch contract info: $e');
    }
  }

  Future<void> deployContract(String name, String version, String owner, String code) async {
    try {
      await _apiClient.dio.post('/contract/deploy', data: {
        'name': name,
        'version': version,
        'owner': owner,
        'code': code,
      });
    } on DioException catch (e) {
      throw Exception('Failed to deploy contract: $e');
    }
  }

  Future<void> callContractFunction(String address, String functionName, List<dynamic> args, String caller, int gasLimit) async {
    try {
      await _apiClient.dio.post('/contract/call', data: {
        'contract_address': address,
        'function': functionName,
        'args': args,
        'caller': caller,
        'gas_limit': gasLimit,
      });
    } on DioException catch (e) {
      throw Exception('Failed to call contract function: $e');
    }
  }
}
