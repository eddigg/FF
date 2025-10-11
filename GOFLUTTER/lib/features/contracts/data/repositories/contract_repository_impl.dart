export '../../domain/repositories/contract_repository.dart';
import 'package:atlas_blockchain_flutter/features/contracts/domain/repositories/contract_repository.dart';
import 'package:atlas_blockchain_flutter/features/contracts/domain/entities/contract.dart';
import 'package:atlas_blockchain_flutter/core/network/api_client.dart';
import 'package:dio/dio.dart';

class ContractRepositoryImpl implements ContractRepository {
  final Dio _dio = ApiClient.instance;
  
  @override
  Future<List<Contract>> getDeployedContracts(String userId) async {
    try {
      final response = await _dio.get('/api/v1/contracts/user/$userId');
      final List<dynamic> contractsData = response.data['data'];
      return contractsData.map((contract) => Contract.fromJson(contract)).toList();
    } catch (e) {
      throw Exception('Failed to fetch contracts: $e');
    }
  }
  
  @override
  Future<Contract> deployContract(String userId, String bytecode, Map<String, dynamic> abi) async {
    try {
      final response = await _dio.post('/api/v1/contracts/deploy', data: {
        'userId': userId,
        'bytecode': bytecode,
        'abi': abi,
      });
      return Contract.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Failed to deploy contract: $e');
    }
  }
  
  @override
  Future<dynamic> executeContract(String userId, String contractAddress, String method, List<dynamic> args) async {
    try {
      final response = await _dio.post('/api/v1/contracts/execute', data: {
        'userId': userId,
        'contractAddress': contractAddress,
        'method': method,
        'args': args,
      });
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to execute contract: $e');
    }
  }
  
  @override
  Future<Contract> getContract(String contractAddress) async {
    try {
      final response = await _dio.get('/api/v1/contracts/$contractAddress');
      return Contract.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Failed to fetch contract: $e');
    }
  }
}
