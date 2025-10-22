// products/wallets/mobile/lib/services/cache_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CacheService {
  static const String _walletKey = 'cached_wallet';

  Future<void> cacheWalletData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_walletKey, jsonEncode(data));
  }

  Future<Map<String, dynamic>?> getCachedWalletData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_walletKey);
    return data != null ? jsonDecode(data) : null;
  }

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_walletKey);
  }
}
