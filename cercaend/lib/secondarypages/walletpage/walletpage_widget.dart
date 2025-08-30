import '/backend/api_requests/atlas_api_service.dart';
import '/backend/api_requests/faucet_service.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WalletpageWidget extends StatefulWidget {
  const WalletpageWidget({Key? key}) : super(key: key);

  @override
  _WalletpageWidgetState createState() => _WalletpageWidgetState();
}

class _WalletpageWidgetState extends State<WalletpageWidget> {
  String _connectionStatus = 'Checking connection...';
  String _walletAddress = '';
  String _walletBalance = '0';
  String _sessionToken = '';
  bool _isConnected = false;
  bool _isRequestingTokens = false;
  List<dynamic> _transactionHistory = [];

  @override
  void initState() {
    super.initState();
    _checkConnection();
    _loadWalletInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primary,
        title: Text(
          'Wallet',
          style: FlutterFlowTheme.of(context).titleLarge,
        ),
        actions: [],
        centerTitle: false,
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 0.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4.0,
                      color: Color(0x33000000),
                      offset: Offset(0.0, 2.0),
                    )
                  ],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Connection Status',
                        style: FlutterFlowTheme.of(context).headlineSmall,
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                        child: Text(
                          _connectionStatus,
                          style: _isConnected 
                            ? FlutterFlowTheme.of(context).bodyMedium.copyWith(
                                color: FlutterFlowTheme.of(context).primary,
                                fontWeight: FontWeight.bold,
                              )
                            : FlutterFlowTheme.of(context).bodyMedium.copyWith(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 0.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4.0,
                      color: Color(0x33000000),
                      offset: Offset(0.0, 2.0),
                    )
                  ],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Wallet Information',
                        style: FlutterFlowTheme.of(context).headlineSmall,
                      ),
                      if (_walletAddress.isNotEmpty) ...[
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                          child: Text(
                            'Address',
                            style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                          child: Text(
                            _walletAddress,
                            style: FlutterFlowTheme.of(context).bodyMedium,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                          child: Text(
                            'Balance',
                            style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                          child: Text(
                            '$_walletBalance tokens',
                            style: FlutterFlowTheme.of(context).titleMedium.copyWith(
                              color: FlutterFlowTheme.of(context).primary,
                            ),
                          ),
                        ),
                      ] else ...[
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                          child: Text(
                            'No wallet connected',
                            style: FlutterFlowTheme.of(context).bodyMedium,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 0.0),
              child: FFButtonWidget(
                onPressed: _isConnected ? _requestFaucetTokens : null,
                text: _isRequestingTokens ? 'Requesting Tokens...' : 'Request Faucet Tokens',
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 50.0,
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: _isConnected 
                    ? FlutterFlowTheme.of(context).primary 
                    : FlutterFlowTheme.of(context).secondaryText,
                  textStyle: FlutterFlowTheme.of(context).titleMedium,
                  elevation: 3.0,
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 0.0),
              child: FFButtonWidget(
                onPressed: _loadWalletInfo,
                text: 'Refresh Wallet Info',
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 50.0,
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: FlutterFlowTheme.of(context).primary,
                  textStyle: FlutterFlowTheme.of(context).titleMedium,
                  elevation: 3.0,
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 0.0),
              child: FFButtonWidget(
                onPressed: _createWallet,
                text: 'Create New Wallet',
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 50.0,
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: FlutterFlowTheme.of(context).primary,
                  textStyle: FlutterFlowTheme.of(context).titleMedium,
                  elevation: 3.0,
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkConnection() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/status'));
      if (response.statusCode == 200) {
        setState(() {
          _connectionStatus = 'Connected to ATLAS Blockchain';
          _isConnected = true;
        });
      } else {
        setState(() {
          _connectionStatus = 'Failed to connect. Status code: ${response.statusCode}';
          _isConnected = false;
        });
      }
    } catch (e) {
      setState(() {
        _connectionStatus = 'Error connecting: ${e.toString()}';
        _isConnected = false;
      });
    }
  }

  Future<void> _createWallet() async {
    try {
      final response = await AtlasApiService.connectWallet(action: 'create');
      if (response.statusCode == 200) {
        final data = json.decode(response.bodyText);
        if (data['success'] == true) {
          setState(() {
            _walletAddress = data['data']['address'];
            _sessionToken = data['data']['sessionToken'];
            _walletBalance = data['data']['balance'].toString();
            _connectionStatus = 'Wallet created successfully';
          });
          
          // Save wallet info to local storage or app state as needed
          // For now, we'll just keep it in the widget state
        } else {
          setState(() {
            _connectionStatus = 'Failed to create wallet: ${data['error']}';
          });
        }
      } else {
        setState(() {
          _connectionStatus = 'Failed to create wallet. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _connectionStatus = 'Error creating wallet: ${e.toString()}';
      });
    }
  }

  Future<void> _loadWalletInfo() async {
    if (_walletAddress.isEmpty) {
      setState(() {
        _connectionStatus = 'Please create a wallet first';
      });
      return;
    }

    try {
      final response = await AtlasApiService.getWalletInfo(address: _walletAddress);
      if (response.statusCode == 200) {
        final data = json.decode(response.bodyText);
        if (data['success'] == true) {
          setState(() {
            _walletBalance = data['data']['balance'].toString();
            _connectionStatus = 'Wallet info retrieved successfully';
          });
        } else {
          setState(() {
            _connectionStatus = 'Failed to get wallet info: ${data['error']}';
          });
        }
      } else {
        setState(() {
          _connectionStatus = 'Failed to get wallet info. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _connectionStatus = 'Error getting wallet info: ${e.toString()}';
      });
    }
  }

  Future<void> _requestFaucetTokens() async {
    if (_walletAddress.isEmpty) {
      setState(() {
        _connectionStatus = 'Please create a wallet first';
      });
      return;
    }

    setState(() {
      _isRequestingTokens = true;
      _connectionStatus = 'Requesting faucet tokens...';
    });

    try {
      final response = await FaucetService.requestFaucetTokens(walletAddress: _walletAddress);
      if (response.statusCode == 200) {
        final data = json.decode(response.bodyText);
        setState(() {
          _connectionStatus = data['status'] ?? 'Tokens received successfully';
          // Update balance if provided in response
          if (data['new_balance'] != null) {
            _walletBalance = data['new_balance'].toString();
          }
        });
        
        // Refresh wallet info to get updated balance
        await Future.delayed(Duration(seconds: 1));
        await _loadWalletInfo();
      } else {
        setState(() {
          _connectionStatus = 'Failed to request tokens. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _connectionStatus = 'Error requesting tokens: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isRequestingTokens = false;
      });
    }
  }
}