import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import 'dart:convert';
import 'dart:math';

enum WalletCreationState {
  initial,
  creating,
  seedPhraseBackup,
  completed,
  error
}

class WalletProvider extends ChangeNotifier {
  WalletCreationState _state = WalletCreationState.initial;
  String? _walletAddress;
  String? _encryptedPrivateKey;
  List<String> _seedPhrase = [];
  String? _errorMessage;
  bool _isLoading = false;

  WalletCreationState get state => _state;
  String? get walletAddress => _walletAddress;
  String? get encryptedPrivateKey => _encryptedPrivateKey;
  List<String> get seedPhrase => _seedPhrase;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  // Check if user already has a wallet
  Future<bool> hasWallet() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserUid)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        return data['wallet_address'] != null &&
            data['wallet_address'].toString().isNotEmpty;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Generate a new wallet
  Future<void> createWallet() async {
    _setLoading(true);
    _setState(WalletCreationState.creating);

    try {
      // Generate seed phrase (12 words)
      _seedPhrase = _generateSeedPhrase();

      // Generate wallet address and private key from seed phrase
      final walletData = _generateWalletFromSeed(_seedPhrase);
      _walletAddress = walletData['address'];
      _encryptedPrivateKey = walletData['encryptedPrivateKey'];

      _setState(WalletCreationState.seedPhraseBackup);
    } catch (e) {
      _setError('Failed to create wallet: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Confirm seed phrase backup and save wallet to Firestore
  Future<void> confirmSeedPhraseBackup() async {
    _setLoading(true);

    try {
      // Save wallet data to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserUid)
          .update({
        'wallet_address': _walletAddress,
        'encrypted_private_key': _encryptedPrivateKey,
        'seed_phrase_hash': _hashSeedPhrase(_seedPhrase),
        'wallet_created_at': FieldValue.serverTimestamp(),
        'wallet_backed_up': true,
      });

      _setState(WalletCreationState.completed);
    } catch (e) {
      _setError('Failed to save wallet: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Reset wallet creation process
  void resetWalletCreation() {
    _state = WalletCreationState.initial;
    _walletAddress = null;
    _encryptedPrivateKey = null;
    _seedPhrase = [];
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  // Get wallet balance (mock implementation)
  Future<double> getWalletBalance() async {
    // This would typically call a blockchain API
    // For now, return 0 as mentioned in the requirements
    return 0.0;
  }

  // Private helper methods
  void _setState(WalletCreationState newState) {
    _state = newState;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    _state = WalletCreationState.error;
    notifyListeners();
  }

  List<String> _generateSeedPhrase() {
    // Mock seed phrase generation - in production, use proper BIP39 implementation
    final words = [
      'abandon',
      'ability',
      'able',
      'about',
      'above',
      'absent',
      'absorb',
      'abstract',
      'absurd',
      'abuse',
      'access',
      'accident',
      'account',
      'accuse',
      'achieve',
      'acid',
      'acoustic',
      'acquire',
      'across',
      'act',
      'action',
      'actor',
      'actress',
      'actual',
      'adapt',
      'add',
      'addict',
      'address',
      'adjust',
      'admit',
      'adult',
      'advance',
      'advice',
      'aerobic',
      'affair',
      'afford',
      'afraid',
      'again',
      'against',
      'age',
      'agent',
      'agree',
      'ahead',
      'aim',
      'air',
      'airport',
      'aisle',
      'alarm',
      'album',
      'alcohol',
      'alert',
      'alien',
      'all',
      'alley',
      'allow',
      'almost',
      'alone',
      'alpha',
      'already',
      'also',
      'alter',
      'always',
      'amateur',
      'amazing',
      'among',
      'amount',
      'amused',
      'analyst',
      'anchor',
      'ancient',
      'anger',
      'angle',
      'angry',
      'animal',
      'ankle',
      'announce',
      'annual',
      'another',
      'answer',
      'antenna',
      'antique',
      'anxiety',
      'any',
      'apart',
      'apology',
      'appear',
      'apple',
      'approve',
      'april',
      'arch',
      'arctic',
      'area',
      'arena',
      'argue',
      'arm',
      'armed',
      'armor',
      'army',
      'around',
      'arrange',
      'arrest',
      'arrive',
      'arrow',
      'art',
      'artefact',
      'artist',
      'artwork',
      'ask',
      'aspect',
      'assault',
      'asset',
      'assist',
      'assume',
      'asthma',
      'athlete',
      'atom',
      'attack',
      'attend',
      'attitude',
      'attract',
      'auction',
      'audit',
      'august',
      'aunt',
      'author',
      'auto',
      'autumn',
      'average',
      'avocado',
      'avoid',
      'awake',
      'aware',
      'away',
      'awesome',
      'awful',
      'awkward'
    ];

    final random = Random.secure();
    return List.generate(12, (index) => words[random.nextInt(words.length)]);
  }

  Map<String, String> _generateWalletFromSeed(List<String> seedPhrase) {
    // Mock wallet generation - in production, use proper cryptographic libraries
    final seed = seedPhrase.join(' ');
    final hash = seed.hashCode.abs().toString();

    return {
      'address': '0x${hash.padLeft(40, '0').substring(0, 40)}',
      'encryptedPrivateKey': base64Encode(utf8.encode('encrypted_$hash')),
    };
  }

  String _hashSeedPhrase(List<String> seedPhrase) {
    // Mock hash - in production, use proper hashing
    return base64Encode(utf8.encode(seedPhrase.join(' ')));
  }
}
