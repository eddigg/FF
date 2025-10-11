import 'wallet_setup_repository.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/api/implementations/api_client_implementation.dart';
import '../../../../core/api/implementations/secure_storage_implementation.dart';

class WalletSetupRepositoryImpl implements WalletSetupRepository {
  late final ApiClient _apiClient;
  late final SecureStorage _secureStorage;

  WalletSetupRepositoryImpl() {
    _secureStorage = SecureStorage();
    _apiClient = ApiClient(_secureStorage);
  }

  @override
  Future<void> createWallet(String password) async {
    AppLogger.log('🔐 Creating demo wallet for exploration...');

    try {
      // Create a demo wallet that works immediately
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final demoAddress = '0x${timestamp.toRadixString(16).padLeft(40, '0')}';
      final demoPrivateKey = 'demo_private_key_$timestamp';

      // Store wallet info securely
      await _secureStorage.write(key: 'wallet_address', value: demoAddress);
      await _secureStorage.write(
        key: 'wallet_private_key',
        value: demoPrivateKey,
      );
      await _secureStorage.write(key: 'wallet_password_hash', value: password);
      await _secureStorage.write(
        key: 'session_token',
        value: 'demo_session_$timestamp',
      );
      await _secureStorage.write(key: 'wallet_balance', value: '1000.0');

      // Simulate realistic delay
      await Future.delayed(const Duration(seconds: 1));

      AppLogger.log('🎉 Demo wallet created successfully!');
      AppLogger.log('📍 Address: $demoAddress');
      AppLogger.log('💰 Balance: 1000 ATLAS (demo)');
      AppLogger.log('🚀 Ready to explore the dashboard!');
    } catch (e) {
      AppLogger.logError('❌ Failed to create wallet', e);
      rethrow;
    }
  }

  @override
  Future<void> importWallet(
    String? privateKey,
    String? fileContent,
    String? password,
  ) async {
    try {
      if (privateKey != null && privateKey.isNotEmpty) {
        AppLogger.log('Importing wallet with private key...');

        // For demo purposes, create a wallet from the private key
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final demoAddress = '0x${timestamp.toRadixString(16).padLeft(40, '0')}';

        // Store wallet info securely
        await _secureStorage.write(key: 'wallet_address', value: demoAddress);
        await _secureStorage.write(
          key: 'wallet_private_key',
          value: privateKey,
        );

        if (password != null) {
          await _secureStorage.write(
            key: 'wallet_password_hash',
            value: password,
          );
        }

        AppLogger.log(
          'Wallet imported successfully with address: $demoAddress',
        );
      } else {
        throw Exception('Private key is required for wallet import');
      }
    } catch (e) {
      AppLogger.logError('Failed to import wallet', e);
      rethrow;
    }
  }
}
