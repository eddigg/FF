import 'package:flutter/foundation.dart';
import '../api/atlas_api_service.dart';
import '../wallet/atlas_wallet_service.dart';

/// Simple provider that manages wallet and API state
/// Similar to how the web version manages global state
class AtlasProvider with ChangeNotifier {
  final AtlasApiService _apiService = AtlasApiService();
  final AtlasWalletService _walletService = AtlasWalletService();

  AtlasApiService get apiService => _apiService;
  AtlasWalletService get walletService => _walletService;

  String? _statusMessage;
  bool _isLoading = false;

  String? get statusMessage => _statusMessage;
  bool get isLoading => _isLoading;
  bool get isWalletLoaded => _walletService.isLoaded;
  String? get walletAddress => _walletService.address;

  Future<void> initialize() async {
    await _apiService.initialize();
    await _walletService.loadWallet();
    notifyListeners();
  }

  Future<void> generateWallet() async {
    _setLoading(true);
    try {
      final address = await _walletService.generateWallet();
      _showStatus('Wallet generated successfully!', success: true);
      notifyListeners();
    } catch (e) {
      _showStatus('Failed to generate wallet: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> exportWallet() async {
    try {
      final walletData = _walletService.exportWallet();
      _showStatus('Wallet exported to clipboard', success: true);
      // In a real implementation, copy to clipboard
      print('Wallet data: $walletData');
    } catch (e) {
      _showStatus('Failed to export wallet: $e');
    }
  }

  Future<void> importWallet(String walletJson) async {
    _setLoading(true);
    try {
      final success = await _walletService.importWallet(walletJson);
      if (success) {
        _showStatus('Wallet imported successfully!', success: true);
        notifyListeners();
      } else {
        _showStatus('Failed to import wallet');
      }
    } catch (e) {
      _showStatus('Failed to import wallet: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<double> getBalance() async {
    if (!isWalletLoaded) return 0.0;

    try {
      final response = await _apiService.getBalance(walletAddress!);
      return (response['balance'] as num?)?.toDouble() ?? 0.0;
    } catch (e) {
      _showStatus('Failed to get balance: $e');
      return 0.0;
    }
  }

  Future<bool> submitTransaction(String recipient, int amount) async {
    if (!isWalletLoaded) {
      _showStatus('No wallet loaded');
      return false;
    }

    _setLoading(true);
    try {
      final tx = {
        'Sender': walletAddress,
        'Recipient': recipient,
        'Amount': amount,
        'Timestamp': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        'Nonce': DateTime.now().millisecondsSinceEpoch,
      };

      tx['Signature'] = await _walletService.signTransaction(tx);

      final response = await _apiService.submitTransaction(tx);
      if (response.containsKey('error')) {
        _showStatus('Transaction failed: ${response['error']}');
        return false;
      } else {
        _showStatus('Transaction submitted successfully!', success: true);
        return true;
      }
    } catch (e) {
      _showStatus('Transaction failed: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> requestFaucet() async {
    if (!isWalletLoaded) {
      _showStatus('No wallet loaded');
      return false;
    }

    _setLoading(true);
    try {
      final response = await _apiService.faucet(walletAddress!);
      if (response.containsKey('error')) {
        _showStatus('Faucet request failed: ${response['error']}');
        return false;
      } else {
        _showStatus('Faucet tokens credited!', success: true);
        notifyListeners(); // Refresh balance
        return true;
      }
    } catch (e) {
      _showStatus('Faucet request failed: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<List<dynamic>> getBlocks({int limit = 10}) async {
    try {
      return await _apiService.getBlocks(limit: limit);
    } catch (e) {
      _showStatus('Failed to load blocks: $e');
      return [];
    }
  }

  Future<List<dynamic>> getPeers() async {
    try {
      return await _apiService.getPeers();
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> getMempool({int limit = 5}) async {
    try {
      return await _apiService.getMempool(limit: limit);
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> getNetworkArchitecture() async {
    try {
      return await _apiService.getNetworkArchitecture();
    } catch (e) {
      return {};
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _showStatus(String message, {bool success = false}) {
    _statusMessage = message;
    notifyListeners();

    // Auto-clear status after 5 seconds like your web version
    Future.delayed(const Duration(seconds: 5), () {
      _statusMessage = null;
      notifyListeners();
    });
  }
}
