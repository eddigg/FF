import 'dart:convert';

class ApiClient {
  // In-memory mock data
  Map<String, dynamic> _walletData = {
    'test_address': {
      'address': 'test_address',
      'balance': 1000,
      'transactions': [],
    },
  };

  ApiClient(); // No baseUrl needed for in-memory mock

  Future<Map<String, dynamic>> getWalletInfo(String address) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 500));

    if (_walletData.containsKey(address)) {
      return { 'success': true, 'data': _walletData[address] };
    } else {
      return { 'success': false, 'message': 'Wallet not found' };
    }
  }

  Future<Map<String, dynamic>> requestFaucet(String address) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 500));

    if (_walletData.containsKey(address)) {
      _walletData[address]['balance'] += 100;
      _walletData[address]['transactions'].insert(0, {
        'type': 'received',
        'amount': 100,
        'from': 'Faucet',
        'timestamp': DateTime.now().toIso8601String(),
      });
      return { 'success': true, 'message': '100 tokens credited' };
    } else {
      return { 'success': false, 'message': 'Wallet not found' };
    }
  }

  Future<Map<String, dynamic>> sendTransaction(Map<String, dynamic> transaction) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 500));

    final String sender = _walletData.keys.first; // Assuming sender is the first (only) mock wallet
    final String recipient = transaction['recipient'];
    final int amount = transaction['amount'];

    if (_walletData.containsKey(sender) && _walletData.containsKey(recipient)) {
      if (_walletData[sender]['balance'] >= amount) {
        _walletData[sender]['balance'] -= amount;
        _walletData[recipient]['balance'] += amount;

        final newTransaction = {
          'type': 'sent',
          'amount': amount,
          'to': recipient,
          'timestamp': DateTime.now().toIso8601String(),
        };
        _walletData[sender]['transactions'].insert(0, newTransaction);

        // Add a received transaction for the recipient
        _walletData[recipient]['transactions'].insert(0, {
          'type': 'received',
          'amount': amount,
          'from': sender,
          'timestamp': DateTime.now().toIso8601String(),
        });

        return { 'success': true, 'data': { 'transactionHash': 'mock_hash_' + DateTime.now().millisecondsSinceEpoch.toString() } };
      } else {
        return { 'success': false, 'message': 'Insufficient funds' };
      }
    } else {
      return { 'success': false, 'message': 'Sender or recipient not found' };
    }
  }
}
