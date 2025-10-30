import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/services/blockchain/wallet_provider.dart';

class WalletTabWidget extends StatefulWidget {
  const WalletTabWidget({super.key});

  @override
  State<WalletTabWidget> createState() => _WalletTabWidgetState();
}

class _WalletTabWidgetState extends State<WalletTabWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 4.0, 6.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
              child: Container(
                width: 500.0,
                height: 600.0,
                constraints: BoxConstraints(maxWidth: 570.0),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).alternate,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Consumer<WalletProvider>(
                    builder: (context, walletProvider, child) {
                      if (walletProvider.state == WalletCreationState.initial) {
                        return _buildWalletSetupIntro(walletProvider);
                      } else if (walletProvider.state == WalletCreationState.seedPhraseBackup) {
                        return _buildSeedPhraseBackup(walletProvider);
                      } else if (walletProvider.state == WalletCreationState.completed) {
                        return _buildWalletManagement(walletProvider);
                      } else if (walletProvider.state == WalletCreationState.error) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 64.0,
                                color: FlutterFlowTheme.of(context).error,
                              ),
                              SizedBox(height: 16.0),
                              Text(
                                walletProvider.errorMessage ?? 'An error occurred',
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context).bodyMedium,
                              ),
                              SizedBox(height: 24.0),
                              FFButtonWidget(
                                onPressed: () {
                                  walletProvider.resetWalletCreation();
                                },
                                text: 'Try Again',
                                options: FFButtonOptions(
                                  height: 40.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                                  color: FlutterFlowTheme.of(context).primary,
                                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Inter',
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletSetupIntro(WalletProvider walletProvider) {
    return Container(
      padding: EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet,
            size: 80.0,
            color: FlutterFlowTheme.of(context).primary,
          ),
          SizedBox(height: 24.0),
          Text(
            'Create Your Wallet',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              letterSpacing: 0.0,
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            'Set up a secure wallet to manage your digital assets. Your wallet will be protected with a seed phrase that only you control.',
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
              fontFamily: 'Inter',
              letterSpacing: 0.0,
            ),
          ),
          SizedBox(height: 32.0),
          FFButtonWidget(
            onPressed: walletProvider.isLoading ? null : () async {
              await walletProvider.createWallet();
            },
            text: walletProvider.isLoading ? 'Creating...' : 'Create Wallet',
            options: FFButtonOptions(
              width: double.infinity,
              height: 50.0,
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              color: FlutterFlowTheme.of(context).primary,
              textStyle: FlutterFlowTheme.of(context).titleMedium.override(
                fontFamily: 'Inter',
                color: Colors.white,
                letterSpacing: 0.0,
              ),
              elevation: 2.0,
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeedPhraseBackup(WalletProvider walletProvider) {
    return Container(
      padding: EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Backup Your Seed Phrase',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              letterSpacing: 0.0,
            ),
          ),
          SizedBox(height: 16.0),
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: FlutterFlowTheme.of(context).warning,
                width: 1.0,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning,
                  color: FlutterFlowTheme.of(context).warning,
                ),
                SizedBox(width: 12.0),
                Expanded(
                  child: Text(
                    'Write down these words in order and store them safely. This is the only way to recover your wallet.',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter',
                      letterSpacing: 0.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.0),
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: FlutterFlowTheme.of(context).alternate,
                width: 1.0,
              ),
            ),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: walletProvider.seedPhrase.asMap().entries.map((entry) {
                int index = entry.key;
                String word = entry.value;
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).alternate,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    '${index + 1}. $word',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.0,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Spacer(),
          FFButtonWidget(
            onPressed: () async {
              await walletProvider.confirmSeedPhraseBackup();
            },
            text: 'I\'ve Saved My Seed Phrase',
            options: FFButtonOptions(
              width: double.infinity,
              height: 50.0,
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              color: FlutterFlowTheme.of(context).primary,
              textStyle: FlutterFlowTheme.of(context).titleMedium.override(
                fontFamily: 'Inter',
                color: Colors.white,
                letterSpacing: 0.0,
              ),
              elevation: 2.0,
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletManagement(WalletProvider walletProvider) {
    return Container(
      padding: EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Wallet',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              letterSpacing: 0.0,
            ),
          ),
          SizedBox(height: 24.0),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  FlutterFlowTheme.of(context).primary,
                  FlutterFlowTheme.of(context).secondary,
                ],
                stops: [0.0, 1.0],
                begin: AlignmentDirectional(-1.0, -1.0),
                end: AlignmentDirectional(1.0, 1.0),
              ),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Balance',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Inter',
                    color: Colors.white.withOpacity(0.8),
                    letterSpacing: 0.0,
                  ),
                ),
                SizedBox(height: 8.0),
                FutureBuilder<double>(
                  future: walletProvider.getWalletBalance(),
                  builder: (context, snapshot) {
                    return Text(
                      '${snapshot.data ?? 0.0} ETH',
                      style: FlutterFlowTheme.of(context).headlineLarge.override(
                        fontFamily: 'Inter',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.0,
                      ),
                    );
                  },
                ),
                SizedBox(height: 16.0),
                Text(
                  'Address',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Inter',
                    color: Colors.white.withOpacity(0.8),
                    letterSpacing: 0.0,
                  ),
                ),
                SizedBox(height: 4.0),
                SelectableText(
                  walletProvider.walletAddress ?? '',
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                    fontFamily: 'Inter',
                    color: Colors.white,
                    letterSpacing: 0.0,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.0),
          Row(
            children: [
              Expanded(
                child: FFButtonWidget(
                  onPressed: () {
                    // TODO: Implement send functionality
                  },
                  text: 'Send',
                  icon: Icon(
                    Icons.send,
                    size: 20.0,
                  ),
                  options: FFButtonOptions(
                    height: 50.0,
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).titleMedium.override(
                      fontFamily: 'Inter',
                      color: Colors.white,
                      letterSpacing: 0.0,
                    ),
                    elevation: 2.0,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: FFButtonWidget(
                  onPressed: () {
                    // TODO: Implement receive functionality
                  },
                  text: 'Receive',
                  icon: Icon(
                    Icons.qr_code,
                    size: 20.0,
                  ),
                  options: FFButtonOptions(
                    height: 50.0,
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    textStyle: FlutterFlowTheme.of(context).titleMedium.override(
                      fontFamily: 'Inter',
                      color: FlutterFlowTheme.of(context).primaryText,
                      letterSpacing: 0.0,
                    ),
                    elevation: 2.0,
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).alternate,
                      width: 1.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
