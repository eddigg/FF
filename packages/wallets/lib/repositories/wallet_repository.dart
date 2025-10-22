import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/wallet.dart';
import '../models/transaction.dart';
import '../services/storage/secure_storage.dart';

abstract class WalletRepository {
  Future<Wallet?> getCachedWallet(String? userId);
  Future<void> saveWallet(Wallet wallet);
  Future<List<Transaction>> getRecentTransactions();
  Future<bool> isValidAddress(String address);
  Future<String> generateNewAddress();
  Future<Wallet> createWalletFromSeed(String seedPhrase);
  Future<void> clearCache();
}

class WalletRepositoryImpl implements WalletRepository {
  static const String _walletKey = 'cached_wallet';
  static const String _transactionsKey = 'recent_transactions';

  final SecureStorage _secureStorage;
  final SharedPreferences _prefs;

  WalletRepositoryImpl({
    required SecureStorage secureStorage,
    required SharedPreferences prefs,
  })  : _secureStorage = secureStorage,
        _prefs = prefs;

  @override
  Future<Wallet?> getCachedWallet(String? userId) async {
    try {
      final cachedData = _prefs.getString(_walletKey);
      if (cachedData == null) return null;

      final walletData = jsonDecode(cachedData) as Map<String, dynamic>;

      // Verify user ID if provided
      if (userId != null && walletData['userId'] != userId) {
        return null;
      }

      return Wallet.fromJson(walletData);
    } catch (e) {
      // Clear corrupted cache
      await clearCache();
      return null;
    }
  }

  @override
  Future<void> saveWallet(Wallet wallet) async {
    final walletData = jsonEncode(wallet.toJson());
    await _prefs.setString(_walletKey, walletData);

    // Also cache in secure storage for sensitive data
    await _secureStorage.write('wallet_private_key', wallet.privateKey);
    await _secureStorage.write('wallet_encrypted_key', wallet.encryptedPrivateKey);
  }

  @override
  Future<List<Transaction>> getRecentTransactions() async {
    try {
      final cachedData = _prefs.getString(_transactionsKey);
      if (cachedData == null) return [];

      final transactionsData = jsonDecode(cachedData) as List<dynamic>;
      return transactionsData
          .map((data) => Transaction.fromJson(data as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveRecentTransactions(List<Transaction> transactions) async {
    // Keep only the most recent 20 transactions for cache
    final recentTransactions = transactions.take(20).toList();
    final transactionsData = jsonEncode(recentTransactions.map((t) => t.toJson()).toList());
    await _prefs.setString(_transactionsKey, transactionsData);
  }

  @override
  Future<bool> isValidAddress(String address) async {
    // Basic validation - can be enhanced with blockchain rules
    if (address.length < 20 || address.length > 100) return false;

    // Check for common address formats
    final hasValidChars = RegExp(r'^[a-zA-Z0-9]+$', caseSensitive: false).hasMatch(address);
    return hasValidChars;
  }

  @override
  Future<String> generateNewAddress() async {
    // This would typically use the blockchain's wallet generation
    // For now, return a placeholder
    // In a real implementation, this would call the blockchain service
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    return 'atlas_addr_$timestamp';
  }

  @override
  Future<Wallet> createWalletFromSeed(String seedPhrase) async {
    // Validate seed phrase length (typical BIP39 has 12 or 24 words)
    final words = seedPhrase.trim().split(' ');
    if (words.length != 12 && words.length != 24) {
      throw Exception('Invalid seed phrase: must be 12 or 24 words');
    }

    // In a real implementation, this would use cryptographic functions
    // to derive the keys from the seed phrase
    final mockPrivateKey = 'mock_private_key_from_seed_${seedPhrase.hashCode}';
    final mockPublicKey = 'mock_public_key_from_seed_${seedPhrase.hashCode}';

    final wallet = Wallet(
      userId: 'new_wallet_${DateTime.now().millisecondsSinceEpoch}',
      address: await generateNewAddress(),
      privateKey: mockPrivateKey,
      publicKey: mockPublicKey,
      encryptedPrivateKey: base64Encode(utf8.encode(mockPrivateKey)),
      balance: 0.0,
      createdAt: DateTime.now(),
    );

    await saveWallet(wallet);
    return wallet;
  }

  @override
  Future<void> clearCache() async {
    await _prefs.remove(_walletKey);
    await _prefs.remove(_transactionsKey);
    await _secureStorage.delete('wallet_private_key');
    await _secureStorage.delete('wallet_encrypted_key');
  }

  // Additional utility methods
  Future<bool> hasCachedWallet() async {
    final wallet = await getCachedWallet(null);
    return wallet != null;
  }

  Future<void> updateTransactionCache(List<Transaction> transactions) async {
    await saveRecentTransactions(transactions);
  }

  // Wallet backup and recovery
  Future<String> exportWalletBackup(Wallet wallet) async {
    final backupData = {
      'wallet': wallet.toJson(),
      'lastBackup': DateTime.now().toIso8601String(),
      'exportedBy': 'ATLAS Wallet Portal',
    };

    return jsonEncode(backupData);
  }

  Future<Wallet?> importWalletBackup(String backupData) async {
    try {
      final backupJson = jsonDecode(backupData) as Map<String, dynamic>;
      final walletData = backupJson['wallet'] as Map<String, dynamic>;

      final wallet = Wallet.fromJson(walletData);
      await saveWallet(wallet);

      return wallet;
    } catch (e) {
      throw Exception('Invalid backup data format');
    }
  }
}
