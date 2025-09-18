import 'dart:typed_data';
import 'dart:math';
import 'package:pointycastle/export.dart' as pc_export;
import 'package:pointycastle/random/fortuna_random.dart';
import 'package:pointycastle/signers/ecdsa_signer.dart';
import 'package:hex/hex.dart';
import 'package:crypto/crypto.dart';
import '../utils/logger.dart';

/// Custom exception for cryptographic operations
class CryptoException implements Exception {
  final String message;
  
  const CryptoException(this.message);
  
  @override
  String toString() => 'CryptoException: $message';
}

/// Service for cryptographic operations including ECDSA key generation, signing, and secure storage
class CryptoService {
  static const String _ecCurve = 'secp256r1'; // P-256 curve
  
  /// Creates a cryptographically secure random number generator
  static pc_export.SecureRandom _createSecureRandom() {
    // Use FortunaRandom which is available in PointyCastle
    final secureRandom = FortunaRandom();
    final random = Random.secure();
    final seeds = <int>[];
    for (int i = 0; i < 32; i++) {
      seeds.add(random.nextInt(255));
    }
    secureRandom.seed(pc_export.KeyParameter(Uint8List.fromList(seeds)));
    return secureRandom;
  }
  
  /// Generates a new ECDSA key pair using the specified elliptic curve
  static pc_export.AsymmetricKeyPair generateKeyPair({String curve = _ecCurve}) {
    try {
      final secureRandom = _createSecureRandom();
      final domainParams = pc_export.ECCurve_secp256r1();
      final keyGenerator = pc_export.ECKeyGenerator();
      final keyParams = pc_export.ECKeyGeneratorParameters(domainParams);
      
      keyGenerator.init(pc_export.ParametersWithRandom(keyParams, secureRandom));
      return keyGenerator.generateKeyPair();
    } catch (e) {
      AppLogger.logError('Failed to generate key pair', e);
      throw CryptoException('Failed to generate key pair: $e');
    }
  }
  
  /// Derives a public key from a private key
  static pc_export.ECPublicKey derivePublicKey(pc_export.ECPrivateKey privateKey) {
    try {
      final params = privateKey.parameters!;
      final q = params.G * privateKey.d!;
      return pc_export.ECPublicKey(q, params);
    } catch (e) {
      AppLogger.logError('Failed to derive public key', e);
      throw CryptoException('Failed to derive public key: $e');
    }
  }
  
  /// Signs a message using ECDSA
  static Uint8List signMessage(Uint8List message, pc_export.ECPrivateKey privateKey) {
    try {
      final signer = ECDSASigner();
      final params = pc_export.PrivateKeyParameter<pc_export.ECPrivateKey>(privateKey);
      signer.init(true, params);
      
      // Hash the message first
      final hash = sha256.convert(message).bytes;
      
      // Sign the hash
      final signature = signer.generateSignature(Uint8List.fromList(hash)) as pc_export.ECSignature;
      
      // Encode the signature in DER format
      return _encodeSignatureDER(signature);
    } catch (e) {
      AppLogger.logError('Failed to sign message', e);
      throw CryptoException('Failed to sign message: $e');
    }
  }
  
  /// Verifies a signature using ECDSA
  static bool verifySignature(Uint8List message, Uint8List signature, pc_export.ECPublicKey publicKey) {
    try {
      final verifier = ECDSASigner();
      final params = pc_export.PublicKeyParameter<pc_export.ECPublicKey>(publicKey);
      verifier.init(false, params);
      
      // Hash the message first
      final hash = sha256.convert(message).bytes;
      
      // Decode the signature from DER format
      final ecsig = _decodeSignatureDER(signature);
      
      // Verify the signature
      return verifier.verifySignature(Uint8List.fromList(hash), ecsig);
    } catch (e) {
      AppLogger.logError('Failed to verify signature', e);
      return false;
    }
  }
  
  /// Converts a private key to hex string
  static String privateKeyToHex(pc_export.ECPrivateKey privateKey) {
    try {
      final d = privateKey.d!;
      final bytes = _bigIntToBytes(d, 32);
      return HEX.encode(bytes);
    } catch (e) {
      AppLogger.logError('Failed to convert private key to hex', e);
      throw CryptoException('Failed to convert private key to hex: $e');
    }
  }
  
  /// Converts a hex string to private key
  static pc_export.ECPrivateKey hexToPrivateKey(String hex, {String curve = _ecCurve}) {
    try {
      final bytes = HEX.decode(hex);
      final d = _bytesToBigInt(Uint8List.fromList(bytes));
      
      final domainParams = pc_export.ECCurve_secp256r1();
      return pc_export.ECPrivateKey(d, domainParams);
    } catch (e) {
      AppLogger.logError('Failed to convert hex to private key', e);
      throw CryptoException('Failed to convert hex to private key: $e');
    }
  }
  
