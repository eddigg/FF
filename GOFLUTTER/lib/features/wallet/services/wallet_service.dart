import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';
import 'package:pointycastle/export.dart' as pc;
import 'package:hex/hex.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/network/api_client.dart';
import '../../../core/storage/secure_storage.dart';
import '../data/data_sources/wallet_api_client.dart';
import '../domain/entities/account.dart';

/// Exception thrown when wallet operations fail
class WalletException implements Exception {
  final String message;
  final int? statusCode;
  
  const WalletException(this.message, this.statusCode);
  
  @override
  String toString() => 'WalletException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

/// Service for managing wallet operations
class WalletService {
  final WalletApiClient _walletApiClient;
  final SecureStorage _secureStorage;
  
  WalletService(
    ApiClient apiClient,
    this._secureStorage,
  ) : _walletApiClient = WalletApiClient(apiClient);
  
  /// Creates a new wallet with ECDSA key pair
  Future<WalletResponse> createWallet({String? name}) async {
    try {
      // Generate a new ECDSA key pair
      final keyPair = _generateKeyPair();
      
      // Get private key as hex
      final privateKey = _privateKeyToHex(keyPair.privateKey as pc.ECPrivateKey);
      
      // Get public key and derive address
      final publicKey = keyPair.publicKey as pc.ECPublicKey;
      final address = _publicKeyToAddress(publicKey);
      
      // Create session token
      final sessionToken = _generateSessionToken();
      
      final walletResponse = WalletResponse(
        address: address,
        privateKey: privateKey,
        sessionToken: sessionToken,
      );
      
      // Store wallet credentials securely
      await _storeWalletCredentials(
        privateKey: walletResponse.privateKey,
        address: walletResponse.address,
        sessionToken: walletResponse.sessionToken,
      );
      
      return walletResponse;
    } catch (e) {
      throw WalletException('Failed to create wallet: ${e.toString()}', null);
    }
  }
  
  /// Generates a new ECDSA key pair using P-256 curve
  pc.AsymmetricKeyPair _generateKeyPair() {
    final secureRandom = pc.SecureRandom('AES/CTR');
    final random = Random.secure();
    final seeds = <int>[];
    for (int i = 0; i < 32; i++) {
      seeds.add(random.nextInt(255));
    }
    secureRandom.seed(pc.KeyParameter(Uint8List.fromList(seeds)));
    
    final domainParams = pc.ECCurve_secp256r1();
    final keyGenerator = pc.ECKeyGenerator();
    final keyParams = pc.ECKeyGeneratorParameters(domainParams);
    
    keyGenerator.init(pc.ParametersWithRandom(keyParams, secureRandom));
    return keyGenerator.generateKeyPair();
  }
  
  /// Converts private key to hex string
  String _privateKeyToHex(pc.ECPrivateKey privateKey) {
    final d = privateKey.d!;
    final bytes = _bigIntToBytes(d, 32);
    return HEX.encode(bytes);
  }
  
  /// Derives address from public key
  String _publicKeyToAddress(pc.ECPublicKey publicKey) {
    final x = publicKey.Q!.x!.toBigInteger()!;
    final y = publicKey.Q!.y!.toBigInteger()!;
    final xBytes = _bigIntToBytes(x, 32);
    final yBytes = _bigIntToBytes(y, 32);
    final pubKeyHex = HEX.encode(xBytes) + HEX.encode(yBytes);
    final pubKeyBytes = HEX.decode(pubKeyHex);
    
    // Hash the public key with SHA-256
    final sha256 = pc.SHA256Digest();
    final hash = sha256.process(Uint8List.fromList(pubKeyBytes));
    
    // Take last 20 bytes as address
    final addressBytes = hash.sublist(hash.length - 20);
    return '0x${HEX.encode(addressBytes)}';
  }
  
  /// Generates a session token
  String _generateSessionToken() {
    final random = Random.secure();
    final values = List<int>.generate(32, (i) => random.nextInt(255));
    return HEX.encode(values);
  }
  
