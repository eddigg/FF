import '../models/wallet_model.dart';

abstract class WalletRepository {
  Future<WalletModel> getWallet();
  Future<void> sendTransaction(String recipient, double amount, String? message);
  Future<Map<String, dynamic>> requestTestTokens(String address);
}