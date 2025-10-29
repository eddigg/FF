import 'dart:convert';
import 'package:http/http.dart' as http;

class BlockchainService {
  final String baseUrl;

  BlockchainService({this.baseUrl = 'http://localhost:3000'});

  // Get wallet balance
  Future<Map<String, dynamic>> getBalance(String address) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/balance/$address'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load balance: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to blockchain: $e');
    }
  }

  // Get transaction history
  Future<Map<String, dynamic>> getTransactions(String address) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/transactions/$address'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load transactions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to blockchain: $e');
    }
  }

  // Submit a transaction
  Future<Map<String, dynamic>> submitTransaction({
    required String sender,
    required String recipient,
    required double amount,
    String? signature,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/submit-transaction'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'sender': sender,
          'recipient': recipient,
          'amount': amount,
          if (signature != null) 'signature': signature,
        }),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to submit transaction: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to blockchain: $e');
    }
  }

  // Create a new wallet (generate seed phrase)
  Future<Map<String, dynamic>> createWallet() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create-wallet'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create wallet: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create wallet: $e');
    }
  }

  // Get seed phrase for wallet
  Future<Map<String, dynamic>> getSeedPhrase(String walletId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/wallet/$walletId/seed'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get seed phrase: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get seed phrase: $e');
    }
  }

  // Confirm seed phrase backup and finalize wallet
  Future<Map<String, dynamic>> confirmWalletBackup(String walletId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/wallet/$walletId/confirm'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to confirm wallet backup: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to confirm wallet backup: $e');
    }
  }

  // Additional utility methods can be added here, such as createWallet, etc.
}