  /// Converts BigInt to byte array with specified length
  Uint8List _bigIntToBytes(BigInt bigInt, int length) {
    final hex = bigInt.toRadixString(16).padLeft(length * 2, '0');
    return Uint8List.fromList(HEX.decode(hex));
  }
  
  /// Stores wallet credentials securely
  Future<void> _storeWalletCredentials({
    required String privateKey,
    required String address,
    required String sessionToken,
  }) async {
    await _secureStorage.write('wallet_private_key', privateKey);
    await _secureStorage.write('wallet_address', address);
    await _secureStorage.write('session_token', sessionToken);
  }
  
  /// Retrieves wallet credentials
  Future<Map<String, String?>> _getWalletCredentials() async {
    final privateKey = await _secureStorage.read('wallet_private_key');
    final address = await _secureStorage.read('wallet_address');
    final sessionToken = await _secureStorage.read('session_token');
    
    return {
      'privateKey': privateKey,
      'address': address,
      'sessionToken': sessionToken,
    };
  }
  
  /// Clears wallet credentials
  Future<void> _clearWalletCredentials() async {
    await _secureStorage.delete('wallet_private_key');
    await _secureStorage.delete('wallet_address');
    await _secureStorage.delete('session_token');
  }
  
  /// Gets wallet information
  Future<WalletInfo> getWalletInfo() async {
    try {
      // Get wallet address from secure storage
      final address = await _secureStorage.read('wallet_address');
      
      if (address == null) {
        throw const WalletException('No wallet found', null);
      }
      
      final response = await _walletApiClient.fetchWalletData();
      // For now, we'll create a simple WalletInfo object
      // In a real implementation, this would come from the API
      return WalletInfo(
        address: address,
        balance: (response['balance'] as num?)?.toDouble() ?? 0.0,
        nonce: 0,
        recentTransactions: [],
      );
    } catch (e) {
      throw WalletException('Failed to get wallet info: ${e.toString()}', null);
    }
  }
  
  /// Requests test tokens from the faucet
  Future<String> requestTestTokens() async {
    try {
      // Get wallet address from secure storage
      final address = await _secureStorage.read('wallet_address');
      
      if (address == null) {
        throw const WalletException('No wallet found', null);
      }
      
      final response = await _walletApiClient.requestTestTokens(address);
      return response['message'] ?? 'Test tokens requested successfully';
    } catch (e) {
      throw WalletException('Failed to request test tokens: ${e.toString()}', null);
    }
  }
  
  /// Sends a transaction
  Future<String> sendTransaction({
    required String to,
    required double amount,
    String? data,
  }) async {
    try {
      // Get wallet credentials
      final credentials = await _getWalletCredentials();
      
      if (credentials['privateKey'] == null || credentials['address'] == null) {
        throw const WalletException('No wallet credentials found', null);
      }
      
      // Send transaction using wallet API client
      await _walletApiClient.sendTransaction(to, amount, data);
      
      // In a real implementation, this would return the transaction hash
      return '0x${_generateSessionToken()}';
    } catch (e) {
      throw WalletException('Failed to send transaction: ${e.toString()}', null);
    }
  }
  
  /// Imports an existing wallet
  Future<WalletResponse> importWallet(String privateKey) async {
    try {
      // Validate private key format
      if (!RegExp(r'^[0-9a-fA-F]{64}$').hasMatch(privateKey)) {
        throw const WalletException('Invalid private key format', null);
      }
      
      // Derive public key and address from private key
      final keyPair = _deriveKeyPairFromPrivate(privateKey);
      final address = _publicKeyToAddress(keyPair.publicKey as pc.ECPublicKey);
      
      // Create session token
      final sessionToken = _generateSessionToken();
      
      final walletResponse = WalletResponse(
        address: address,
        privateKey: privateKey,
        sessionToken: sessionToken,
      );
      
      // Store wallet credentials securely
      await _storeWalletCredentials(
        privateKey: walletResponse.privateKey,
        address: walletResponse.address,
        sessionToken: walletResponse.sessionToken,
      );
      
      return walletResponse;
    } catch (e) {
      throw WalletException('Failed to import wallet: ${e.toString()}', null);
    }
  }
  
