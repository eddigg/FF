
import '../models/contract_model.dart';
import '../models/contract_example_model.dart';

abstract class ContractsRepository {
  Future<List<ContractModel>> getDeployedContracts();
  Future<List<ContractExampleModel>> getContractExamples();
  Future<ContractModel> getContractInfo(String address);
  Future<void> deployContract(String name, String version, String owner, String code);
  Future<void> callContractFunction(String address, String functionName, List<dynamic> args, String caller, int gasLimit);
}