  /// Derives an address from a public key
  static String publicKeyToAddress(pc_export.ECPublicKey publicKey) {
    try {
      final x = publicKey.Q!.x!.toBigInteger()!;
      final y = publicKey.Q!.y!.toBigInteger()!;
      final xBytes = _bigIntToBytes(x, 32);
      final yBytes = _bigIntToBytes(y, 32);
      final pubKeyBytes = Uint8List.fromList(xBytes + yBytes);
      
      // Hash the public key with SHA-256
      final sha256Hash = sha256.convert(pubKeyBytes).bytes;
      
      // Take last 20 bytes as address
      final addressBytes = sha256Hash.sublist(sha256Hash.length - 20);
      return '0x${HEX.encode(addressBytes)}';
    } catch (e) {
      AppLogger.logError('Failed to derive address from public key', e);
      throw CryptoException('Failed to derive address from public key: $e');
    }
  }
  
  /// Performs SHA-256 hash on data
  static Uint8List sha256Hash(Uint8List data) {
    try {
      final hash = sha256.convert(data).bytes;
      return Uint8List.fromList(hash);
    } catch (e) {
      AppLogger.logError('Failed to perform SHA-256 hash', e);
      throw CryptoException('Failed to perform SHA-256 hash: $e');
    }
  }
  
  /// Encodes an ECDSA signature in DER format
  static Uint8List _encodeSignatureDER(pc_export.ECSignature signature) {
    final rBytes = _bigIntToBytes(signature.r, 32);
    final sBytes = _bigIntToBytes(signature.s, 32);
    
    // Remove leading zeros
    final r = _removeLeadingZeros(rBytes);
    final s = _removeLeadingZeros(sBytes);
    
    // Ensure positive integers
    final rEncoded = r[0] & 0x80 != 0 ? [0] + r : r;
    final sEncoded = s[0] & 0x80 != 0 ? [0] + s : s;
    
    // Create DER encoding
    final sequence = <int>[
      0x30, // SEQUENCE tag
      rEncoded.length + sEncoded.length + 4, // Length of sequence
      0x02, // INTEGER tag for r
      rEncoded.length, // Length of r
      ...rEncoded,
      0x02, // INTEGER tag for s
      sEncoded.length, // Length of s
      ...sEncoded,
    ];
    
    return Uint8List.fromList(sequence);
  }
  
  /// Decodes an ECDSA signature from DER format
  static pc_export.ECSignature _decodeSignatureDER(Uint8List der) {
    // Parse DER format: SEQUENCE(INTEGER r, INTEGER s)
    int index = 0;
    
    // Skip SEQUENCE tag
    if (der[index] != 0x30) {
      throw const CryptoException('Invalid DER signature format');
    }
    index += 2; // Skip tag and length
    
    // Parse r INTEGER
    if (der[index] != 0x02) {
      throw const CryptoException('Invalid DER signature format');
    }
    index++; // Skip tag
    
    final rLength = der[index];
    index++; // Skip length
    
    final rBytes = der.sublist(index, index + rLength);
    index += rLength;
    
    // Parse s INTEGER
    if (der[index] != 0x02) {
      throw const CryptoException('Invalid DER signature format');
    }
    index++; // Skip tag
    
    final sLength = der[index];
    index++; // Skip length
    
    final sBytes = der.sublist(index, index + sLength);
    
    // Convert to BigInt
    final r = _bytesToBigInt(Uint8List.fromList(rBytes));
    final s = _bytesToBigInt(Uint8List.fromList(sBytes));
    
    return pc_export.ECSignature(r, s);
  }
  
  /// Converts BigInt to byte array with specified length
  static Uint8List _bigIntToBytes(BigInt bigInt, int length) {
    final hex = bigInt.toRadixString(16).padLeft(length * 2, '0');
    return Uint8List.fromList(HEX.decode(hex));
  }
  
  /// Converts byte array to BigInt
  static BigInt _bytesToBigInt(Uint8List bytes) {
    final hex = HEX.encode(bytes);
    return BigInt.parse(hex, radix: 16);
  }
  
  /// Removes leading zeros from byte array
  static List<int> _removeLeadingZeros(List<int> bytes) {
    int startIndex = 0;
    while (startIndex < bytes.length - 1 && bytes[startIndex] == 0) {
      startIndex++;
    }
    return bytes.sublist(startIndex);
  }
}