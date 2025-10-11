import '../models/block_model.dart';
import '../models/transaction_model.dart';
import 'explorer_repository.dart';
import '../data_sources/explorer_api_client.dart';

class ExplorerRepositoryImpl implements ExplorerRepository {
  final ExplorerApiClient apiClient;

  ExplorerRepositoryImpl({required this.apiClient});

  @override
  Future<List<BlockModel>> getRecentBlocks() async {
    final data = await apiClient.fetchRecentBlocks();
    return data.map((item) => BlockModel.fromJson(item)).toList();
  }

  @override
  Future<List<TransactionModel>> getRecentTransactions() async {
    final data = await apiClient.fetchTransactions();
    return data.map((item) => TransactionModel.fromJson(item)).toList();
  }

  @override
  Future<List<BlockModel>> search(String query) async {
    final data = await apiClient.search(query);
    return data.map((item) => BlockModel.fromJson(item)).toList();
  }

  @override
  Future<List<BlockModel>> getBlocksByAddress(String address) async {
    final data = await apiClient.fetchBlocksByAddress(address);
    return data.map((item) => BlockModel.fromJson(item)).toList();
  }

  @override
  Future<List<BlockModel>> getBlockByHash(String hash) async {
    final data = await apiClient.fetchBlockByHash(hash);
    return [BlockModel.fromJson(data)];
  }

  @override
  Future<List<BlockModel>> getBlockByNumber(int blockNumber) async {
    final data = await apiClient.fetchBlockByNumber(blockNumber);
    return [BlockModel.fromJson(data)];
  }
}
