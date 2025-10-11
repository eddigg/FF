import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart';
import 'package:atlas_blockchain_flutter/shared/widgets/web_scaffold.dart';
import 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart';
import '../../../../core/stubs/stub_blocs_clean.dart';
import '../../../../core/core.dart';
import '../../data/models/transaction_model.dart';
import '../../domain/entities/account.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<WalletBloc>().add(LoadWallet());

    return WebScaffold(
      title: 'User Wallet',
      showBackButton: true,
      body: BlocConsumer<WalletBloc, WalletState>(
        listener: (context, state) {
          if (state is WalletError) {
            _showSnackbar(context, state.message, isError: true);
          }
          if (state is WalletActionSuccess) {
            _showSnackbar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is WalletLoaded) {
            return LayoutBuilder(
              builder: (context, constraints) {
                bool isWide = constraints.maxWidth > 768;
                if (isWide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _WalletOverviewPanel(state: state)),
                      const SizedBox(width: 20),
                      Expanded(child: _TransactionPanel(state: state)),
                    ],
                  );
                } else {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        _WalletOverviewPanel(state: state),
                        const SizedBox(height: 20),
                        _TransactionPanel(state: state),
                      ],
                    ),
                  );
                }
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void _showSnackbar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
      ),
    );
  }
}

class _WalletOverviewPanel extends StatelessWidget {
  final WalletLoaded state;
  const _WalletOverviewPanel({required this.state});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        children: [
          _PanelTitle(title: 'Wallet Overview'),
          _WalletInfoCard(state: state),
          _WalletOptions(state: state),
          _FaucetSection(),
          _ValidatorRegistration(state: state),
          const _SecurityInfo(),
        ],
      ),
    );
  }
}

class _TransactionPanel extends StatefulWidget {
  final WalletLoaded state;
  const _TransactionPanel({required this.state});

  @override
  State<_TransactionPanel> createState() => _TransactionPanelState();
}

class _TransactionPanelState extends State<_TransactionPanel> {
  final _recipientController = TextEditingController();
  final _amountController = TextEditingController();
  final _messageController = TextEditingController();

  void _sendTransaction() {
    context.read<WalletBloc>().add(
      SendTransaction(
        recipient: _recipientController.text,
        amount: double.tryParse(_amountController.text) ?? 0,
        message: _messageController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        children: [
          _PanelTitle(title: 'Send Transaction'),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _buildFormGroup(
                  'Recipient Address',
                  _recipientController,
                  'Enter recipient\'s public key',
                ),
                _buildFormGroup(
                  'Amount (tokens)',
                  _amountController,
                  'Enter amount',
                  isNumeric: true,
                ),
                _buildFormGroup(
                  'Message (optional)',
                  _messageController,
                  'Add a message to your transaction',
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _sendTransaction,
                    style: WebParityTheme.primaryButtonStyle,
                    child: const Text('💸 Send Transaction'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Transaction History',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: widget.state.transactions.length,
              itemBuilder: (context, index) {
                final tx = widget.state.transactions[index];
                final isSent = tx['from'] == widget.state.address;
                return Card(
                  margin: const EdgeInsets.only(bottom: 6),
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                    side: BorderSide(
                      color: isSent ? Colors.redAccent : Colors.green,
                      width: 3,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isSent ? 'SENT' : 'RECEIVED',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isSent ? Colors.redAccent : Colors.green,
                              ),
                            ),
                            Text(
                              '${tx['amount']} tokens',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'To: ${tx['to'].toString().substring(0, 8)}...',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        if (tx['message'].toString().isNotEmpty)
                          Text(
                            'Message: ${tx['message']}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormGroup(
    String label,
    TextEditingController controller,
    String hint, {
    bool isNumeric = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
            decoration: WebParityTheme.inputDecoration(hint),
          ),
        ],
      ),
    );
  }
}

class _PanelTitle extends StatelessWidget {
  final String title;
  const _PanelTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF2D3748),
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.01,
        ),
      ),
    );
  }
}

