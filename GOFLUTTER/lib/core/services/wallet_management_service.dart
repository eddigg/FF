import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/export.dart' as pc;
import 'package:hex/hex.dart';
import '../crypto/crypto_service.dart';
import '../crypto/secure_storage_service.dart';
import '../utils/logger.dart';

/// Custom exception for wallet management operations
class WalletManagementException implements Exception {
  final String message;
  
  const WalletManagementException(this.message);
  
  @override
  String toString() => 'WalletManagementException: $message';
}

/// Service for managing wallet operations, ported from JavaScript functionality
class WalletManagementService {
  final SecureStorageService _secureStorage;
  pc.AsymmetricKeyPair? _wallet;
  
  WalletManagementService(this._secureStorage);
  
  /// Generates a new wallet with ECDSA key pair
  Future<String> generateWallet() async {
    try {
      // Generate a new ECDSA key pair
      _wallet = CryptoService.generateKeyPair();
      
      // Save the wallet
      await _saveWallet();
      
      // Get the address
      final address = _getWalletAddress();
      
      AppLogger.log('New wallet generated successfully with address: $address');
      return address;
    } catch (e) {
      AppLogger.logError('Failed to generate wallet', e);
      throw WalletManagementException('Failed to generate wallet: $e');
    }
  }
  
  /// Saves the current wallet to secure storage
  Future<void> _saveWallet() async {
    if (_wallet == null) return;
    
    try {
      // Convert private key to hex
      final privateKeyHex = CryptoService.privateKeyToHex(_wallet!.privateKey as pc.ECPrivateKey);
      
      // Get public key and derive address
      final publicKey = _wallet!.publicKey as pc.ECPublicKey;
      final address = CryptoService.publicKeyToAddress(publicKey);
      
      // Store in secure storage
      await _secureStorage.write('wallet_private_key', privateKeyHex);
      await _secureStorage.write('wallet_address', address);
      
      AppLogger.log('Wallet saved successfully');
    } catch (e) {
      AppLogger.logError('Failed to save wallet', e);
      throw WalletManagementException('Failed to save wallet: $e');
    }
  }
  
  /// Loads wallet from secure storage
  Future<bool> loadWallet() async {
    try {
      // Check if wallet exists in storage
      final privateKeyHex = await _secureStorage.read('wallet_private_key');
      final address = await _secureStorage.read('wallet_address');
      
      if (privateKeyHex == null || address == null) {
        AppLogger.log('No wallet found in storage');
        return false;
      }
      
      // Convert hex to private key
      final privateKey = CryptoService.hexToPrivateKey(privateKeyHex);
      
      // Derive public key
      final publicKey = CryptoService.derivePublicKey(privateKey);
      
      // Set wallet
      _wallet = pc.AsymmetricKeyPair(publicKey, privateKey);
      
      AppLogger.log('Wallet loaded successfully');
      return true;
    } catch (e) {
      AppLogger.logError('Failed to load wallet', e);
      return false;
    }
  }
  
  /// Gets the wallet address
  String _getWalletAddress() {
    if (_wallet == null) {
      throw const WalletManagementException('Wallet not loaded');
    }
    
    final publicKey = _wallet!.publicKey as pc.ECPublicKey;
    return CryptoService.publicKeyToAddress(publicKey);
  }
  
  /// Gets the wallet address or a default value if not loaded
  Future<String> getWalletAddress() async {
    try {
      if (_wallet == null) {
        // Try to load wallet first
        final loaded = await loadWallet();
        if (!loaded) {
          return '(not loaded)';
        }
      }
      
      return _getWalletAddress();
    } catch (e) {
      AppLogger.logError('Failed to get wallet address', e);
      return '(not loaded)';
    }
  }
  
  /// Signs a transaction
  Future<String> signTransaction(Map<String, dynamic> tx) async {
    if (_wallet == null) {
      // Try to load wallet
      final loaded = await loadWallet();
      if (!loaded) {
        throw const WalletManagementException('Wallet or private key not loaded. Please generate or load your wallet.');
      }
    }
    
    try {
      // Create transaction data string
      final dataString = '${tx['Sender']}${tx['Recipient']}${tx['Amount']}${tx['Fee'] ?? 0}${tx['Timestamp']}${tx['Nonce']}${tx['Data'] ?? ''}';
      final dataBytes = Uint8List.fromList(utf8.encode(dataString));
      
      // Sign the transaction
      final signatureBytes = CryptoService.signMessage(
        dataBytes,
        _wallet!.privateKey as pc.ECPrivateKey,
      );
      
      // Convert signature to hex
      final signature = HEX.encode(signatureBytes);
      
      AppLogger.log('Transaction signed successfully. Signature length: ${signature.length}');
      return signature;
    } catch (e) {
      AppLogger.logError('Failed to sign transaction', e);
      throw WalletManagementException('Failed to sign transaction: $e');
    }
  }
  
  /// Exports the wallet data
  Future<Map<String, String?>> exportWallet() async {
    try {
      final privateKey = await _secureStorage.read('wallet_private_key');
      final address = await _secureStorage.read('wallet_address');
      
      return {
        'privateKey': privateKey,
        'address': address,
      };
    } catch (e) {
      AppLogger.logError('Failed to export wallet', e);
      throw WalletManagementException('Failed to export wallet: $e');
    }
  }
  
  /// Imports wallet data
  Future<void> importWallet(String privateKeyHex) async {
    try {
      // Validate private key format
      if (!RegExp(r'^[0-9a-fA-F]{64}$').hasMatch(privateKeyHex)) {
        throw const WalletManagementException('Invalid private key format');
      }
      
      // Convert hex to private key
      final privateKey = CryptoService.hexToPrivateKey(privateKeyHex);
      
      // Derive public key and address
      final publicKey = CryptoService.derivePublicKey(privateKey);
      final address = CryptoService.publicKeyToAddress(publicKey);
      
      // Set wallet
      _wallet = pc.AsymmetricKeyPair(publicKey, privateKey);
      
      // Save to secure storage
      await _secureStorage.write('wallet_private_key', privateKeyHex);
      await _secureStorage.write('wallet_address', address);
      
      AppLogger.log('Wallet imported successfully');
    } catch (e) {
      AppLogger.logError('Failed to import wallet', e);
      throw WalletManagementException('Failed to import wallet: $e');
    }
  }
  
  /// Clears wallet data
  Future<void> clearWallet() async {
    try {
      await _secureStorage.delete('wallet_private_key');
      await _secureStorage.delete('wallet_address');
      _wallet = null;
      
      AppLogger.log('Wallet cleared successfully');
    } catch (e) {
      AppLogger.logError('Failed to clear wallet', e);
      throw WalletManagementException('Failed to clear wallet: $e');
    }
  }
  
  /// Checks if wallet exists
  Future<bool> walletExists() async {
    try {
      final privateKey = await _secureStorage.read('wallet_private_key');
      final address = await _secureStorage.read('wallet_address');
      
      return privateKey != null && address != null;
    } catch (e) {
      AppLogger.logError('Failed to check wallet existence', e);
      return false;
    }
  }
}