// Simplified wallet card widget
import 'package:flutter/material.dart';
import '../models/wallet_model.dart';

class WalletCard extends StatelessWidget {
  final WalletModel wallet;

  WalletCard({required this.wallet});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Address: ${wallet.address}', style: TextStyle(fontSize: 12)),
            SizedBox(height: 8),
            Text('Balance: ${wallet.balance} ATLAS', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Transactions: ${wallet.transactions.length}'),
          ],
        ),
      ),
    );
  }
}