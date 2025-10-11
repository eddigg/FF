import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Simple wallet service that provides basic wallet functionality
/// Similar to the JavaScript Web Crypto API in your web version
class AtlasWalletService {
  Uint8List? _privateKey;
  Uint8List? _publicKey;
  String? _address;

  bool get isLoaded => _privateKey != null && _publicKey != null;

  String? get address => _address;

  /// Generate a new wallet keypair
  Future<String> generateWallet() async {
    // For simplicity, generate a random 32-byte private key
    // In production, you'd use proper ECDSA key generation
    final random = Uint8List(32);
    for (int i = 0; i < 32; i++) {
      random[i] = DateTime.now().millisecondsSinceEpoch % 256;
    }

    _privateKey = random;
    _publicKey = _derivePublicFromPrivate(random);
    _address = _publicKeyToAddress(_publicKey!);

    await _saveWallet();
    return _address!;
  }

  /// Load wallet from storage
  Future<bool> loadWallet() async {
    final prefs = await SharedPreferences.getInstance();
    final privHex = prefs.getString('wallet_private_key');
    final pubHex = prefs.getString('wallet_public_key');

    if (privHex != null && pubHex != null) {
      try {
        _privateKey = _hexToBytes(privHex);
        _publicKey = _hexToBytes(pubHex);
        _address = _publicKeyToAddress(_publicKey!);
        return true;
      } catch (e) {
        print('Failed to load wallet: $e');
        return false;
      }
    }
    return false;
  }

  /// Export wallet for backup
  String exportWallet() {
    if (!isLoaded) throw Exception('No wallet loaded');

    return json.encode({
      'privateKey': _bytesToHex(_privateKey!),
      'publicKey': _bytesToHex(_publicKey!),
      'address': _address,
    });
  }

  /// Import wallet from backup string
  Future<bool> importWallet(String walletJson) async {
    try {
      final data = json.decode(walletJson);
      _privateKey = _hexToBytes(data['privateKey']);
      _publicKey = _hexToBytes(data['publicKey']);
      _address = data['address'];

      await _saveWallet();
      return true;
    } catch (e) {
      print('Failed to import wallet: $e');
      return false;
    }
  }

  /// Sign a transaction
  Future<String> signTransaction(Map<String, dynamic> tx) async {
    if (!isLoaded) throw Exception('No wallet loaded');

    // Create transaction signature data (same format as web version)
    final signatureData = '${tx['Sender']}${tx['Recipient']}${tx['Amount']}${tx['Fee'] ?? 0}${tx['Timestamp']}${tx['Nonce']}${tx['Data'] ?? ''}';

    // Simple signing using HMAC-SHA256 (for demo purposes)
    // In production, use proper ECDSA signing
    final key = Hmac(sha256, _privateKey!);
    final signature = key.convert(utf8.encode(signatureData)).toString();

    return signature;
  }

  Future<void> _saveWallet() async {
    if (!isLoaded) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('wallet_private_key', _bytesToHex(_privateKey!));
    await prefs.setString('wallet_public_key', _bytesToHex(_publicKey!));
  }

  // Helper methods for crypto operations
  Uint8List _derivePublicFromPrivate(Uint8List privateKey) {
    // Simple derivation - hash the private key
    // In production, use proper elliptic curve derivation
    final digest = sha256.convert(privateKey);
    return Uint8List.fromList(digest.bytes.sublist(0, 32));
  }

  String _publicKeyToAddress(Uint8List publicKey) {
    // Simple address derivation - hash and take first 20 bytes like Ethereum
    final hash = sha256.convert(publicKey);
    final addressBytes = hash.bytes.sublist(0, 20);
    return '0x${addressBytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join()}';
  }

  String _bytesToHex(Uint8List bytes) {
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  Uint8List _hexToBytes(String hex) {
    if (hex.startsWith('0x')) hex = hex.substring(2);
    final bytes = <int>[];
    for (int i = 0; i < hex.length; i += 2) {
      bytes.add(int.parse(hex.substring(i, i + 2), radix: 16));
    }
    return Uint8List.fromList(bytes);
  }
}
