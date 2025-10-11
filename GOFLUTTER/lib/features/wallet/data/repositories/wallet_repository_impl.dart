import '../models/wallet_model.dart';
import 'wallet_repository.dart';
import '../data_sources/wallet_api_client.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletApiClient apiClient;

  WalletRepositoryImpl({required this.apiClient});

  @override
  Future<WalletModel> getWallet() async {
    final data = await apiClient.fetchWalletData();
    return WalletModel.fromJson(data);
  }

  @override
  Future<void> sendTransaction(String recipient, double amount, String? message) async {
    await apiClient.sendTransaction(recipient, amount, message);
  }

  /// Requests test tokens from the faucet
  @override
  Future<Map<String, dynamic>> requestTestTokens(String address) async {
    return await apiClient.requestTestTokens(address);
  }
}
