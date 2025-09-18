import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage _storage;
  
  SecureStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
        );

  // Store a string value securely
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  // Read a string value
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  // Delete a value
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  // Clear all values
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  // Check if a key exists
  Future<bool> containsKey(String key) async {
    return await _storage.containsKey(key: key);
  }

  // Store a JSON object
  Future<void> writeJson(String key, Map<String, dynamic> json) async {
    await write(key, jsonEncode(json));
  }

  // Read a JSON object
  Future<Map<String, dynamic>?> readJson(String key) async {
    final data = await read(key);
    if (data == null) return null;
    try {
      return jsonDecode(data) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  // Store a list of strings
  Future<void> writeStringList(String key, List<String> list) async {
    await write(key, jsonEncode(list));
  }

  // Read a list of strings
  Future<List<String>?> readStringList(String key) async {
    final data = await read(key);
    if (data == null) return null;
    try {
      return List<String>.from(jsonDecode(data));
    } catch (e) {
      return null;
    }
  }
}