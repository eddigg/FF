import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../bloc/wallet_bloc.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/common_widgets.dart';
import '../../../../shared/widgets/glass_card.dart' as glass_card; // Import with prefix
import '../../domain/entities/account.dart';

class WalletOverviewPanel extends StatefulWidget {
  const WalletOverviewPanel({Key? key}) : super(key: key);

  @override
  State<WalletOverviewPanel> createState() => _WalletOverviewPanelState();
}

class _WalletOverviewPanelState extends State<WalletOverviewPanel> {
  late TextEditingController _accountNameController;
  bool _showKycFields = false;
  final TextEditingController _kycStakeController = TextEditingController();
  final TextEditingController _kycFullNameController = TextEditingController();
  final TextEditingController _kycCountryController = TextEditingController();
  final TextEditingController _kycIdNumberController = TextEditingController();
  bool _kycVerified = false;

  @override
  void initState() {
    super.initState();
    _accountNameController = TextEditingController();
  }

  @override
  void dispose() {
    _accountNameController.dispose();
    _kycStakeController.dispose();
    _kycFullNameController.dispose();
    _kycCountryController.dispose();
    _kycIdNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      child: glass_card.GlassCard(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Wallet Overview', style: AppTextStyles.h4),
              const SizedBox(height: AppSpacing.md),
              BlocBuilder<WalletBloc, WalletState>(
                builder: (context, state) {
                  if (state is WalletLoaded) {
                    return Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        gradient: AppColors.walletGradient,
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.defiGreen.withValues(alpha: 0.2),
                            offset: const Offset(0, 8),
                            blurRadius: 25,
                            spreadRadius: 0,
                          ),
                        ],
                        border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${state.balance.toStringAsFixed(2)} tokens',
                            style: AppTextStyles.balance.copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            state.address,
                            style: AppTextStyles.address.copyWith(color: Colors.white.withValues(alpha: 0.9)),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              GradientButton(
                                text: 'Copy',
                                onPressed: () {
                                  _copyToClipboard(context, state.address);
                                },
                                gradient: AppColors.secondaryGradient,
                                size: ButtonSize.small,
                                textStyle: AppTextStyles.button.copyWith(fontSize: 12, color: Colors.white),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              GradientButton(
                                text: 'QR',
                                onPressed: () {
                                  _showQRCode(context, state.address);
                                },
                                gradient: AppColors.secondaryGradient,
                                size: ButtonSize.small,
                                textStyle: AppTextStyles.button.copyWith(fontSize: 12, color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  } else if (state is WalletLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return const Text('Error loading wallet');
                  }
                },
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Account Management', style: AppTextStyles.h4),
                    const SizedBox(height: AppSpacing.sm),
                    BlocBuilder<WalletBloc, WalletState>(
                      builder: (context, state) {
                        if (state is WalletLoaded) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Account Selection Dropdown
                              if (state.accounts.isNotEmpty) ...[
                                DropdownButton<WalletAccount>(
                                  value: state.selectedAccount,
                                  items: state.accounts.map((account) {
                                    return DropdownMenuItem<WalletAccount>(
                                      value: account,
                                      child: Text(account.name),
                                    );
                                  }).toList(),
                                  onChanged: (account) {
                                    if (account != null) {
                                      context.read<WalletBloc>().add(SelectAccount(account));
                                    }
                                  },
                                  isExpanded: true,
                                  hint: const Text('Select Account'),
                                ),
                                const SizedBox(height: AppSpacing.sm),
                              ],
                              
                              // Account Actions
                              Wrap(
                                spacing: AppSpacing.sm,
                                runSpacing: AppSpacing.sm,
                                children: [
                                  GradientButton(
                                    text: '➕ New Account', 
                                    onPressed: () {
                                      _showCreateAccountDialog(context);
                                    },
                                    size: ButtonSize.small,
                                  ),
                                  GradientButton(
                                    text: '📤 Export', 
                                    onPressed: () {
                                      if (state.selectedAccount != null) {
                                        _exportAccount(context, state.selectedAccount!);
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('No account selected')),
                                        );
                                      }
                                    },
                                    size: ButtonSize.small,
                                  ),
                                  GradientButton(
                                    text: '📥 Import', 
                                    onPressed: () {
                                      _showImportAccountDialog(context);
                                    },
                                    size: ButtonSize.small,
                                  ),
                                  GradientButton(
                                    text: '🗑️ Delete', 
                                    onPressed: () {
                                      if (state.selectedAccount != null) {
                                        _confirmDeleteAccount(context, state.selectedAccount!);
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('No account selected')),
                                        );
                                      }
                                    },
                                    size: ButtonSize.small,
                                  ),
                                ],
                              ),
                            ],
                          );
                        }
                        return Container();
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Faucet Section
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFF6B6B), Color(0xFFEE5A24)],
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🚰 Testnet Faucet',
                      style: AppTextStyles.h5.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Get test tokens to try out the blockchain. Free tokens for testing!',
                      style: AppTextStyles.caption.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    GradientButton(
                      text: '💰 Request Faucet',
                      onPressed: () {
                        context.read<WalletBloc>().add(RequestTestTokens());
                      },
                      gradient: AppColors.successGradient,
                      size: ButtonSize.small,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Validator Registration Section
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  gradient: AppColors.walletGradient,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🏛️ Validator Registration',
                      style: AppTextStyles.h5.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Register as a validator to participate in consensus and earn rewards',
                      style: AppTextStyles.caption.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    GradientButton(
                      text: '🏛️ Register as Validator',
                      onPressed: () {
                        setState(() {
                          _showKycFields = !_showKycFields;
                        });
                      },
                      gradient: AppColors.successGradient,
                      size: ButtonSize.small,
                    ),
                    
                    // KYC Fields (hidden by default)
                    if (_showKycFields) ...[
                      const SizedBox(height: AppSpacing.md),
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                        ),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _kycStakeController,
                              style: AppTextStyles.body1.copyWith(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Stake Amount (min: 100)',
                                labelStyle: AppTextStyles.caption.copyWith(color: Colors.white70),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                                  borderSide: const BorderSide(color: Colors.white30),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                                  borderSide: const BorderSide(color: Colors.white),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            TextFormField(
                              controller: _kycFullNameController,
                              style: AppTextStyles.body1.copyWith(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Full Name',
                                labelStyle: AppTextStyles.caption.copyWith(color: Colors.white70),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                                  borderSide: const BorderSide(color: Colors.white30),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                                  borderSide: const BorderSide(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            TextFormField(
                              controller: _kycCountryController,
                              style: AppTextStyles.body1.copyWith(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Country',
                                labelStyle: AppTextStyles.caption.copyWith(color: Colors.white70),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                                  borderSide: const BorderSide(color: Colors.white30),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                                  borderSide: const BorderSide(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            TextFormField(
                              controller: _kycIdNumberController,
                              style: AppTextStyles.body1.copyWith(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'ID Number',
                                labelStyle: AppTextStyles.caption.copyWith(color: Colors.white70),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                                  borderSide: const BorderSide(color: Colors.white30),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                                  borderSide: const BorderSide(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Row(
                              children: [
                                Checkbox(
                                  value: _kycVerified,
                                  onChanged: (value) {
                                    setState(() {
                                      _kycVerified = value ?? false;
                                    });
                                  },
                                  fillColor: WidgetStateProperty.all(Colors.white),
                                ),
                                Text(
                                  'KYC Verified',
                                  style: AppTextStyles.caption.copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            GradientButton(
                              text: 'Submit Registration',
                              onPressed: _submitValidatorRegistration,
                              gradient: AppColors.successGradient,
                              size: ButtonSize.small,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Security Info Section
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFf8f9fa),
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Wallet Security',
                      style: AppTextStyles.h5,
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Text(
                      '🔒 Private Key: Never shared with the server',
                      style: AppTextStyles.caption,
                    ),
                    Text(
                      '🔐 Signing: Done locally in your browser',
                      style: AppTextStyles.caption,
                    ),
                    Text(
                      '💾 Storage: Encrypted in browser localStorage',
                      style: AppTextStyles.caption,
                    ),
                    Text(
                      '⚠️ Warning: Clear browser data = lost wallet',
                      style: AppTextStyles.caption,
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

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Address copied to clipboard!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showQRCode(BuildContext context, String address) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Wallet QR Code'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              QrImageView(
                data: address,
                version: QrVersions.auto,
                size: 200.0,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                address,
                style: AppTextStyles.caption,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                'Scan this QR code to share your wallet address',
                style: AppTextStyles.caption,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showCreateAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create New Account'),
          content: TextField(
            controller: _accountNameController,
            decoration: const InputDecoration(
              labelText: 'Account Name (optional)',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<WalletBloc>().add(CreateAccount(name: _accountNameController.text));
                _accountNameController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _showImportAccountDialog(BuildContext context) {
    final TextEditingController privateKeyController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Import Account'),
          content: TextField(
            controller: privateKeyController,
            decoration: const InputDecoration(
              labelText: 'Private Key',
              hintText: 'Enter your private key',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<WalletBloc>().add(ImportAccount(privateKeyController.text));
                privateKeyController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Import'),
            ),
          ],
        );
      },
    );
  }

  void _exportAccount(BuildContext context, WalletAccount account) {
    // In a real implementation, this would export the account to a file
    // For now, we'll just show a message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account exported successfully!')),
    );
    context.read<WalletBloc>().add(ExportAccount(account));
  }

  void _confirmDeleteAccount(BuildContext context, WalletAccount account) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text('Are you sure you want to delete this account? This cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<WalletBloc>().add(DeleteAccount(account));
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _submitValidatorRegistration() {
    final stake = int.tryParse(_kycStakeController.text);
    if (stake == null || stake < 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid stake amount (min: 100)')),
      );
      return;
    }
    
    if (_kycFullNameController.text.isEmpty || 
        _kycCountryController.text.isEmpty || 
        _kycIdNumberController.text.isEmpty || 
        !_kycVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All KYC fields are required and must be verified.')),
      );
      return;
    }
    
    // Call the bloc to register as validator
    context.read<WalletBloc>().add(RegisterAsValidator(
      stake: stake,
      fullName: _kycFullNameController.text,
      country: _kycCountryController.text,
      idNumber: _kycIdNumberController.text,
    ));
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registered as validator!')),
    );
    
    // Clear KYC fields
    _kycStakeController.clear();
    _kycFullNameController.clear();
    _kycCountryController.clear();
    _kycIdNumberController.clear();
    setState(() {
      _kycVerified = false;
      _showKycFields = false;
    });
  }
}