  /// Derives key pair from private key
  pc.AsymmetricKeyPair _deriveKeyPairFromPrivate(String privateKeyHex) {
    final privateKeyBytes = HEX.decode(privateKeyHex);
    final d = BigInt.parse(HEX.encode(privateKeyBytes), radix: 16);
    
    final domainParams = pc.ECCurve_secp256r1();
    final privateKey = pc.ECPrivateKey(d, domainParams);
    final publicKey = domainParams.G * d;
    final ecPublicKey = pc.ECPublicKey(publicKey, domainParams);
    
    return pc.AsymmetricKeyPair(ecPublicKey, privateKey);
  }
  
  /// Clears wallet data
  Future<void> clearWallet() async {
    await _clearWalletCredentials();
  }
  
  // --- Multi-Account Support ---
  
  /// Creates a new account
  Future<WalletAccount> createAccount({String? name}) async {
    try {
      // Generate a new ECDSA key pair
      final keyPair = _generateKeyPair();
      
      // Export keys to JWK format for storage
      final privJwk = _exportPrivateKeyToJwk(keyPair.privateKey as pc.ECPrivateKey);
      final pubJwk = _exportPublicKeyToJwk(keyPair.publicKey as pc.ECPublicKey);
      
      // Derive address
      final address = _publicKeyToAddress(keyPair.publicKey as pc.ECPublicKey);
      
      return WalletAccount(
        name: name ?? 'Account ${DateTime.now().millisecondsSinceEpoch}',
        privateKeyJwk: jsonEncode(privJwk),
        publicKeyJwk: jsonEncode(pubJwk),
        address: address,
      );
    } catch (e) {
      throw WalletException('Failed to create account: ${e.toString()}', null);
    }
  }
  
  /// Exports private key to JWK format
  Map<String, dynamic> _exportPrivateKeyToJwk(pc.ECPrivateKey privateKey) {
    final d = privateKey.d!;
    final x = privateKey.parameters!.G * d;
    return {
      'kty': 'EC',
      'crv': 'P-256',
      'd': base64Url.encode(_bigIntToBytes(d, 32)),
      'x': base64Url.encode(_bigIntToBytes(x!.x!.toBigInteger()!, 32)),
      'y': base64Url.encode(_bigIntToBytes(x.y!.toBigInteger()!, 32)),
    };
  }
  
  /// Exports public key to JWK format
  Map<String, dynamic> _exportPublicKeyToJwk(pc.ECPublicKey publicKey) {
    return {
      'kty': 'EC',
      'crv': 'P-256',
      'x': base64Url.encode(_bigIntToBytes(publicKey.Q!.x!.toBigInteger()!, 32)),
      'y': base64Url.encode(_bigIntToBytes(publicKey.Q!.y!.toBigInteger()!, 32)),
    };
  }
  
  /// Saves accounts to secure storage
  Future<void> saveAccounts(List<WalletAccount> accounts) async {
    final prefs = await SharedPreferences.getInstance();
    final accountsJson = accounts.map((acc) => jsonEncode(acc.toJson())).toList();
    await prefs.setStringList('wallet_accounts', accountsJson);
  }
  
  /// Loads accounts from secure storage
  Future<List<WalletAccount>> loadAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final accountsJson = prefs.getStringList('wallet_accounts') ?? [];
    return accountsJson
        .map((json) => WalletAccount.fromJson(jsonDecode(json) as Map<String, dynamic>))
        .toList();
  }
  
  /// Selects an account as the active account
  Future<void> selectAccount(WalletAccount account) async {
    await _secureStorage.write('selected_account_private_key', account.privateKeyJwk);
    await _secureStorage.write('selected_account_public_key', account.publicKeyJwk);
    await _secureStorage.write('selected_account_address', account.address ?? '');
  }
  
