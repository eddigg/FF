import 'package:atlas_blockchain_flutter/features/contracts/domain/entities/contract.dart';

abstract class ContractRepository {
  Future<List<Contract>> getDeployedContracts(String userId);
  Future<Contract> deployContract(String userId, String bytecode, Map<String, dynamic> abi);
  Future<dynamic> executeContract(String userId, String contractAddress, String method, List<dynamic> args);
  Future<Contract> getContract(String contractAddress);
}
