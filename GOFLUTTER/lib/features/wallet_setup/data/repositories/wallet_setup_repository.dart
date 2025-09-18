

abstract class WalletSetupRepository {
  Future<void> createWallet(String password);
  Future<void> importWallet(String? privateKey, String? fileContent, String? password);
}
