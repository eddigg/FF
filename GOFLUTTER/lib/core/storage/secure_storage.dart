import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// A service for securely storing sensitive data
class SecureStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  
  /// Singleton instance
  static final SecureStorage _instance = SecureStorage._internal();
  
  /// Factory constructor
  factory SecureStorage() => _instance;
  
  /// Private constructor
  SecureStorage._internal();
  
  /// Store a value securely
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }
  
  /// Read a securely stored value
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }
  
  /// Delete a securely stored value
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }
  
  /// Clear all securely stored values
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
  
  /// Check if a key exists
  Future<bool> containsKey(String key) async {
    return await _storage.containsKey(key: key);
  }
}
