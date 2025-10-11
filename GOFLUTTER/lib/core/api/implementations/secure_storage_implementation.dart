import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

/// A service for securely storing sensitive data like wallet private keys
/// using flutter_secure_storage with additional encryption.
class SecureStorage {
  // Create a single instance of FlutterSecureStorage
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  // Static key constants
  static const String keyPrivateKey = 'wallet_private_key';
  static const String keyWalletAddress = 'wallet_address';
  static const String keySessionToken = 'session_token';
  static const String keyAuthToken = 'auth_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';

  // Encryption key (in a real app, this would be generated and stored securely)
  final String _encryptionKey =
      'MySecretKey12345678901234567890'; // Exactly 32 chars for AES-256

  /// Writes a value to secure storage (simplified for demo)
  Future<void> write({required String key, required String value}) async {
    try {
      // For demo purposes, store directly without encryption
      // TODO: Re-enable encryption for production
      await _storage.write(key: key, value: value);
    } catch (e) {
      throw StorageException('Failed to write to secure storage: $e');
    }
  }

  /// Reads a value from secure storage (simplified for demo)
  Future<String?> read({required String key}) async {
    try {
      // For demo purposes, read directly without decryption
      // TODO: Re-enable decryption for production
      return await _storage.read(key: key);
    } catch (e) {
      throw StorageException('Failed to read from secure storage: $e');
    }
  }

  /// Deletes a value from secure storage
  Future<void> delete({required String key}) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      throw StorageException('Failed to delete from secure storage: $e');
    }
  }

  /// Clears all values from secure storage
  Future<void> clearStorage() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      throw StorageException('Failed to clear secure storage: $e');
    }
  }

  /// Encrypts a string value
  String _encrypt(String value) {
    try {
      final key = encrypt.Key.fromUtf8(_encryptionKey);
      final iv = encrypt.IV.fromLength(16); // AES uses 16 bytes IV
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      final encrypted = encrypter.encrypt(value, iv: iv);
      return '${encrypted.base64}|${iv.base64}';
    } catch (e) {
      throw StorageException('Encryption failed: $e');
    }
  }

  /// Decrypts a string value
  String _decrypt(String encryptedValue) {
    try {
      final parts = encryptedValue.split('|');
      if (parts.length != 2) {
        throw const FormatException('Invalid encrypted value format');
      }

      final encrypted = encrypt.Encrypted.fromBase64(parts[0]);
      final iv = encrypt.IV.fromBase64(parts[1]);
      final key = encrypt.Key.fromUtf8(_encryptionKey);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));

      return encrypter.decrypt(encrypted, iv: iv);
    } catch (e) {
      throw StorageException('Decryption failed: $e');
    }
  }

  /// Stores wallet credentials securely
  Future<void> storeWalletCredentials({
    required String privateKey,
    required String address,
    required String sessionToken,
  }) async {
    await write(key: keyPrivateKey, value: privateKey);
    await write(key: keyWalletAddress, value: address);
    await write(key: keySessionToken, value: sessionToken);
  }

  /// Retrieves wallet credentials
  Future<Map<String, String?>> getWalletCredentials() async {
    final privateKey = await read(key: keyPrivateKey);
    final address = await read(key: keyWalletAddress);
    final sessionToken = await read(key: keySessionToken);

    return {
      'privateKey': privateKey,
      'address': address,
      'sessionToken': sessionToken,
    };
  }

  /// Clears wallet credentials
  Future<void> clearWalletCredentials() async {
    await delete(key: keyPrivateKey);
    await delete(key: keyWalletAddress);
    await delete(key: keySessionToken);
  }
}

/// Exception thrown when secure storage operations fail
class StorageException implements Exception {
  final String message;

  const StorageException(this.message);

  @override
  String toString() => 'StorageException: $message';
}
