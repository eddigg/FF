import '../models/block_model.dart';
import '../models/transaction_model.dart';

abstract class ExplorerRepository {
  Future<List<BlockModel>> getRecentBlocks();
  Future<List<TransactionModel>> getRecentTransactions();
  Future<List<BlockModel>> search(String query);
  Future<List<BlockModel>> getBlocksByAddress(String address);
  Future<List<BlockModel>> getBlockByHash(String hash);
  Future<List<BlockModel>> getBlockByNumber(int blockNumber);
}
