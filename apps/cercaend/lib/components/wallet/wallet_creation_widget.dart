import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../../services/blockchain/wallet_provider.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class WalletCreationWidget extends StatefulWidget {
  const WalletCreationWidget({super.key});

  @override
  State<WalletCreationWidget> createState() => _WalletCreationWidgetState();
}

class _WalletCreationWidgetState extends State<WalletCreationWidget> {
  late TextEditingController _seedPhraseController;

  @override
  void initState() {
    super.initState();
    _seedPhraseController = TextEditingController();
  }

  @override
  void dispose() {
    _seedPhraseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context);

    return Container(
      width: double.infinity,
      height: 400.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            if (!walletProvider.hasWallet) ...[
              // Wallet Creation Flow
              if (walletProvider.seedPhrase == null) ...[
                // Step 1: Start Creation
                Container(
                  width: double.infinity,
                  height: 120.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).alternate,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.account_balance_wallet,
                          color: FlutterFlowTheme.of(context).primary,
                          size: 32.0,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Create Your Blockchain Wallet',
                          style: FlutterFlowTheme.of(context).titleSmall,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          'Secure your digital assets with a personal wallet',
                          style: FlutterFlowTheme.of(context).bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                FFButtonWidget(
                  onPressed: walletProvider.isLoading
                      ? null
                      : () async {
                          final success = await walletProvider.startWalletCreation();
                          if (!success && mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(walletProvider.errorMessage ?? 'Failed to create wallet')),
                            );
                          }
                        },
                  text: walletProvider.isLoading ? 'Creating...' : 'Create Wallet',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 44.0,
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      font: GoogleFonts.inter(),
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ] else if (!walletProvider.seedPhraseBackedUp) ...[
                // Step 2: Backup Seed Phrase
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).alternate,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.security,
                                  color: FlutterFlowTheme.of(context).error,
                                  size: 32.0,
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Secure Your Recovery Phrase',
                                  style: FlutterFlowTheme.of(context).titleSmall,
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Write down these 12 words in order. Store them safely offline.',
                                  style: FlutterFlowTheme.of(context).bodySmall,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).primaryBackground,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).primary,
                              width: 1.0,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                Expanded(
                                  child: Text(
                                    walletProvider.seedPhrase!,
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: 'RobotoMono',
                                      fontSize: 14.0,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                  IconButton(
                                    icon: Icon(Icons.copy),
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(text: walletProvider.seedPhrase!));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Seed phrase copied to clipboard')),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                '⚠️ Never share this phrase. Anyone with these words can access your funds.',
                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                  font: GoogleFonts.inter(),
                                  color: FlutterFlowTheme.of(context).error,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.0),
                        FFButtonWidget(
                          onPressed: walletProvider.isLoading
                              ? null
                              : () => _showConfirmDialog(context, walletProvider),
                          text: walletProvider.isLoading ? 'Confirming...' : 'I\'ve Saved My Recovery Phrase',
                          options: FFButtonOptions(
                            width: double.infinity,
                            height: 44.0,
                            color: FlutterFlowTheme.of(context).success,
                            textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                              font: GoogleFonts.inter(),
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        SizedBox(height: 8.0),
                        TextButton(
                          onPressed: () => walletProvider.resetWalletCreation(),
                          child: Text(
                            'Start Over',
                            style: FlutterFlowTheme.of(context).bodySmall.override(
                              font: GoogleFonts.inter(),
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ] else ...[
              // Wallet Already Created - Show Info
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).alternate,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: FlutterFlowTheme.of(context).success,
                        size: 48.0,
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Wallet Connected',
                        style: FlutterFlowTheme.of(context).titleMedium,
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        'Your blockchain wallet is ready',
                        style: FlutterFlowTheme.of(context).bodySmall,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8.0),
                      if (walletProvider.currentAddress != null) ...[
                        Text(
                          'Address: ${walletProvider.currentAddress!.substring(0, 12)}...',
                          style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'RobotoMono',
                            fontSize: 12.0,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Balance: ${walletProvider.balance.toStringAsFixed(4)} tokens',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'RobotoMono',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
            if (walletProvider.errorMessage != null) ...[
              SizedBox(height: 12.0),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: FlutterFlowTheme.of(context).error,
                    width: 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: FlutterFlowTheme.of(context).error,
                      size: 16.0,
                    ),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        walletProvider.errorMessage!,
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                          font: GoogleFonts.inter(),
                          color: FlutterFlowTheme.of(context).error,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, size: 16.0),
                      onPressed: () => walletProvider.clearError(),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showConfirmDialog(BuildContext context, WalletProvider walletProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Backup'),
        content: Text(
          'Are you sure you have safely stored your recovery phrase? This is your only way to recover your wallet if you lose access.'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Not Yet'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final success = await walletProvider.confirmSeedPhraseBackup();
              if (!success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(walletProvider.errorMessage ?? 'Failed to confirm backup')),
                );
              } else if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Wallet created successfully!')),
                );
              }
            },
            child: Text('Yes, I\'ve Backed It Up'),
          ),
        ],
      ),
    );
  }
}
