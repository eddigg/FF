import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:goflutter/core/api/blockchain_api_service.dart';
import 'package:goflutter/core/crypto/crypto_service.dart';
import 'package:goflutter/features/wallet/services/wallet_service.dart';

class MockCryptoService extends Mock implements CryptoService {}

class MockBlockchainApiService extends Mock implements BlockchainApiService {}

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  group('WalletService', () {
    late WalletService walletService;
    late MockCryptoService mockCryptoService;
    late MockBlockchainApiService mockBlockchainApiService;
    late MockFlutterSecureStorage mockFlutterSecureStorage;

    setUp(() {
      mockCryptoService = MockCryptoService();
      mockBlockchainApiService = MockBlockchainApiService();
      mockFlutterSecureStorage = MockFlutterSecureStorage();
      walletService = WalletService(mockCryptoService, mockBlockchainApiService);
    });

    test('createWallet returns a mnemonic', () async {
      // TODO: Implement test
    });
  });
}
