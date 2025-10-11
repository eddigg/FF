import 'dart:convert';
import '../models/contract_model.dart';
import '../models/contract_example_model.dart';
import 'contracts_repository.dart';
import '../data_sources/contracts_api_client.dart';

class ContractsRepositoryImpl implements ContractsRepository {
  final ContractsApiClient apiClient;

  ContractsRepositoryImpl({required this.apiClient});

  @override
  Future<List<ContractModel>> getDeployedContracts() async {
    try {
      final data = await apiClient.fetchDeployedContracts();
      return data.map<ContractModel>((item) => ContractModel.fromJson(item)).toList();
    } catch (e) {
      // Return empty list if there's an error
      return [];
    }
  }

  @override
  Future<List<ContractExampleModel>> getContractExamples() async {
    try {
      // Return predefined examples since the API might not have them
      return [
        const ContractExampleModel(
          name: '🪙 Simple Token',
          description: 'A basic token contract with transfer and balance functions',
        ),
        const ContractExampleModel(
          name: '🗳️ Voting System',
          description: 'A simple voting contract for proposals',
        ),
        const ContractExampleModel(
          name: '🔒 Escrow Service',
          description: 'An escrow contract for secure transactions',
        ),
      ];
    } catch (e) {
      // Return empty list if there's an error
      return [];
    }
  }

  @override
  Future<ContractModel> getContractInfo(String address) async {
    try {
      final data = await apiClient.fetchContractInfo(address);
      return ContractModel.fromJson(data);
    } catch (e) {
      // Return a default contract model if there's an error
      return ContractModel(
        name: 'Unknown Contract',
        address: address,
        owner: 'Unknown',
        version: '1.0',
        createdAt: DateTime.now(),
        functions: const [],
      );
    }
  }

  @override
  Future<void> deployContract(String name, String version, String owner, String code) async {
    try {
      // Parse the code to ensure it's valid JSON
      jsonDecode(code);
      
      // Deploy the contract
      await apiClient.deployContract(name, version, owner, code);
    } catch (e) {
      // Re-throw the error so it can be handled by the BLoC
      throw Exception('Failed to deploy contract: $e');
    }
  }

  @override
  Future<void> callContractFunction(String address, String functionName, List<dynamic> args, String caller, int gasLimit) async {
    try {
      await apiClient.callContractFunction(address, functionName, args, caller, gasLimit);
    } catch (e) {
      // Re-throw the error so it can be handled by the BLoC
      throw Exception('Failed to call contract function: $e');
    }
  }
}
