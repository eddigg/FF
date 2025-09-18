import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/export.dart' as pc;
import 'package:hex/hex.dart';
import '../utils/logger.dart';
import 'crypto_service.dart';

/// Custom exception for transaction signing operations
class TransactionSigningException implements Exception {
  final String message;
  
  const TransactionSigningException(this.message);
  
  @override
  String toString() => 'TransactionSigningException: $message';
}

/// Service for signing blockchain transactions using ECDSA
class TransactionSigningService {
  /// Signs a transaction with the provided private key
  static String signTransaction({
    required Map<String, dynamic> transaction,
    required pc.ECPrivateKey privateKey,
  }) {
    try {
      // Serialize transaction to JSON
      final transactionJson = jsonEncode(transaction);
      final transactionBytes = utf8.encode(transactionJson);
      
      // Sign the transaction
      final signatureBytes = CryptoService.signMessage(
        Uint8List.fromList(transactionBytes),
        privateKey,
      );
      
      // Encode signature as hex
      return HEX.encode(signatureBytes);
    } catch (e) {
      AppLogger.logError('Failed to sign transaction', e);
      throw TransactionSigningException('Failed to sign transaction: $e');
    }
  }
  
  /// Verifies a transaction signature
  static bool verifyTransactionSignature({
    required Map<String, dynamic> transaction,
    required String signature,
    required pc.ECPublicKey publicKey,
  }) {
    try {
      // Serialize transaction to JSON
      final transactionJson = jsonEncode(transaction);
      final transactionBytes = utf8.encode(transactionJson);
      
      // Decode signature from hex
      final signatureBytes = Uint8List.fromList(HEX.decode(signature));
      
      // Verify the signature
      return CryptoService.verifySignature(
        Uint8List.fromList(transactionBytes),
        signatureBytes,
        publicKey,
      );
    } catch (e) {
      AppLogger.logError('Failed to verify transaction signature', e);
      return false;
    }
  }
  
  /// Creates a complete signed transaction
  static Map<String, dynamic> createSignedTransaction({
    required String sender,
    required String recipient,
    required double amount,
    required int nonce,
    required pc.ECPrivateKey privateKey,
    String? data,
    double fee = 0.0,
  }) {
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
      final signature = signTransaction(
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
  static String hashTransaction(Map<String, dynamic> transaction) {
    try {
      // Remove signature from transaction for hashing (if present)
      final transactionCopy = Map<String, dynamic>.from(transaction);
      transactionCopy.remove('signature');
      
      // Serialize transaction to JSON
      final transactionJson = jsonEncode(transactionCopy);
      final transactionBytes = utf8.encode(transactionJson);
      
      // Hash the transaction
      final hash = CryptoService.sha256Hash(Uint8List.fromList(transactionBytes));
      
      // Encode hash as hex
      return HEX.encode(hash);
    } catch (e) {
      AppLogger.logError('Failed to hash transaction', e);
      throw TransactionSigningException('Failed to hash transaction: $e');
    }
  }
}