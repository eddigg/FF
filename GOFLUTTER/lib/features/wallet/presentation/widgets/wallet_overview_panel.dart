import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../bloc/wallet_bloc.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/themes/app_text_styles.dart';
import '../../../../shared/themes/app_spacing.dart';
import '../../../../../shared/widgets/common_widgets.dart';
import '../../../../shared/widgets/common_widgets.dart' as glass_card; // Import with prefix
// import '../../../../core/widgets/app_widgets.dart'; // Import GradientButton
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
              Text('Wallet Overview', style: AppTextStyles.h4),
              const SizedBox(height: AppSpacing.md),
              BlocBuilder<WalletBloc, WalletState>(
                builder: (context, state) {
                  if (state is WalletLoaded) {
                    return Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF11998e), Color(0xFF0D7A6F)],
                        ),
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF11998E).withValues(alpha: 0.2),
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
                            style: AppTextStyles.h3.copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            state.address,
                            style: AppTextStyles.caption.copyWith(color: Colors.white.withValues(alpha: 0.9)),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              GradientButton(
                                text: 'Copy',
                                onPressed: () {
                                  _copyToClipboard(context, state.address);
                                },
                                gradient: const LinearGradient(colors: AppColors.secondaryGradient),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              GradientButton(
                                text: 'QR',
                                onPressed: () {
                                  _showQRCode(context, state.address);
                                },
                                gradient: const LinearGradient(colors: AppColors.secondaryGradient),
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
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Account Management', style: AppTextStyles.h4),
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
                                      child: Text(account.name, style: AppTextStyles.body1),
                                    );
                                  }).toList(),
                                  onChanged: (account) {
                                    if (account != null) {
                                      context.read<WalletBloc>().add(SelectAccount(account));
                                    }
                                  },
                                  isExpanded: true,
                                  hint: const Text('Select Account', style: AppTextStyles.body1),
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
                                  ),
                                  GradientButton(
                                    text: '📥 Import', 
                                    onPressed: () {
                                      _showImportAccountDialog(context);
                                    },
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
                                  ),
                                ],
                              ),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              // KYC Section
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('KYC Verification', style: AppTextStyles.h4),
                        IconButton(
                          icon: Icon(_showKycFields ? Icons.expand_less : Icons.expand_more),
                          onPressed: () {
                            setState(() {
                              _showKycFields = !_showKycFields;
                            });
                          },
                        ),
                      ],
                    ),
                    if (_showKycFields) ...[
                      const SizedBox(height: AppSpacing.sm),
                      TextField(
                        controller: _kycStakeController,
                        decoration: InputDecoration(
                          labelText: 'Stake Amount',
                          labelStyle: AppTextStyles.body1,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextField(
                        controller: _kycFullNameController,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          labelStyle: AppTextStyles.body1,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextField(
                        controller: _kycCountryController,
                        decoration: InputDecoration(
                          labelText: 'Country',
                          labelStyle: AppTextStyles.body1,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextField(
                        controller: _kycIdNumberController,
                        decoration: InputDecoration(
                          labelText: 'ID Number',
                          labelStyle: AppTextStyles.body1,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
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
                          ),
                          const Text('Verified', style: AppTextStyles.body1),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      GradientButton(
                        text: 'Submit KYC',
                        onPressed: _submitKyc,
                        width: double.infinity,
                      ),
                    ],
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
      const SnackBar(content: Text('Address copied to clipboard')),
    );
  }

  void _showQRCode(BuildContext context, String address) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Wallet Address QR Code'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              QrImageView(
                data: address,
                version: QrVersions.auto,
                size: 200.0,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(address, style: AppTextStyles.caption),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showCreateAccountDialog(BuildContext context) {
    final nameController = TextEditingController();
    bool _isCreatingAccount = false;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create New Account'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Account Name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_isCreatingAccount) return;
                if (nameController.text.isNotEmpty) {
                  context.read<WalletBloc>().add(CreateAccount(name: nameController.text));
                  nameController.clear();
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _showImportAccountDialog(BuildContext context) {
    final jsonController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Import Account'),
          content: TextField(
            controller: jsonController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Account JSON',
              hintText: 'Paste your account JSON here',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (jsonController.text.isNotEmpty) {
                  context.read<WalletBloc>().add(ImportAccount(jsonController.text));
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Import'),
            ),
          ],
        );
      },
    );
  }

  void _exportAccount(BuildContext context, WalletAccount account) {
    // In a real implementation, this would export the account data
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account exported')),
    );
  }

  void _confirmDeleteAccount(BuildContext context, WalletAccount account) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: Text('Are you sure you want to delete account "${account.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
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

  void _submitKyc() {
    // In a real implementation, this would submit KYC data
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('KYC submitted')),
    );
  }
}
