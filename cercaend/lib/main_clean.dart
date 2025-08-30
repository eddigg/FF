import 'package:flutter/material.dart';
import 'package:cercaend/components/wallet/wallet_info_widget.dart';

void main() {
  runApp(const MinimalApp());
}

class MinimalApp extends StatelessWidget {
  const MinimalApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ATLAS Wallet Info'),
        ),
        body: const Center(
          child: WalletInfoWidget(address: "0x12345"),
        ),
      ),
    );
  }
}
