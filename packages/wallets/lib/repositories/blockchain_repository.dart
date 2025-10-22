import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../models/wallet.dart';
import '../models/transaction.dart';

abstract class BlockchainRepository {
  Stream<bool> get connectionStatus;
  Future<Wallet> getWallet(String? userId);
  Future<List<Transaction>> getRecentTransactions();
  Future<Transaction> submitTransaction(Transaction transaction, String privateKey);
  Future<String> createPaymentRequest(String address, double amount, String? description);
  Future<double> getAddressBalance(String address);
  Future<Map<String, dynamic>> getBlockchainStatus();
  Future<void> connect();
  Future<void> disconnect();
}

class BlockchainRepositoryImpl implements BlockchainRepository {
  static const String _baseUrl = 'http://localhost:8080'; // ATLAS blockchain server
  final http.Client _client;
  final StreamController<bool> _connectionController = StreamController<bool>.broadcast();
  Timer? _healthCheckTimer;
  bool _isConnected = false;

  BlockchainRepositoryImpl({http.Client? client})
      : _client = client ?? http.Client() {
    startHealthMonitoring();
  }

  @override
  Stream<bool> get connectionStatus => _connectionController.stream;

  void startHealthMonitoring() {
    _healthCheckTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      checkConnectionStatus();
    });
  }

  Future<void> checkConnectionStatus() async {
    try {
      final response = await _client
          .get(Uri.parse('$_baseUrl/status'))
          .timeout(const Duration(seconds: 5));

      final isNowConnected = response.statusCode == 200;
      if (isNowConnected != _isConnected) {
        _isConnected = isNowConnected;
        _connectionController.add(_isConnected);
      }
    } catch (e) {
      if (_isConnected) {
        _isConnected = false;
        _connectionController.add(false);
      }
    }
  }

  @override
  Future<void> connect() async {
    await checkConnectionStatus();
  }

  @override
  Future<void> disconnect() async {
    _healthCheckTimer?.cancel();
    _connectionController.close();
  }

  @override
  Future<Wallet> getWallet(String? userId) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/wallet/$userId'),
