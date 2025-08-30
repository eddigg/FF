import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cercaend/backend/api_client.dart';
import 'package:cercaend/backend/models/wallet_info_model.dart';

class WalletInfoWidget extends StatefulWidget {
  final String address;
  const WalletInfoWidget({Key? key, required this.address}) : super(key: key);

  @override
  _WalletInfoWidgetState createState() => _WalletInfoWidgetState();
}

class _WalletInfoWidgetState extends State<WalletInfoWidget> {
  late Future<AppWalletInfo> _walletInfoFuture;
  final ApiClient _apiClient = ApiClient(http.Client());

  @override
  void initState() {
    super.initState();
    _walletInfoFuture = _apiClient.getWalletInfo(widget.address);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<AppWalletInfo>(
          future: _walletInfoFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red));
            } else if (snapshot.hasData) {
              final walletInfo = snapshot.data!;
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Wallet Address: ${walletInfo.address}', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('Balance: ${walletInfo.balance} tokens'),
                  const SizedBox(height: 8),
                  Text('Nonce: ${walletInfo.nonce}'),
                ],
              );
            } else {
              return const Text('No wallet data found.');
            }
          },
        ),
      ),
    );
  }
}
