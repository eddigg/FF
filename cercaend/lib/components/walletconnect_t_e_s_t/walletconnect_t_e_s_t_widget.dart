import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'walletconnect_t_e_s_t_model.dart';

// Import the Atlas API service
import '../../backend/api_requests/atlas_api_service.dart';
import 'dart:convert'; // Add this import for JSON decoding

export 'walletconnect_t_e_s_t_model.dart';

class WalletconnectTESTWidget extends StatefulWidget {
  const WalletconnectTESTWidget({super.key});

  @override
  State<WalletconnectTESTWidget> createState() =>
      _WalletconnectTESTWidgetState();
}

class _WalletconnectTESTWidgetState extends State<WalletconnectTESTWidget> {
  late WalletconnectTESTModel _model;

  // Wallet state variables
  String? _walletAddress;
  String? _sessionToken;
  int _balance = 0;
  bool _isLoading = false;
  List<dynamic> _transactions = [];

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WalletconnectTESTModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // Function to create a new wallet
  Future<void> _createWallet() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Simulate API call with delay
      await Future.delayed(Duration(seconds: 2));
      
      // Mock successful response
      setState(() {
        _walletAddress = '0x${DateTime.now().millisecondsSinceEpoch.toRadixString(16)}';
        _sessionToken = 'token_${DateTime.now().millisecondsSinceEpoch}';
        _balance = 100;
        _isLoading = false;
      });
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Wallet created successfully')),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating wallet: ${e.toString()}')),
      );
    }
  }
  
  // Function to get wallet info
  Future<void> _getWalletInfo() async {
    if (_walletAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No wallet connected')),
      );
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Simulate API call with delay
      await Future.delayed(Duration(seconds: 1));
      
      // Mock successful response with updated balance
      setState(() {
        _balance = _balance + 50; // Add 50 tokens as an example
        _isLoading = false;
      });
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Wallet balance updated')),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting wallet info: ${e.toString()}')),
      );
    }
  }
  
  // Function to get transaction history
  Future<void> _getTransactionHistory() async {
    if (_walletAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No wallet connected')),
      );
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Simulate API call with delay
      await Future.delayed(Duration(seconds: 1));
      
      // Mock transaction history
      setState(() {
        _transactions = [
          {
            'amount': 25,
            'type': 'sent',
            'recipient': '0xRecipient123',
            'timestamp': '2023-07-15'
          },
          {
            'amount': 50,
            'type': 'received',
            'sender': '0xSender456',
            'timestamp': '2023-07-14'
          },
          {
            'amount': 25,
            'type': 'sent',
            'recipient': '0xRecipient789',
            'timestamp': '2023-07-13'
          },
        ];
        _isLoading = false;
      });
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transaction history loaded')),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting transaction history: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Wallet Connection Demo',
              style: FlutterFlowTheme.of(context).headlineMedium,
            ),
            SizedBox(height: 16.0),
            
            // Wallet info display
            if (_walletAddress != null) ...[
              Container(
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: FlutterFlowTheme.of(context).primary,
                    width: 1.0,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Connected Wallet',
                        style: FlutterFlowTheme.of(context).titleMedium,
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Address: ${_walletAddress?.substring(0, 20)}...',
                        style: FlutterFlowTheme.of(context).bodyMedium,
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Balance: $_balance tokens',
                        style: FlutterFlowTheme.of(context).bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.0),
            ],
            
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FFButtonWidget(
                  onPressed: _isLoading ? null : _createWallet,
                  text: 'Create Wallet',
                  options: FFButtonOptions(
                    width: 130.0,
                    height: 40.0,
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                          color: Colors.white,
                          useGoogleFonts: false,
                        ),
                    elevation: 2.0,
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                FFButtonWidget(
                  onPressed: _walletAddress == null ? null : (_isLoading ? null : _getWalletInfo),
                  text: 'Refresh Info',
                  options: FFButtonOptions(
                    width: 130.0,
                    height: 40.0,
                    color: FlutterFlowTheme.of(context).secondary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                          color: Colors.white,
                          useGoogleFonts: false,
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
            SizedBox(height: 16.0),
            
            FFButtonWidget(
              onPressed: _walletAddress == null ? null : (_isLoading ? null : _getTransactionHistory),
              text: 'Load Transactions',
              options: FFButtonOptions(
                width: double.infinity,
                height: 40.0,
                color: FlutterFlowTheme.of(context).tertiary,
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                      color: Colors.white,
                      useGoogleFonts: false,
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
            
            // Transaction history
            if (_transactions.isNotEmpty) ...[
              Text(
                'Recent Transactions',
                style: FlutterFlowTheme.of(context).titleMedium,
              ),
              SizedBox(height: 8.0),
              Container(
                height: 200.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ListView.builder(
                  itemCount: _transactions.length,
                  itemBuilder: (context, index) {
                    final tx = _transactions[index];
                    return ListTile(
                      title: Text('${tx['amount']} tokens'),
                      subtitle: Text(tx['type'] == 'sent' 
                          ? 'To: ${tx['recipient'].toString().substring(0, 10)}...' 
                          : 'From: ${tx['sender'].toString().substring(0, 10)}...'),
                      trailing: Text(tx['timestamp'].toString()),
                    );
                  },
                ),
              ),
            ],
            
            // Loading indicator
            if (_isLoading) ...[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