class _WalletInfoCard extends StatelessWidget {
  final WalletLoaded state;
  const _WalletInfoCard({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF11998E), Color(0xFF0D7A6F)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF11998E).withOpacity(0.2),
            blurRadius: 25,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${state.balance} tokens',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text(
                  state.address,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: Colors.white,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy, size: 16, color: Colors.white),
                onPressed: () =>
                    Clipboard.setData(ClipboardData(text: state.address)),
              ),
              IconButton(
                icon: const Icon(Icons.qr_code, size: 16, color: Colors.white),
                onPressed: () => _showQrDialog(context, state.address),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showQrDialog(BuildContext context, String address) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Wallet QR Code'),
        content: SizedBox(
          width: 200,
          height: 200,
          child: QrImageView(data: address, version: QrVersions.auto),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _WalletOptions extends StatelessWidget {
  final WalletLoaded state;
  const _WalletOptions({required this.state});

  @override
  Widget build(BuildContext context) {
    return _StyledContainer(
      gradient: const LinearGradient(
        colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '⚙️ Wallet Options',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<int>(
            value: state.selectedAccountIndex,
            items: List.generate(
              state.accounts.length,
              (index) => DropdownMenuItem(
                value: index,
                child: Text(state.accounts[index]['name']),
              ),
            ),
            onChanged: (index) {
              if (index != null && index < state.accounts.length) {
                context.read<WalletBloc>().add(
                  SelectAccount(state.accounts[index]),
                );
              }
            },
            decoration: WebParityTheme.inputDecoration(
              'Select Account',
            ).copyWith(fillColor: Colors.white.withOpacity(0.2)),
            dropdownColor: const Color(0xFF11998E),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _OptionButton(
                  text: '➕ New Account',
                  onPressed: () => context.read<WalletBloc>().add(
                    CreateAccount(name: 'Account ${state.accounts.length + 1}'),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _OptionButton(text: '📥 Import', onPressed: () {}),
              ), // TODO: Implement Import
            ],
          ),
        ],
      ),
    );
  }
}

class _FaucetSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _StyledContainer(
      gradient: const LinearGradient(
        colors: [Color(0xFFFF6B6B), Color(0xFFEE5A24)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🚰 Testnet Faucet',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            'Get test tokens to try out the blockchain. Free tokens for testing!',
            style: TextStyle(color: Colors.white, fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: _OptionButton(
              text: '💰 Request Faucet',
              onPressed: () =>
                  context.read<WalletBloc>().add(RequestTestTokens()),
            ),
          ),
        ],
      ),
    );
  }
}

class _ValidatorRegistration extends StatelessWidget {
  final WalletLoaded state;
  const _ValidatorRegistration({required this.state});

  @override
  Widget build(BuildContext context) {
    // Simplified for brevity. In a real app, this would have its own state management.
    return _StyledContainer(
      gradient: const LinearGradient(
        colors: [Color(0xFF11998E), Color(0xFF0D7A6F)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🏛️ Validator Registration',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Register as a validator to participate in consensus and earn rewards',
            style: TextStyle(color: Colors.white, fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: _OptionButton(
              text: '🏛️ Register as Validator',
              onPressed: () {},
            ),
          ), // TODO: Implement registration flow
        ],
      ),
    );
  }
}

class _SecurityInfo extends StatelessWidget {
  const _SecurityInfo();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Wallet Security',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(height: 6),
          Text(
            '🔒 Private Key: Never shared with the server',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Text(
            '🔐 Signing: Done locally in your browser',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Text(
            '💾 Storage: Encrypted in browser localStorage',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Text(
            '⚠️ Warning: Clear browser data = lost wallet',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _StyledContainer extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  const _StyledContainer({required this.child, required this.gradient});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}

class _OptionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const _OptionButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.2),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      child: Text(text),
    );
  }
}
