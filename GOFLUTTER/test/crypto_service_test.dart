import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pointycastle/api.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:goflutter/core/crypto/crypto_service.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  group('CryptoService', () {
    late CryptoService cryptoService;
    late MockFlutterSecureStorage mockFlutterSecureStorage;

    setUp(() {
      mockFlutterSecureStorage = MockFlutterSecureStorage();
      cryptoService = CryptoService();
    });

    test('generateMnemonicAndPrivateKey returns a valid mnemonic', () async {
      // TODO: Implement test
    });
  });
}
