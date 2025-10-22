// products/wallets/mobile/lib/repositories/blockchain_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../shared/models/wallet_model.dart';

class BlockchainRepository {
  static const String _baseUrl = 'http://localhost:8080'; // Update to your API Gateway URL

  Future<WalletModel> getWalletBalance(String address, String? token) async {
    final headers = token != null ? {'Authorization': 'Bearer $token'} : {};
    final response = await http.get(Uri.parse('$_baseUrl/balance/$address'), headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return WalletModel(
        address: data['address'],
        balance: data['balance'].toDouble(),
        transactions: [], // Load separately if needed
      );
    } else {
      throw Exception('Failed to load balance');
    }
  }

  Future<List<TransactionModel>> getTransactions(String address, String? token) async {
    final headers = token != null ? {'Authorization': 'Bearer $token'} : {};
    final response = await http.get(Uri.parse('$_baseUrl/transactions/$address'), headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['transactions'] as List)
          .map((t) => TransactionModel.fromJson(t))
          .toList();
    } else {
      throw Exception('Failed to load transactions');
    }
  }

  Future<String> submitTransaction(Map<String, dynamic> txData, String? token) async {
    final headers = token != null ? {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'} : {'Content-Type': 'application/json'};
    final response = await http.post(
      Uri.parse('$_baseUrl/submit-transaction'),
      headers: headers,
      body: jsonEncode(txData),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['hash'];
    } else {
      throw Exception('Failed to submit transaction');
    }
  }
}
