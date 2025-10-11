import 'dart:convert';
import 'dart:typed_data';
import 'package:hex/hex.dart';
import '../utils/logger.dart';
import 'crypto_service.dart';
import 'package:pinenacl/ed25519.dart';

/// Custom exception for transaction signing operations
class TransactionSigningException implements Exception {
  final String message;
  
  const TransactionSigningException(this.message);
  
  @override
  String toString() => 'TransactionSigningException: $message';
}

/// Service for signing blockchain transactions using ECDSA
class TransactionSigningService {
  final CryptoService _cryptoService;

  TransactionSigningService(this._cryptoService);

  /// Signs a transaction with the provided private key
  Future<String> signTransaction({
    required Map<String, dynamic> transaction,
    required String privateKey,
  }) async {
    try {
      // Serialize transaction to JSON
      final transactionJson = jsonEncode(transaction);
      
      // Sign the transaction
      final signature = await _cryptoService.signMessage(transactionJson, privateKey);
      
      // Encode signature as hex
      return signature;
    } catch (e) {
      AppLogger.logError('Failed to sign transaction', e);
      throw TransactionSigningException('Failed to sign transaction: $e');
    }
  }
  
  /// Verifies a transaction signature
  Future<bool> verifyTransactionSignature({
    required Map<String, dynamic> transaction,
    required String signature,
    required String publicKey,
  }) async {
    try {
      // Serialize transaction to JSON
      final transactionJson = jsonEncode(transaction);
      
      // Verify the signature
      return await _cryptoService.verifySignature(transactionJson, signature, publicKey);
    } catch (e) {
      AppLogger.logError('Failed to verify transaction signature', e);
      return false;
    }
  }
  
  /// Creates a complete signed transaction
  Future<Map<String, dynamic>> createSignedTransaction({
    required String sender,
    required String recipient,
    required double amount,
    required int nonce,
    required String privateKey,
    String? data,
    double fee = 0.0,
  }) async {
    try {
      // Create the transaction object
      final transaction = {
        'sender': sender,
        'recipient': recipient,
        'amount': amount,
        'fee': fee,
        'nonce': nonce,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'data': data,
      };
      
      // Sign the transaction
      final signature = await signTransaction(
        transaction: transaction,
        privateKey: privateKey,
      );
      
      // Add signature to transaction
      transaction['signature'] = signature;
      
      return transaction;
    } catch (e) {
      AppLogger.logError('Failed to create signed transaction', e);
      throw TransactionSigningException('Failed to create signed transaction: $e');
    }
  }
  
  /// Hashes a transaction using SHA-256
  String hashTransaction(Map<String, dynamic> transaction) {
    try {
      // Remove signature from transaction for hashing (if present)
      final transactionCopy = Map<String, dynamic>.from(transaction);
      transactionCopy.remove('signature');
      
      // Serialize transaction to JSON
      final transactionJson = jsonEncode(transactionCopy);
      
      // Hash the transaction
      return _cryptoService.sha256Hash(transactionJson);
    } catch (e) {
      AppLogger.logError('Failed to hash transaction', e);
      throw TransactionSigningException('Failed to hash transaction: $e');
    }
  }
}
