import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class WalletWidget extends StatefulWidget {
  const WalletWidget({super.key});

  @override
  State<WalletWidget> createState() => _WalletWidgetState();
}

import 'package:cercaend/backend/api_client.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class WalletWidget extends StatefulWidget {
  const WalletWidget({super.key});

  @override
  State<WalletWidget> createState() => _WalletWidgetState();
}

class _WalletWidgetState extends State<WalletWidget> {
  final ApiClient apiClient = ApiClient(); // No baseUrl needed for in-memory mock
  String walletAddress = 'Loading address...';
  String walletBalance = '0 tokens';
  List<dynamic> transactions = [];
  final TextEditingController recipientController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadWalletInfo();
  }

  Future<void> loadWalletInfo() async {
    try {
      final response = await apiClient.getWalletInfo('test_address');
      setState(() {
        walletAddress = response['data']['address'];
        walletBalance = response['data']['balance'].toString() + ' tokens';
        transactions = response['data']['transactions'];
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> requestFaucet() async {
    try {
      await apiClient.requestFaucet(walletAddress);
      loadWalletInfo();
    } catch (e) {
      print(e);
    }
  }

  Future<void> sendTransaction() async {
    try {
      await apiClient.sendTransaction({
        'recipient': recipientController.text,
        'amount': int.parse(amountController.text),
      });
      recipientController.clear();
      amountController.clear();
      loadWalletInfo();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wallet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Wallet Balance',
                      style: FlutterFlowTheme.of(context).titleMedium,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      walletBalance,
                      style: FlutterFlowTheme.of(context).displaySmall,
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Wallet Address',
                      style: FlutterFlowTheme.of(context).titleMedium,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      walletAddress,
                      style: FlutterFlowTheme.of(context).bodyMedium,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              FFButtonWidget(
                onPressed: requestFaucet,
                text: 'Request Faucet',
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 50.0,
                  color: FlutterFlowTheme.of(context).primary,
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'Readex Pro',
                        color: Colors.white,
                      ),
                  elevation: 2.0,
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Send Transaction',
                      style: FlutterFlowTheme.of(context).titleMedium,
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: recipientController,
                      decoration: InputDecoration(
                        labelText: 'Recipient Address',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: amountController,
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16.0),
                    FFButtonWidget(
                      onPressed: sendTransaction,
                      text: 'Send',
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 50.0,
                        color: FlutterFlowTheme.of(context).primary,
                        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                              fontFamily: 'Readex Pro',
                              color: Colors.white,
                            ),
                        elevation: 2.0,
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transaction History',
                      style: FlutterFlowTheme.of(context).titleMedium,
                    ),
                    SizedBox(height: 16.0),
                    transactions.isEmpty
                        ? Text(
                            'No transactions yet.',
                            style: FlutterFlowTheme.of(context).bodyMedium,
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: transactions.length,
                            itemBuilder: (context, index) {
                              final transaction = transactions[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${transaction['type'] == 'sent' ? 'To' : 'From'}: ${transaction['type'] == 'sent' ? transaction['to'] : transaction['from']}',
                                            style: FlutterFlowTheme.of(context).bodyMedium,
                                          ),
                                          Text(
                                            'Amount: ${transaction['amount']}',
                                            style: FlutterFlowTheme.of(context).bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '${transaction['timestamp'].substring(0, 10)}',
                                      style: FlutterFlowTheme.of(context).bodySmall,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
