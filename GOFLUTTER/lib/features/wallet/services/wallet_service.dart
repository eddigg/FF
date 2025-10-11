import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/api/blockchain_api_service.dart';
import '../../../core/crypto/crypto_service.dart';

class WalletService {
  final CryptoService _cryptoService;
  final BlockchainApiService _blockchainApiService;
  final _secureStorage = const FlutterSecureStorage();

  WalletService(this._cryptoService, this._blockchainApiService);

  Future<String> createWallet() async {
    final mnemonic = await _cryptoService.generateMnemonicAndPrivateKey();
    return mnemonic;
  }

  Future<void> importWallet(String mnemonic) async {
    final privateKey = await _cryptoService.getPrivateKeyFromMnemonic(mnemonic);
    if (privateKey != null) {
      await _secureStorage.write(key: 'privateKey', value: privateKey);
    }
  }

  Future<double> getWalletBalance() async {
    final address = await getAddress();
    if (address != null) {
      return await _blockchainApiService.getBalance(address);
    }
    return 0.0;
  }

  Future<String?> getAddress() async {
    final privateKey = await _secureStorage.read(key: 'privateKey');
    if (privateKey != null) {
      final publicKey = await _cryptoService.getPublicKey(privateKey);
      return publicKey; // Assuming address is the public key for now
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getTransactionHistory() async {
    final address = await getAddress();
    if (address != null) {
      return await _blockchainApiService.getTransactionHistory(address);
    }
    return [];
  }

  Future<void> sendTransaction(String recipientAddress, int amount) async {
    final privateKey = await _secureStorage.read(key: 'privateKey');
    if (privateKey != null) {
      final publicKey = await _cryptoService.getPublicKey(privateKey);
      final fromAddress = publicKey; // Assuming address is the public key for now
      final transaction = '{"from":"$fromAddress","to":"$recipientAddress","amount":$amount}';
      final signature = await _cryptoService.signTransaction(transaction, privateKey);
      await _blockchainApiService.submitTransaction(
        from: fromAddress,
        to: recipientAddress,
        amount: amount,
        fee: 10, // TODO: Calculate fee
        signature: signature,
      );
    }
  }
}
