// products/wallets/mobile/lib/services/light_node_service.dart
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../repositories/blockchain_repository.dart';

class LightNodeService {
  final BlockchainRepository _repository = BlockchainRepository();
  Timer? _syncTimer;
  bool _isOnline = true;

  Future<void> startLightNode(String address, String? token) async {
    // Check connectivity
    final connectivityResult = await Connectivity().checkConnectivity();
    _isOnline = connectivityResult != ConnectivityResult.none;

    if (_isOnline) {
      await _syncEssentialState(address, token);
    }

    // Periodic sync every 30 seconds if online
    _syncTimer = Timer.periodic(Duration(seconds: 30), (timer) async {
      if (_isOnline) {
        await _syncEssentialState(address, token);
      }
    });
  }

  Future<void> _syncEssentialState(String address, String? token) async {
    try {
      // Sync only balance and recent transactions (light node behavior)
      await _repository.getWalletBalance(address, token);
      await _repository.getTransactions(address, token);
    } catch (e) {
      print('Light node sync failed: $e');
    }
  }

  void stopLightNode() {
    _syncTimer?.cancel();
  }
}
