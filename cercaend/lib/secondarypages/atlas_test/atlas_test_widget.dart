import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../backend/api_requests/atlas_api_service.dart';
import '../../backend/api_requests/faucet_service.dart';

class AtlasTestWidget extends StatefulWidget {
  const AtlasTestWidget({super.key});

  @override
  State<AtlasTestWidget> createState() => _AtlasTestWidgetState();
}

class _AtlasTestWidgetState extends State<AtlasTestWidget> {
  String _connectionStatus = 'Checking connection...';
  bool _isConnected = false;
  String _walletAddress = '';
  String _sessionToken = '';
  int _walletBalance = 0;
  bool _isRequestingTokens = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkConnection();
  }

  Future<void> _checkConnection() async {
    setState(() {
      _connectionStatus = 'Checking connection...';
      _isConnected = false;
    });

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
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await AtlasApiService.connectWallet(action: 'create');
      if (response.statusCode == 200) {
        final data = json.decode(response.bodyText);
        if (data['success'] == true) {
          setState(() {
            _walletAddress = data['data']['address'] ?? '';
            _sessionToken = data['data']['sessionToken'] ?? '';
            _walletBalance = data['data']['balance'] ?? 0;
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Wallet created successfully')),
          );
        } else {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to create wallet: ${data['error'] ?? 'Unknown error'}')),
          );
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create wallet. Status code: ${response.statusCode}')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating wallet: ${e.toString()}')),
      );
    }
  }

  Future<void> _getWalletInfo() async {
    if (_walletAddress.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please create a wallet first')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await AtlasApiService.getWalletInfo(address: _walletAddress);
      if (response.statusCode == 200) {
        final data = json.decode(response.bodyText);
        if (data['success'] == true) {
          setState(() {
            _walletBalance = data['data']['balance'] ?? 0;
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Wallet info updated')),
          );
        } else {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to get wallet info: ${data['error'] ?? 'Unknown error'}')),
          );
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to get wallet info. Status code: ${response.statusCode}')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting wallet info: ${e.toString()}')),
      );
    }
  }

  Future<void> _requestFaucetTokens() async {
    if (_walletAddress.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please create a wallet first')),
      );
      return;
    }

    setState(() {
      _isRequestingTokens = true;
    });

    try {
      final response = await FaucetService.requestFaucetTokens(walletAddress: _walletAddress);
      if (response.statusCode == 200) {
        final data = json.decode(response.bodyText);
        setState(() {
          if (data['new_balance'] != null) {
            _walletBalance = data['new_balance'];
          }
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['status'] ?? 'Faucet tokens received successfully')),
        );
        
        // Refresh wallet info to get updated balance
        await _getWalletInfo();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to request faucet tokens. Status code: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error requesting faucet tokens: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isRequestingTokens = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          title: Text(
            'ATLAS Blockchain Test',
            style: FlutterFlowTheme.of(context).headlineMedium,
          ),
          actions: [],
          centerTitle: false,
          elevation: 0,
        ),
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Connection status
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: _isConnected 
                        ? FlutterFlowTheme.of(context).primaryBackground 
                        : FlutterFlowTheme.of(context).error,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Connection Status',
                          style: FlutterFlowTheme.of(context).titleMedium,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          _connectionStatus,
                          style: FlutterFlowTheme.of(context).bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Wallet info section
              if (_walletAddress.isNotEmpty) ...[
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
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
                            'Wallet Information',
                            style: FlutterFlowTheme.of(context).titleMedium,
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Address: ${_walletAddress.substring(0, 16)}...',
                            style: FlutterFlowTheme.of(context).bodyMedium,
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Balance: $_walletBalance tokens',
                            style: FlutterFlowTheme.of(context).bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              
              // Action buttons
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    FFButtonWidget(
                      onPressed: _isLoading ? null : _checkConnection,
                      text: 'Check Connection',
                      options: FFButtonOptions(
                        width: double.infinity,
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
                    SizedBox(height: 12.0),
                    FFButtonWidget(
                      onPressed: _isLoading ? null : _createWallet,
                      text: 'Create Wallet',
                      options: FFButtonOptions(
                        width: double.infinity,
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
                    SizedBox(height: 12.0),
                    if (_walletAddress.isNotEmpty) ...[
                      FFButtonWidget(
                        onPressed: _isLoading ? null : _getWalletInfo,
                        text: 'Refresh Wallet Info',
                        options: FFButtonOptions(
                          width: double.infinity,
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
                      SizedBox(height: 12.0),
                      FFButtonWidget(
                        onPressed: _isRequestingTokens ? null : _requestFaucetTokens,
                        text: _isRequestingTokens ? 'Requesting Tokens...' : 'Request Faucet Tokens',
                        options: FFButtonOptions(
                          width: double.infinity,
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
                    ],
                  ],
                ),
              ),
              
              // Loading indicator
              if (_isLoading || _isRequestingTokens) ...[
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}