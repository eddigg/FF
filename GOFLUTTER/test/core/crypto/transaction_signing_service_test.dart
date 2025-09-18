import 'package:flutter_test/flutter_test.dart';
import 'package:atlas_blockchain_flutter/core/crypto/transaction_signing_service.dart';
import 'package:atlas_blockchain_flutter/core/crypto/crypto_service.dart';
import 'package:pointycastle/export.dart' as pc;

void main() {
  group('TransactionSigningService Tests', () {
    late pc.AsymmetricKeyPair keyPair;
    late pc.ECPrivateKey privateKey;
    late pc.ECPublicKey publicKey;

    setUp(() {
      keyPair = CryptoService.generateKeyPair();
      privateKey = keyPair.privateKey as pc.ECPrivateKey;
      publicKey = keyPair.publicKey as pc.ECPublicKey;
    });

    test('signTransaction creates a valid signature', () {
      final transaction = {
        'sender': '0x1234567890123456789012345678901234567890',
        'recipient': '0x0987654321098765432109876543210987654321',
        'amount': 100.0,
        'fee': 1.0,
        'nonce': 1,
        'timestamp': 1234567890,
        'data': 'Test transaction',
      };

      final signature = TransactionSigningService.signTransaction(
        transaction: transaction,
        privateKey: privateKey,
      );

      expect(signature, isNotNull);
      expect(signature.isNotEmpty, isTrue);
    });

    test('verifyTransactionSignature validates correct signatures', () {
      final transaction = {
        'sender': '0x1234567890123456789012345678901234567890',
        'recipient': '0x0987654321098765432109876543210987654321',
        'amount': 100.0,
        'fee': 1.0,
        'nonce': 1,
        'timestamp': 1234567890,
        'data': 'Test transaction',
      };

      final signature = TransactionSigningService.signTransaction(
        transaction: transaction,
        privateKey: privateKey,
      );

      final isValid = TransactionSigningService.verifyTransactionSignature(
        transaction: transaction,
        signature: signature,
        publicKey: publicKey,
      );

      expect(isValid, isTrue);
    });

    test('verifyTransactionSignature rejects tampered transactions', () {
      final transaction = {
        'sender': '0x1234567890123456789012345678901234567890',
        'recipient': '0x0987654321098765432109876543210987654321',
        'amount': 100.0,
        'fee': 1.0,
        'nonce': 1,
        'timestamp': 1234567890,
        'data': 'Test transaction',
      };

      final signature = TransactionSigningService.signTransaction(
        transaction: transaction,
        privateKey: privateKey,
      );

      // Tamper with the transaction
      final tamperedTransaction = Map<String, dynamic>.from(transaction);
      tamperedTransaction['amount'] = 200.0;

      final isValid = TransactionSigningService.verifyTransactionSignature(
        transaction: tamperedTransaction,
        signature: signature,
        publicKey: publicKey,
      );

      expect(isValid, isFalse);
    });

    test('createSignedTransaction creates a complete signed transaction', () {
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
      expect(transaction['sender'], '0x1234567890123456789012345678901234567890');
      expect(transaction['recipient'], '0x0987654321098765432109876543210987654321');
      expect(transaction['amount'], 100.0);
      expect(transaction['fee'], 1.0);
      expect(transaction['nonce'], 1);
      expect(transaction['data'], 'Test transaction');
      expect(transaction['signature'], isNotNull);
      expect(transaction['timestamp'], isNotNull);
    });

    test('hashTransaction creates a consistent hash', () {
      final transaction = {
        'sender': '0x1234567890123456789012345678901234567890',
        'recipient': '0x0987654321098765432109876543210987654321',
        'amount': 100.0,
        'fee': 1.0,
        'nonce': 1,
        'timestamp': 1234567890,
        'data': 'Test transaction',
      };

      final hash1 = TransactionSigningService.hashTransaction(transaction);
      final hash2 = TransactionSigningService.hashTransaction(transaction);

      expect(hash1, equals(hash2));
      expect(hash1.length, 64); // SHA-256 produces 32 bytes = 64 hex characters
    });

    test('hashTransaction excludes signature from hash calculation', () {
      final transactionWithoutSignature = {
        'sender': '0x1234567890123456789012345678901234567890',
        'recipient': '0x0987654321098765432109876543210987654321',
        'amount': 100.0,
        'fee': 1.0,
        'nonce': 1,
        'timestamp': 1234567890,
        'data': 'Test transaction',
      };

      final transactionWithSignature = Map<String, dynamic>.from(transactionWithoutSignature);
      transactionWithSignature['signature'] = 'test_signature';

      final hash1 = TransactionSigningService.hashTransaction(transactionWithoutSignature);
      final hash2 = TransactionSigningService.hashTransaction(transactionWithSignature);

      expect(hash1, equals(hash2));
    });
  });
}