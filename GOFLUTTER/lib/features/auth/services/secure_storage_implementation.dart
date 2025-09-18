import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const String keyPrivateKey = 'private_key';
  static const String keyWalletAddress = 'wallet_address';
  static const String keySessionToken = 'session_token';

  final FlutterSecureStorage _storage;

  SecureStorage() : _storage = const FlutterSecureStorage();

  Future<void> write({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> clearStorage() async {
    await _storage.deleteAll();
  }
}
