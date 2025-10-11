import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:pinenacl/ed25519.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:hex/hex.dart';

class CryptoService {
  final _secureStorage = const FlutterSecureStorage();

  Future<String> generateMnemonicAndPrivateKey() async {
    final mnemonic = bip39.generateMnemonic();
    final seed = bip39.mnemonicToSeed(mnemonic);
    final master = await ED25519_HD_KEY.getMasterKeyFromSeed(seed);
    final privateKey = master.key;
    await _secureStorage.write(key: 'privateKey', value: HEX.encode(privateKey));
    await _secureStorage.write(key: 'mnemonic', value: mnemonic);
    return mnemonic;
  }

  Future<String?> getPrivateKeyFromMnemonic(String mnemonic) async {
    final seed = bip39.mnemonicToSeed(mnemonic);
    final master = await ED25519_HD_KEY.getMasterKeyFromSeed(seed);
    return HEX.encode(master.key);
  }

  Future<String> getPublicKey(String privateKey) async {
    final privateKeyBytes = Uint8List.fromList(HEX.decode(privateKey));
    final signingKey = SigningKey.fromSeed(privateKeyBytes);
    return HEX.encode(signingKey.verifyKey.asTypedList);
  }

  Future<Map<String, String>> generateKeyPair() async {
    final mnemonic = bip39.generateMnemonic();
    final seed = bip39.mnemonicToSeed(mnemonic);
    final master = await ED25519_HD_KEY.getMasterKeyFromSeed(seed);
    final privateKey = SigningKey.fromSeed(Uint8List.fromList(master.key));
    final publicKey = privateKey.verifyKey;
    return {
      'privateKey': HEX.encode(privateKey.seed),
      'publicKey': HEX.encode(publicKey.asTypedList),
    };
  }

  String privateKeyToHex(SigningKey privateKey) {
    return HEX.encode(privateKey.seed);
  }

  SigningKey hexToPrivateKey(String hex) {
    return SigningKey.fromSeed(Uint8List.fromList(HEX.decode(hex)));
  }

  String publicKeyToAddress(VerifyKey publicKey) {
    return HEX.encode(publicKey.asTypedList);
  }

  Future<VerifyKey> derivePublicKey(String privateKey) async {
    final privateKeyBytes = Uint8List.fromList(HEX.decode(privateKey));
    final signingKey = SigningKey.fromSeed(privateKeyBytes);
    return signingKey.verifyKey;
  }

  Future<String> signMessage(String message, String privateKey) async {
    final privateKeyBytes = Uint8List.fromList(HEX.decode(privateKey));
    final signingKey = SigningKey.fromSeed(privateKeyBytes);
    final messageBytes = Uint8List.fromList(utf8.encode(message));
    final signature = signingKey.sign(messageBytes);
    return HEX.encode(signature.signature);
  }

  Future<bool> verifySignature(String message, String signature, String publicKey) async {
    try {
      final publicKeyBytes = Uint8List.fromList(HEX.decode(publicKey));
      final verifyKey = VerifyKey(publicKeyBytes);
      final signatureBytes = Uint8List.fromList(HEX.decode(signature));
      final messageBytes = Uint8List.fromList(utf8.encode(message));
      return verifyKey.verify(signature: Signature(signatureBytes), message: messageBytes);
    } catch (e) {
      return false;
    }
  }

  String sha256Hash(String data) {
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return HEX.encode(digest.bytes);
  }

  Future<String> signTransaction(String transaction, String privateKey) async {
    return signMessage(transaction, privateKey);
  }
}
