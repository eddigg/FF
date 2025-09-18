import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart'; // For Clipboard
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../shared/themes/web_colors.dart';
import '../../../../shared/themes/web_gradients.dart';
import '../../../../shared/themes/web_shadows.dart';
import '../../../../shared/themes/web_typography.dart';
import '../../../../shared/widgets/web_scaffold.dart';
import '../bloc/wallet_bloc.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  String _walletAddress = 'Loading address...';
  String _walletBalance = '0 tokens';
  String _connectionStatus = 'Checking...';
  Color _connectionStatusColor = WebColors.textMuted;
  List<String> _transactionHistory = ['Loading transactions...'];
  final TextEditingController _recipientAddressController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _isSendingTransaction = false;
  String? _snackbarMessage;
  bool _isSnackbarError = false;

  // Validator registration fields
  bool _showKycFields = false;
  final TextEditingController _stakeController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();
  bool _kycVerified = false;
  bool _isRegisteringValidator = false;

  @override
  void initState() {
    super.initState();
    context.read<WalletBloc>().add(LoadWallet());
    _checkConnection();
  }

  Future<void> _checkConnection() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _connectionStatus = 'Connected to blockchain';
        _connectionStatusColor = WebColors.success;
      });
    }
  }

  void _showSnackbar(String message, {bool isError = false}) {
    if (!mounted) return;
    setState(() {
      _snackbarMessage = message;
      _isSnackbarError = isError;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _snackbarMessage = null;
        });
      }
    });
  }

  void _copyAddress() {
    Clipboard.setData(ClipboardData(text: _walletAddress));
    _showSnackbar('Address copied to clipboard!');
  }

  void _showQrCode() {
    if (_walletAddress == 'Loading address...') {
      _showSnackbar('Please wait for wallet to load', isError: true);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Wallet QR Code'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              QrImageView(
                data: _walletAddress,
                version: QrVersions.auto,
                size: 200.0,
              ),
              const SizedBox(height: 10),
              Text(
                'Scan this QR code to share your wallet address',
                textAlign: TextAlign.center,
                style: WebTypography.body2.copyWith(color: WebColors.textMuted),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _createAccount() {
    context.read<WalletBloc>().add(CreateAccount(name: 'Account ${DateTime.now().millisecondsSinceEpoch}'));
    _showSnackbar('New account created!');
  }

  void _importAccount() {
    _showImportWalletModal();
  }

  void _showImportWalletModal() {
    final TextEditingController importPrivateKeyController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Import Wallet'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Private Key (JWK format)',
                style: WebTypography.body2.copyWith(color: WebColors.textPrimary, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: importPrivateKeyController,
                maxLines: 4,
                decoration: _inputDecoration('Paste your private key in JWK format'),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final privateKey = importPrivateKeyController.text.trim();
                    if (privateKey.isNotEmpty) {
                      context.read<WalletBloc>().add(ImportAccount(privateKey));
                      Navigator.of(context).pop();
                      _showSnackbar('Importing wallet...');
                    } else {
                      _showSnackbar('Please enter a private key', isError: true);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: WebColors.primary,
                    foregroundColor: WebColors.surface,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Import Wallet',
                    style: WebTypography.button,
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _requestFaucet() {
    context.read<WalletBloc>().add(RequestTestTokens());
    _showSnackbar('Requesting faucet tokens...');
  }

  void _sendTransaction() {
    final recipient = _recipientAddressController.text.trim();
    final amount = double.tryParse(_amountController.text.trim());
    final message = _messageController.text.trim();

    if (recipient.isEmpty || amount == null || amount <= 0) {
      _showSnackbar('Please enter valid recipient address and amount', isError: true);
      return;
    }

    context.read<WalletBloc>().add(SendTransaction(
      recipient: recipient,
      amount: amount,
      message: message,
    ));
    _showSnackbar('Sending transaction...');
  }

  void _toggleKycFields() {
    setState(() {
      _showKycFields = !_showKycFields;
    });
  }

  void _submitValidatorRegistration() {
    final stake = int.tryParse(_stakeController.text.trim());
    final fullName = _fullNameController.text.trim();
    final country = _countryController.text.trim();
    final idNumber = _idNumberController.text.trim();

    if (stake == null || stake < 100 || fullName.isEmpty || country.isEmpty || idNumber.isEmpty || !_kycVerified) {
      _showSnackbar('All KYC fields are required, stake must be at least 100, and KYC must be verified.', isError: true);
      return;
    }

    context.read<WalletBloc>().add(RegisterAsValidator(
      stake: stake,
      fullName: fullName,
      country: country,
      idNumber: idNumber,
    ));
    _showSnackbar('Submitting validator registration...');
  }

  @override
  void dispose() {
    _recipientAddressController.dispose();
    _amountController.dispose();
    _messageController.dispose();
    _stakeController.dispose();
    _fullNameController.dispose();
    _countryController.dispose();
    _idNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Force analyzer re-evaluation
    return WebScaffold(
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: WebGradients.backgroundMain,
            ),
          ),
          BlocConsumer<WalletBloc, WalletState>(
            listener: (context, state) {
              if (state is WalletLoaded) {
                if (mounted) {
                  setState(() {
                    _walletAddress = state.address;
                    _walletBalance = '${state.balance} tokens';
                    _transactionHistory = state.transactions.map((tx) => '${tx.amount} tokens from ${tx.from} to ${tx.to}').toList();
                  });
                }
              } else if (state is WalletError) {
                _showSnackbar(state.message, isError: true);
              }
            },
            builder: (context, state) {
              bool isLoading = state is WalletLoading;

              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 20),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth > 768) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: _buildWalletOverviewPanel(isLoading)),
                                const SizedBox(width: 20),
                                Expanded(child: _buildTransactionPanel(isLoading)),
                              ],
                            );
                          } else {
                            return SingleChildScrollView(
                              child: Column(
                                children: [
                                  _buildWalletOverviewPanel(isLoading),
                                  const SizedBox(height: 20),
                                  _buildTransactionPanel(isLoading),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          if (_snackbarMessage != null)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: _buildSnackbar(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'User Wallet',
          style: WebTypography.h1.copyWith(
            foreground: Paint()..shader = WebGradients.headerTitle.createShader(Rect.fromLTWH(0, 0, 200, 70)),
          ),
        ),
        GestureDetector(
          onTap: () => context.go('/dashboard'),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: WebColors.textPrimary.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: WebColors.surface.withValues(alpha: 0.3)),
              boxShadow: WebShadows.logoutButton,
            ),
            child: Text(
              '← Back to Dashboard',
              style: WebTypography.body1.copyWith(color: WebColors.surface),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWalletOverviewPanel(bool isLoading) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: WebColors.surface.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: WebShadows.card,
        border: Border.all(color: WebColors.surface.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Wallet Overview',
            style: WebTypography.h4.copyWith(color: WebColors.textPrimary),
          ),
          const SizedBox(height: 15),
          Text(
            _connectionStatus,
            style: WebTypography.body2.copyWith(color: _connectionStatusColor, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: WebGradients.buttonPrimary,
              borderRadius: BorderRadius.all(Radius.circular(16)),
              boxShadow: WebShadows.button,
              border: Border(
                top: BorderSide(color: WebColors.surface, width: 0.2),
                left: BorderSide(color: WebColors.surface, width: 0.2),
                right: BorderSide(color: WebColors.surface, width: 0.2),
                bottom: BorderSide(color: WebColors.surface, width: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _walletBalance,
                  style: WebTypography.h3.copyWith(color: WebColors.surface, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _walletAddress,
                        style: WebTypography.body2.copyWith(color: WebColors.surface.withValues(alpha: 0.9), fontFamily: 'monospace'),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: _copyAddress,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: WebColors.textMuted,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Copy',
                          style: WebTypography.caption.copyWith(color: WebColors.surface),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: _showQrCode,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: WebColors.textMuted,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '📱 QR',
                          style: WebTypography.caption.copyWith(color: WebColors.surface),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          // Wallet Options Section
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              gradient: WebGradients.buttonSecondary,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '⚙️ Wallet Options',
                  style: WebTypography.body1.copyWith(color: WebColors.surface, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: [
                    _buildOptionButton('➕ New Account', WebColors.primary, _createAccount),
                    _buildOptionButton('📥 Import', WebColors.warning, _importAccount),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Faucet Section
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              gradient: WebGradients.buttonSuccess,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🚰 Testnet Faucet',
                  style: WebTypography.body1.copyWith(color: WebColors.surface, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Get test tokens to try out the blockchain. Free tokens for testing!',
                  style: WebTypography.body2.copyWith(color: WebColors.surface.withValues(alpha: 0.9)),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _requestFaucet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: WebColors.success,
                      foregroundColor: WebColors.surface,
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(color: WebColors.surface, strokeWidth: 2),
                          )
                        : Text(
                            '💰 Request Faucet',
                            style: WebTypography.button.copyWith(fontSize: 14),
                          ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Security Info
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: WebColors.formBackground,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Wallet Security',
                  style: WebTypography.body2.copyWith(color: WebColors.textPrimary, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  '🔒 Private Key: Never shared with the server',
                  style: WebTypography.caption.copyWith(color: WebColors.textMuted),
                ),
                Text(
                  '🔐 Signing: Done locally in your browser',
                  style: WebTypography.caption.copyWith(color: WebColors.textMuted),
                ),
                Text(
                  '💾 Storage: Encrypted in browser localStorage',
                  style: WebTypography.caption.copyWith(color: WebColors.textMuted),
                ),
                Text(
                  '⚠️ Warning: Clear browser data = lost wallet',
                  style: WebTypography.caption.copyWith(color: WebColors.textMuted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Validator Registration Section
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              gradient: WebGradients.buttonWarning,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🏛️ Validator Registration',
                  style: WebTypography.body1.copyWith(color: WebColors.surface, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  'Register as a validator to participate in consensus and earn rewards',
                  style: WebTypography.body2.copyWith(color: WebColors.surface.withValues(alpha: 0.9)),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _toggleKycFields,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: WebColors.success,
                      foregroundColor: WebColors.surface,
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(
                      '🏛️ Register as Validator',
                      style: WebTypography.button.copyWith(fontSize: 14),
                    ),
                  ),
                ),
                if (_showKycFields)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: WebColors.surface.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildKycInputField('Stake Amount (min: 100)', _stakeController, keyboardType: TextInputType.number),
                          _buildKycInputField('Full Name', _fullNameController),
                          _buildKycInputField('Country', _countryController),
                          _buildKycInputField('ID Number', _idNumberController),
                          Row(
                            children: [
                              Checkbox(
                                value: _kycVerified,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _kycVerified = value ?? false;
                                  });
                                },
                                activeColor: WebColors.primary,
                              ),
                              Text(
                                'KYC Verified',
                                style: WebTypography.body2.copyWith(color: WebColors.surface),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isRegisteringValidator ? null : _submitValidatorRegistration,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: WebColors.primary,
                                foregroundColor: WebColors.surface,
                                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: _isRegisteringValidator
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(color: WebColors.surface, strokeWidth: 2),
                                    )
                                  : Text(
                                      'Submit Registration',
                                      style: WebTypography.button.copyWith(fontSize: 14),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionPanel(bool isLoading) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: WebColors.surface.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: WebShadows.card,
        border: Border.all(color: WebColors.surface.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Send Transaction',
            style: WebTypography.h4.copyWith(color: WebColors.textPrimary),
          ),
          const SizedBox(height: 15),
          // Transaction Form
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: WebColors.formBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _buildFormGroup(
                  'Recipient Address',
                  TextField(
                    controller: _recipientAddressController,
                    decoration: _inputDecoration('Enter recipient\'s public key'),
                  ),
                ),
                _buildFormGroup(
                  'Amount (tokens)',
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration('Enter amount'),
                  ),
                ),
                _buildFormGroup(
                  'Message (optional)',
                  TextField(
                    controller: _messageController,
                    decoration: _inputDecoration('Add a message to your transaction'),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _sendTransaction,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: WebColors.primary,
                      foregroundColor: WebColors.surface,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(color: WebColors.surface, strokeWidth: 2),
                          )
                        : Text(
                            '💸 Send Transaction',
                            style: WebTypography.button,
                          ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Transaction History',
            style: WebTypography.body1.copyWith(color: WebColors.textPrimary, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: _transactionHistory.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: WebColors.surface,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: WebColors.formBorder),
                  ),
                  child: Text(
                    _transactionHistory[index],
                    style: WebTypography.body2.copyWith(color: WebColors.textPrimary),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormGroup(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: WebTypography.formLabel,
        ),
        const SizedBox(height: 6),
        child,
        const SizedBox(height: 12),
      ],
    );
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: WebTypography.formInput.copyWith(color: WebColors.textMuted),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: WebColors.formBorder, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: WebColors.formBorder, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: WebColors.primary, width: 2),
      ),
      filled: true,
      fillColor: WebColors.surface,
      contentPadding: const EdgeInsets.all(12),
    );
  }

  Widget _buildOptionButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: WebColors.surface,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        elevation: 0,
      ),
      child: Text(
        text,
        style: WebTypography.button.copyWith(fontSize: 12),
      ),
    );
  }

  Widget _buildKycInputField(String label, TextEditingController controller, {TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: WebTypography.body2.copyWith(color: WebColors.surface),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: WebTypography.formInput.copyWith(color: WebColors.surface),
          decoration: _inputDecoration('').copyWith(
            filled: true,
            fillColor: WebColors.surface.withValues(alpha: 0.1),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: WebColors.surface.withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: WebColors.surface),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildSnackbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: _isSnackbarError ? WebColors.statusErrorBackground : WebColors.statusSuccessBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _isSnackbarError ? WebColors.statusErrorBorder : WebColors.statusSuccessBorder,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _isSnackbarError ? Icons.error_outline : Icons.check_circle_outline,
            color: _isSnackbarError ? WebColors.statusErrorText : WebColors.statusSuccessText,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            _snackbarMessage!,
            style: WebTypography.body2.copyWith(
              color: _isSnackbarError ? WebColors.statusErrorText : WebColors.statusSuccessText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}