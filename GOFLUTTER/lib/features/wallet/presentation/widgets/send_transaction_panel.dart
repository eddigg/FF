import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/wallet_bloc.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../../shared/widgets/common_widgets.dart';
import '../../../../shared/widgets/common_widgets.dart' as glass_card;

class SendTransactionPanel extends StatefulWidget {
  const SendTransactionPanel({Key? key}) : super(key: key);

  @override
  State<SendTransactionPanel> createState() => _SendTransactionPanelState();
}

class _SendTransactionPanelState extends State<SendTransactionPanel> {
  final _recipientController = TextEditingController();
  final _amountController = TextEditingController();
  final _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _recipientController.dispose();
    _amountController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      child: glass_card.GlassCard(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Send Transaction', style: AppTextStyles.h4),
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.all(12.0),
                margin: const EdgeInsets.only(bottom: 12.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFf8f9fa),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _recipientController,
                        style: AppTextStyles.body1,
                        decoration: InputDecoration(
                          labelText: 'Recipient Address',
                          labelStyle: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(color: Color(0xFFe0e0e0), width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(color: Color(0xFFe0e0e0), width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(color: AppColors.defiGreen, width: 2),
                          ),
                          filled: true,
                          fillColor: AppColors.surface,
                          contentPadding: const EdgeInsets.all(8.0),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter recipient address';
                          }
                          if (value.length < 10) {
                            return 'Please enter a valid address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextFormField(
                        controller: _amountController,
                        style: AppTextStyles.body1,
                        decoration: InputDecoration(
                          labelText: 'Amount (tokens)',
                          labelStyle: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(color: Color(0xFFe0e0e0), width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(color: Color(0xFFe0e0e0), width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(color: AppColors.defiGreen, width: 2),
                          ),
                          filled: true,
                          fillColor: AppColors.surface,
                          contentPadding: const EdgeInsets.all(8.0),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter amount';
                          }
                          final amount = double.tryParse(value);
                          if (amount == null || amount <= 0) {
                            return 'Please enter a valid amount';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextFormField(
                        controller: _messageController,
                        style: AppTextStyles.body1,
                        decoration: InputDecoration(
                          labelText: 'Message (optional)',
                          labelStyle: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(color: Color(0xFFe0e0e0), width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(color: Color(0xFFe0e0e0), width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(color: AppColors.defiGreen, width: 2),
                          ),
                          filled: true,
                          fillColor: AppColors.surface,
                          contentPadding: const EdgeInsets.all(8.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GradientButton(
                text: '💸 Send Transaction',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final event = SendTransaction(
                      recipient: _recipientController.text,
                      amount: double.parse(_amountController.text),
                      message: _messageController.text,
                    );
                    context.read<WalletBloc>().add(event);
                    
                    _recipientController.clear();
                    _amountController.clear();
                    _messageController.clear();
                  }
                },
                width: double.infinity,
              ),
              const SizedBox(height: AppSpacing.md),
              const Text('Transaction History', style: AppTextStyles.h4),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                height: 200,
                child: BlocConsumer<WalletBloc, WalletState>(
                  listener: (context, state) {
                    if (state is WalletError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: AppColors.error,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is WalletLoaded) {
                      if (state.transactions.isEmpty) {
                        return const Center(
                          child: Text(
                            'No recent transactions',
                            style: AppTextStyles.body2,
                          ),
                        );
                      }
                      
                      return ListView.builder(
                        itemCount: state.transactions.length,
                        itemBuilder: (context, index) {
                          final tx = state.transactions[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 6.0),
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(6.0),
                              border: const Border(left: BorderSide(color: AppColors.defiGreen, width: 3)),
                              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2))],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${tx.amount} tokens',
                                      style: AppTextStyles.body1.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    Text(
                                      _formatTimestamp(tx.timestamp),
                                      style: AppTextStyles.caption,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  'To: ${_shortenAddress(tx.to)}',
                                  style: AppTextStyles.body2,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'From: ${_shortenAddress(tx.from)}',
                                  style: AppTextStyles.body2,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (tx.hash.isNotEmpty) ...[
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(
                                    'Hash: ${_shortenAddress(tx.hash)}',
                                    style: AppTextStyles.caption.copyWith(fontFamily: 'monospace'),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      );
                    } else if (state is WalletLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is WalletError) {
                      return Center(
                        child: Text(
                          'Error loading transactions: ${state.message}',
                          style: AppTextStyles.body2.copyWith(color: AppColors.error),
                        ),
                      );
                    } else {
                      return const Center(
                        child: Text(
                          'No transactions yet.',
                          style: AppTextStyles.body2,
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  String _formatTimestamp(int timestamp) {
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
  
  String _shortenAddress(String address) {
    if (address.length <= 16) return address;
    return '${address.substring(0, 8)}...${address.substring(address.length - 4)}';
  }
}
