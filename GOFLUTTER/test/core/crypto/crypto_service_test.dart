import 'package:flutter_test/flutter_test.dart';
import 'package:atlas_blockchain_flutter/core/crypto/crypto_service.dart';
import 'dart:typed_data';
import 'package:pointycastle/export.dart' as pc_export;

void main() {
  group('CryptoService Tests', () {
    test('generateKeyPair creates a valid key pair', () {
      final keyPair = CryptoService.generateKeyPair();
      
      expect(keyPair, isNotNull);
      expect(keyPair.privateKey, isNotNull);
      expect(keyPair.publicKey, isNotNull);
      
      final privateKey = keyPair.privateKey as pc_export.ECPrivateKey;
      final publicKey = keyPair.publicKey as pc_export.ECPublicKey;
      
      expect(privateKey.d, isNotNull);
      expect(publicKey.Q, isNotNull);
    });

    test('privateKeyToHex and hexToPrivateKey are inverses', () {
      final keyPair = CryptoService.generateKeyPair();
      final privateKey = keyPair.privateKey as pc_export.ECPrivateKey;
      
      final hex = CryptoService.privateKeyToHex(privateKey);
      expect(hex, isNotNull);
      expect(hex.length, 64); // 32 bytes = 64 hex characters
      
      final restoredPrivateKey = CryptoService.hexToPrivateKey(hex);
      expect(restoredPrivateKey.d, privateKey.d);
    });

    test('derivePublicKey generates a valid public key', () {
      final keyPair = CryptoService.generateKeyPair();
      final privateKey = keyPair.privateKey as pc_export.ECPrivateKey;
      
      final publicKey = CryptoService.derivePublicKey(privateKey);
      expect(publicKey, isNotNull);
      expect(publicKey.Q, isNotNull);
    });

    test('publicKeyToAddress generates a valid address', () {
      final keyPair = CryptoService.generateKeyPair();
      final publicKey = keyPair.publicKey as pc_export.ECPublicKey;
      
      final address = CryptoService.publicKeyToAddress(publicKey);
      expect(address, isNotNull);
      expect(address.startsWith('0x'), isTrue);
      expect(address.length, 42); // '0x' + 40 hex characters
    });

    test('signMessage and verifySignature work correctly', () {
      final keyPair = CryptoService.generateKeyPair();
      final privateKey = keyPair.privateKey as pc_export.ECPrivateKey;
      final publicKey = keyPair.publicKey as pc_export.ECPublicKey;
      
      final message = Uint8List.fromList('Hello, World!'.codeUnits);
      final signature = CryptoService.signMessage(message, privateKey);
      
      expect(signature, isNotNull);
      expect(signature.isNotEmpty, isTrue);
      
      final isValid = CryptoService.verifySignature(message, signature, publicKey);
      expect(isValid, isTrue);
    });

    test('sha256Hash produces consistent output', () {
      final data = Uint8List.fromList('Hello, World!'.codeUnits);
      final hash1 = CryptoService.sha256Hash(data);
      final hash2 = CryptoService.sha256Hash(data);
      
      expect(hash1, equals(hash2));
      expect(hash1.length, 32); // SHA-256 produces 32 bytes
    });
  });
}