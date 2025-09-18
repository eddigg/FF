import 'dart:math';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';
import 'package:pointycastle/export.dart' as pc;
import '../utils/logger.dart';

/// Custom exception for secure storage operations
class SecureStorageException implements Exception {
  final String message;
  
  const SecureStorageException(this.message);
  
  @override
  String toString() => 'SecureStorageException: $message';
}

/// Enhanced secure storage service with encryption capabilities
class SecureStorageService {
  static const String _storageKey = 'atlas_blockchain_storage_key';
  
  final FlutterSecureStorage _secureStorage;
  final String _encryptionKey;
  
  SecureStorageService(this._secureStorage, {String? encryptionKey}) 
      : _encryptionKey = encryptionKey ?? 'atlas_blockchain_secure_key_32_chars!';
  
  /// Encrypts data using AES-256
  String _encrypt(String plainText) {
    try {
      final key = _deriveKey(_encryptionKey);
      final iv = _generateIV();
      
      final cipher = pc.AESEngine();
      final blockCipher = pc.CBCBlockCipher(cipher);
      final parameters = pc.ParametersWithIV(pc.KeyParameter(key), iv);
      
      blockCipher.init(true, parameters);
      
      // Pad the plaintext to block size
      final paddedText = _padToBlocksize(utf8.encode(plainText));
      
      // Encrypt the data
      final encrypted = Uint8List(paddedText.length);
      for (int i = 0; i < paddedText.length; i += blockCipher.blockSize) {
        blockCipher.processBlock(paddedText, i, encrypted, i);
      }
      
      // Combine IV and encrypted data
      final result = Uint8List(iv.length + encrypted.length);
      result.setAll(0, iv);
      result.setAll(iv.length, encrypted);
      
      return base64Encode(result);
    } catch (e) {
      AppLogger.logError('Failed to encrypt data', e);
      throw SecureStorageException('Failed to encrypt data: $e');
    }
  }
  
  /// Decrypts data using AES-256
  String _decrypt(String encryptedText) {
    try {
      final encryptedBytes = base64Decode(encryptedText);
      
      // Extract IV and encrypted data
      const ivLength = 16; // AES block size
      final iv = encryptedBytes.sublist(0, ivLength);
      final encryptedData = encryptedBytes.sublist(ivLength);
      
      final key = _deriveKey(_encryptionKey);
      
      final cipher = pc.AESEngine();
      final blockCipher = pc.CBCBlockCipher(cipher);
      final parameters = pc.ParametersWithIV(pc.KeyParameter(key), iv);
      
      blockCipher.init(false, parameters);
      
      // Decrypt the data
      final decrypted = Uint8List(encryptedData.length);
      for (int i = 0; i < encryptedData.length; i += blockCipher.blockSize) {
        blockCipher.processBlock(encryptedData, i, decrypted, i);
      }
      
      // Remove padding
      final unpadded = _removePadding(decrypted);
      
      return utf8.decode(unpadded);
    } catch (e) {
      AppLogger.logError('Failed to decrypt data', e);
      throw SecureStorageException('Failed to decrypt data: $e');
    }
  }
  
  /// Derives a 256-bit key from the encryption key using SHA-256
  Uint8List _deriveKey(String key) {
    final bytes = utf8.encode(key);
    final hash = sha256.convert(bytes);
    return Uint8List.fromList(hash.bytes);
  }
  
  /// Generates a random initialization vector
  Uint8List _generateIV() {
    final randomBytes = Uint8List(16); // AES block size
    
    final secureRandom = Random.secure();
    for (int i = 0; i < 16; i++) {
      randomBytes[i] = secureRandom.nextInt(256);
    }
    
    return randomBytes;
  }
  
  /// Pads data to block size using PKCS7
  Uint8List _padToBlocksize(List<int> data) {
    const blockSize = 16; // AES block size
    final padding = blockSize - (data.length % blockSize);
    final padded = Uint8List(data.length + padding);
    padded.setAll(0, data);
    
    for (int i = data.length; i < padded.length; i++) {
      padded[i] = padding;
    }
    
    return padded;
  }
  
  /// Removes PKCS7 padding
  Uint8List _removePadding(Uint8List data) {
    if (data.isEmpty) return data;
    
    final padding = data[data.length - 1];
    if (padding > 16) return data; // Invalid padding
    
    // Verify padding
    for (int i = data.length - padding; i < data.length; i++) {
      if (data[i] != padding) return data; // Invalid padding
    }
    
    return Uint8List.view(data.buffer, 0, data.length - padding);
  }
  
  /// Writes encrypted data to secure storage
  Future<void> write(String key, String value) async {
    try {
      // Encrypt the value before storing
      final encryptedValue = _encrypt(value);
      
      // Store with a prefixed key to avoid conflicts
      final storageKey = '$_storageKey:$key';
      await _secureStorage.write(key: storageKey, value: encryptedValue);
    } catch (e) {
      AppLogger.logError('Failed to write to secure storage', e);
      throw SecureStorageException('Failed to write to secure storage: $e');
    }
  }
  
  /// Reads and decrypts data from secure storage
  Future<String?> read(String key) async {
    try {
      // Read encrypted value
      final storageKey = '$_storageKey:$key';
      final encryptedValue = await _secureStorage.read(key: storageKey);
      
      if (encryptedValue == null) {
        return null;
      }
      
      // Decrypt the value
      return _decrypt(encryptedValue);
    } catch (e) {
      AppLogger.logError('Failed to read from secure storage', e);
      throw SecureStorageException('Failed to read from secure storage: $e');
    }
  }
  
  /// Deletes data from secure storage
  Future<void> delete(String key) async {
    try {
      final storageKey = '$_storageKey:$key';
      await _secureStorage.delete(key: storageKey);
    } catch (e) {
      AppLogger.logError('Failed to delete from secure storage', e);
      throw SecureStorageException('Failed to delete from secure storage: $e');
    }
  }
  
  /// Checks if a key exists in secure storage
  Future<bool> containsKey(String key) async {
    try {
      final storageKey = '$_storageKey:$key';
      return await _secureStorage.containsKey(key: storageKey);
    } catch (e) {
      AppLogger.logError('Failed to check key existence', e);
      return false;
    }
  }
  
  /// Reads all keys from secure storage
  Future<List<String>> getAllKeys() async {
    try {
      final allKeys = await _secureStorage.readAll();
      return allKeys.keys
          .where((key) => key.startsWith(_storageKey))
          .map((key) => key.substring(_storageKey.length + 1))
          .toList();
    } catch (e) {
      AppLogger.logError('Failed to read all keys', e);
      throw SecureStorageException('Failed to read all keys: $e');
    }
  }
  
  /// Clears all data from secure storage
  Future<void> clearAll() async {
    try {
      final allKeys = await _secureStorage.readAll();
      final keysToDelete = allKeys.keys
          .where((key) => key.startsWith(_storageKey))
          .toList();
      
      for (final key in keysToDelete) {
        await _secureStorage.delete(key: key);
      }
    } catch (e) {
      AppLogger.logError('Failed to clear secure storage', e);
      throw SecureStorageException('Failed to clear secure storage: $e');
    }
  }
}