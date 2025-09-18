import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/logger.dart';

/// A simple cache implementation using shared preferences
class ApiCache {
  static const String _cachePrefix = 'api_cache_';
  static const int _defaultCacheExpiry = 5 * 60 * 1000; // 5 minutes in milliseconds

  /// Get cached data if it exists and hasn't expired
  static Future<Map<String, dynamic>?> getCachedData(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('$_cachePrefix$key');
      
      if (cachedData != null) {
        final data = json.decode(cachedData);
        final timestamp = data['timestamp'] as int;
        final expiry = data['expiry'] as int? ?? _defaultCacheExpiry;
        
        // Check if cache has expired
        if (DateTime.now().millisecondsSinceEpoch - timestamp < expiry) {
          return data['value'];
        } else {
          // Remove expired cache
          await prefs.remove('$_cachePrefix$key');
        }
      }
    } catch (e) {
      AppLogger.logError('Error retrieving cached data for key: $key', e);
    }
    
    return null;
  }

  /// Cache data with optional expiry time (in milliseconds)
  static Future<void> cacheData(String key, Map<String, dynamic> value, {int? expiry}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = {
        'value': value,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'expiry': expiry ?? _defaultCacheExpiry,
      };
      
      await prefs.setString('$_cachePrefix$key', json.encode(data));
    } catch (e) {
      AppLogger.logError('Error caching data for key: $key', e);
    }
  }

  /// Clear cache for a specific key
  static Future<void> clearCache(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('$_cachePrefix$key');
    } catch (e) {
      AppLogger.logError('Error clearing cache for key: $key', e);
    }
  }

  /// Clear all API cache
  static Future<void> clearAllCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      
      for (final key in keys) {
        if (key.startsWith(_cachePrefix)) {
          await prefs.remove(key);
        }
      }
    } catch (e) {
      AppLogger.logError('Error clearing all API cache', e);
    }
  }

  /// Get cache key for a specific endpoint with parameters
  static String getCacheKey(String endpoint, {Map<String, dynamic>? params}) {
    final buffer = StringBuffer(endpoint);
    
    if (params != null && params.isNotEmpty) {
      buffer.write('?');
      final paramKeys = params.keys.toList()..sort();
      
      for (int i = 0; i < paramKeys.length; i++) {
        if (i > 0) buffer.write('&');
        buffer.write('${paramKeys[i]}=${params[paramKeys[i]]}');
      }
    }
    
    return buffer.toString();
  }
}