  /// Gets the currently selected account
  Future<WalletAccount?> getSelectedAccount() async {
    final privateKeyJwk = await _secureStorage.read('selected_account_private_key');
    final publicKeyJwk = await _secureStorage.read('selected_account_public_key');
    final address = await _secureStorage.read('selected_account_address');
    
    if (privateKeyJwk == null || publicKeyJwk == null) {
      return null;
    }
    
    return WalletAccount(
      name: 'Selected Account',
      privateKeyJwk: privateKeyJwk,
      publicKeyJwk: publicKeyJwk,
      address: address,
    );
  }

  /// Registers as a validator
  Future<bool> registerAsValidator({
    required int stake,
    required String fullName,
    required String country,
    required String idNumber,
  }) async {
    try {
      // Get wallet address from secure storage
      final address = await _secureStorage.read('wallet_address');
      
      if (address == null) {
        throw const WalletException('No wallet found', null);
      }
      
      // Prepare KYC data
      final kycData = {
        'fullName': fullName,
        'country': country,
        'idNumber': idNumber,
        'verified': true, // In a real implementation, this would be verified
      };
      
      // Call the API to register as validator
      final result = await _walletApiClient.registerAsValidator(
        address: address,
        stake: stake,
        kycData: kycData,
      );
      
      return result;
    } catch (e) {
      throw WalletException('Failed to register as validator: ${e.toString()}', null);
    }
  }
}

/// Response from wallet creation or import
class WalletResponse {
  final String address;
  final String privateKey;
  final String sessionToken;
  
  WalletResponse({
    required this.address,
    required this.privateKey,
    required this.sessionToken,
  });
  
  factory WalletResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return WalletResponse(
      address: data['address'] as String,
      privateKey: data['privateKey'] as String,
      sessionToken: data['sessionToken'] as String,
    );
  }
  
  Map<String, dynamic> toJson() => {
    'address': address,
    'privateKey': privateKey,
    'sessionToken': sessionToken,
  };
}

/// Wallet information
class WalletInfo {
  final String address;
  final double balance;
  final int nonce;
  final List<Transaction> recentTransactions;
  
  WalletInfo({
    required this.address,
    required this.balance,
    required this.nonce,
    required this.recentTransactions,
  });
  
  factory WalletInfo.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    
    List<Transaction> transactions = [];
    if (data['recentTransactions'] != null) {
      transactions = (data['recentTransactions'] as List)
          .map((item) => Transaction.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    
    return WalletInfo(
      address: data['address'] as String,
      balance: (data['balance'] as num).toDouble(),
      nonce: data['nonce'] as int,
      recentTransactions: transactions,
    );
  }
  
  Map<String, dynamic> toJson() => {
    'address': address,
    'balance': balance,
    'nonce': nonce,
    'recentTransactions': recentTransactions.map((tx) => tx.toJson()).toList(),
  };
}

/// Transaction model
class Transaction {
  final String hash;
  final String from;
  final String to;
  final double amount;
  final String? data;
  final DateTime timestamp;
  final String status;
  
  Transaction({
    required this.hash,
    required this.from,
    required this.to,
    required this.amount,
    this.data,
    required this.timestamp,
    required this.status,
  });
  
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      hash: json['hash'] as String,
      from: json['from'] as String,
      to: json['to'] as String,
      amount: (json['amount'] as num).toDouble(),
      data: json['data'] as String?,
      timestamp: DateTime.fromMillisecondsSinceEpoch(int.parse(json['timestamp'] as String)),
      status: json['status'] as String,
    );
  }
  
  Map<String, dynamic> toJson() => {
    'hash': hash,
    'from': from,
    'to': to,
    'amount': amount,
    'data': data,
    'timestamp': timestamp.millisecondsSinceEpoch.toString(),
    'status': status,
  };
}