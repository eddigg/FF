import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Simple API service that mirrors the JavaScript calls in your web version
class AtlasApiService {
  // Current API port - stored in shared preferences like your web version
  int _currentPort = 8080;

  int get currentPort => _currentPort;
  String get baseUrl => 'http://localhost:$_currentPort';

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _currentPort = prefs.getInt('selectedNodePort') ?? 8080;
  }

  Future<void> setPort(int port) async {
    _currentPort = port;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedNodePort', port);
  }

  // --- WALLET API CALLS ---
  Future<Map<String, dynamic>> getBalance(String address) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/balance?address=$address'));
      return json.decode(response.body);
    } catch (e) {
      return {'balance': 0, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> submitTransaction(Map<String, dynamic> tx) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/submit-transaction'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(tx),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> faucet(String address) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/faucet'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'address': address}),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // --- BLOCKCHAIN API CALLS ---
  Future<List<dynamic>> getBlocks({int limit = 10}) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/blocks?limit=$limit'));
      final data = json.decode(response.body);
      return data is List ? data : [];
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> getPeers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/peers'));
      return json.decode(response.body) as List<dynamic>;
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> getMempool({int limit = 5}) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/mempool?limit=$limit'));
      return json.decode(response.body) as List<dynamic>;
    } catch (e) {
      return [];
    }
  }

  // --- VALIDATOR API CALLS ---
  Future<Map<String, dynamic>> getValidatorInfo(String address) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/validator?address=$address'));
      return json.decode(response.body);
    } catch (e) {
      return {'stake': '0', 'rank': 'Not a validator'};
    }
  }

  // --- NETWORK ARCHITECTURE ---
  Future<Map<String, dynamic>> getNetworkStatus() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/status'));
      return json.decode(response.body);
    } catch (e) {
      return {'mode': 'offline', 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getNetworkArchitecture() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/network/architecture'));
      return json.decode(response.body);
    } catch (e) {
      return {
        'nodeTypes': {
          'validators': {'count': 0, 'active': 0},
          'observers': {'count': 0},
          'fullNodes': {'count': 0}
        },
        'p2pProtocol': {'type': 'Unknown', 'version': '0.0'},
        'consensusMechanism': {'type': 'Unknown', 'blockTime': 'Unknown'},
        'networkTopology': {'type': 'Unknown', 'maxPeers': 0},
        'securityFeatures': {'encryption': 'Unknown', 'authentication': 'Unknown'}
      };
    }
  }
}
