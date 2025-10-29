import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../../services/blockchain/wallet_provider.dart';
import '../../models/blockchain_models.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'wallet_creation_widget.dart';

class WalletDashboardWidget extends StatefulWidget {
  const WalletDashboardWidget({super.key});

  @override
  State<WalletDashboardWidget> createState() => _WalletDashboardWidgetState();
}

class _WalletDashboardWidgetState extends State<WalletDashboardWidget> {
  late TextEditingController _sendAmountController;
  late TextEditingController _sendAddressController;

  @override
  void initState() {
    super.initState();
    _sendAmountController = TextEditingController();
    _sendAddressController = TextEditingController();
  }

  @override
  void dispose() {
    _sendAmountController.dispose();
    _sendAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context);
    final transactions = walletProvider.transactions;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primary,
        title: Text(
          'Blockchain Wallet',
          style: FlutterFlowTheme.of(context).titleLarge.override(
            font: GoogleFonts.inter(),
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onPressed: () => _showWalletMenu(context),
          ),
        ],
        elevation: 0,
      ),
      body: walletProvider.hasWallet
          ? _buildWalletDashboard(walletProvider, transactions)
          : _buildWelcomeScreen(context, walletProvider),
    );
  }

  Widget _buildWelcomeScreen(BuildContext context, WalletProvider walletProvider) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            FlutterFlowTheme.of(context).primary,
            FlutterFlowTheme.of(context).secondary,
          ],
          stops: const [0.0, 1.0],
          begin: const AlignmentDirectional(0.17, -1.0),
          end: const AlignmentDirectional(-0.17, 1.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet,
            color: Colors.white,
            size: 80.0,
          ),
          SizedBox(height: 16.0),
          Text(
            'Welcome to Blockchain',
            style: FlutterFlowTheme.of(context).displaySmall.override(
              font: GoogleFonts.inter(),
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.0),
          Text(
            'Create your wallet to start earning and spending tokens',
            style: FlutterFlowTheme.of(context).bodyLarge.override(
              font: GoogleFonts.inter(),
              color: Colors.white.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: WalletCreationWidget(),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletDashboard(WalletProvider walletProvider, List<Transaction> transactions) {
    return Column(
      children: [
        // Balance Card
        Container(
          width: double.infinity,
          height: 200.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                FlutterFlowTheme.of(context).primary,
                FlutterFlowTheme.of(context).secondary,
              ],
              stops: const [0.0, 1.0],
              begin: const AlignmentDirectional(0.17, -1.0),
              end: const AlignmentDirectional(-0.17, 1.0),
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24.0),
              bottomRight: Radius.circular(24.0),
              topLeft: Radius.circular(0.0),
              topRight: Radius.circular(0.0),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Balance',
                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                    font: GoogleFonts.inter(),
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${walletProvider.balance.toStringAsFixed(4)} XTokens',
                  style: FlutterFlowTheme.of(context).displayLarge.override(
                    font: GoogleFonts.inter(),
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.0),
                Container(
                  width: 120.0,
                  height: 28.0,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.copy,
                        color: Colors.white,
                        size: 16.0,
                      ),
                      SizedBox(width: 4.0),
                      Flexible(
                        child: Text(
                          '${walletProvider.currentAddress?.substring(0, 6)}...${walletProvider.currentAddress?.substring(walletProvider.currentAddress!.length - 4)}',
                          style: FlutterFlowTheme.of(context).bodySmall.override(
                            font: GoogleFonts.inter(),
                            color: Colors.white,
                            fontFamily: 'RobotoMono',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Action Buttons
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                context,
                Icons.send,
                'Send',
                FlutterFlowTheme.of(context).success,
                () => _showSendDialog(context, walletProvider),
              ),
              _buildActionButton(
                context,
                Icons.receipt,
                'Receive',
                FlutterFlowTheme.of(context).secondary,
                () => _showReceiveDialog(context, walletProvider),
              ),
            ],
          ),
        ),

        // Transactions Section
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Transactions',
                        style: FlutterFlowTheme.of(context).titleMedium,
                      ),
                      IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: walletProvider.isLoading
                            ? null
                            : () async {
                                await walletProvider.loadBalance();
                                await walletProvider.loadTransactions();
                              },
                      ),
                    ],
                  ),
                ),
                if (walletProvider.isLoading) ...[
                  Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ] else if (transactions.isEmpty) ...[
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.history,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            size: 48.0,
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'No transactions yet',
                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                              font: GoogleFonts.inter(),
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Your transactions will appear here',
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.inter(),
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = transactions[index];
                        return _buildTransactionCard(transaction);
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 80.0,
        height: 80.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 4.0,
              color: Color(0x14000000),
              offset: Offset(0.0, 2.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 24.0,
            ),
            SizedBox(height: 4.0),
            Text(
              label,
              style: FlutterFlowTheme.of(context).bodySmall.override(
                font: GoogleFonts.inter(),
                color: FlutterFlowTheme.of(context).primaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionCard(Transaction transaction) {
    final isIncoming = transaction.type == 'RECEIVE';
    final amount = transaction.amount;
    final address = '${transaction.addressFrom?.substring(0, 8)}...${transaction.addressFrom?.substring(transaction.addressFrom!.length - 8)}'
                   ?? '${transaction.addressTo?.substring(0, 8)}...${transaction.addressTo?.substring(transaction.addressTo!.length - 8)}';

    return Card(
      margin: EdgeInsets.only(bottom: 8.0),
      elevation: 2.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                color: isIncoming
                    ? FlutterFlowTheme.of(context).success.withOpacity(0.1)
