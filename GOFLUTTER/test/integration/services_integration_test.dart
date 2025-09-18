import 'package:flutter_test/flutter_test.dart';
import 'package:atlas_blockchain_flutter/core/crypto/crypto_service.dart';
import 'package:atlas_blockchain_flutter/core/crypto/transaction_signing_service.dart';
import 'dart:typed_data';
import 'package:pointycastle/export.dart' as pc;

void main() {
  group('Services Integration Tests', () {
    test('Crypto services work together correctly', () {
      // Generate a key pair
      final keyPair = CryptoService.generateKeyPair();
      final privateKey = keyPair.privateKey as pc.ECPrivateKey;
      final publicKey = keyPair.publicKey as pc.ECPublicKey;
      
      // Derive address from public key
      final address = CryptoService.publicKeyToAddress(publicKey);
      expect(address, isNotNull);
      expect(address.startsWith('0x'), isTrue);
      expect(address.length, 42);
      
      // Sign a message
      final message = Uint8List.fromList('Hello, Blockchain!'.codeUnits);
      final signature = CryptoService.signMessage(message, privateKey);
      expect(signature, isNotNull);
      expect(signature.isNotEmpty, isTrue);
      
      // Verify the signature
      final isValid = CryptoService.verifySignature(message, signature, publicKey);
      expect(isValid, isTrue);
    });

    test('Transaction signing and verification work together', () {
      // Generate a key pair
      final keyPair = CryptoService.generateKeyPair();
      final privateKey = keyPair.privateKey as pc.ECPrivateKey;
      final publicKey = keyPair.publicKey as pc.ECPublicKey;
      
      // Create a transaction
      final transaction = {
        'sender': '0x1234567890123456789012345678901234567890',
        'recipient': '0x0987654321098765432109876543210987654321',
        'amount': 100.0,
        'fee': 1.0,
        'nonce': 1,
        'timestamp': 1234567890,
        'data': 'Test transaction',
      };
      
      // Sign the transaction
      final signature = TransactionSigningService.signTransaction(
        transaction: transaction,
        privateKey: privateKey,
      );
      
      expect(signature, isNotNull);
      expect(signature.isNotEmpty, isTrue);
      
      // Verify the transaction signature
      final isValid = TransactionSigningService.verifyTransactionSignature(
        transaction: transaction,
        signature: signature,
        publicKey: publicKey,
      );
      
      expect(isValid, isTrue);
    });

    test('Complete transaction flow works', () {
      // Generate a key pair
      final keyPair = CryptoService.generateKeyPair();
      final privateKey = keyPair.privateKey as pc.ECPrivateKey;
      
      // Create a signed transaction
      final transaction = TransactionSigningService.createSignedTransaction(
        sender: '0x1234567890123456789012345678901234567890',
        recipient: '0x0987654321098765432109876543210987654321',
        amount: 100.0,
        fee: 1.0,
        nonce: 1,
        privateKey: privateKey,
        data: 'Test transaction',
      );
      
      expect(transaction, isNotNull);
      expect(transaction['signature'], isNotNull);
      expect(transaction['timestamp'], isNotNull);
      
      // Hash the transaction
      final hash = TransactionSigningService.hashTransaction(transaction);
      expect(hash, isNotNull);
      expect(hash.length, 64);
    });
  });
}