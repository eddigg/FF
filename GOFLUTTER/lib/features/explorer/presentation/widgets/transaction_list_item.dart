import 'package:flutter/material.dart';
import '../../data/models/transaction_model.dart';
import 'transaction_detail_modal.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/custom_widgets.dart';

class TransactionListItem extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionListItem({Key? key, required this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return TransactionDetailModal(transaction: transaction);
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: AppSpacing.md),
        child: EnhancedGlassCard(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${transaction.amount} tokens',
                      style: AppTextStyles.h4.copyWith(
                        fontSize: 18,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      _formatTimestamp(transaction.timestamp),
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Hash: ${_shortenHash(transaction.hash)}',
                  style: AppTextStyles.address,
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDetail('From', _shortenAddress(transaction.from)),
                    _buildDetail('To', _shortenAddress(transaction.to)),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDetail('Fee', '${transaction.fee} tokens'),
                    _buildDetail('Nonce', transaction.nonce.toString()),
                  ],
                ),
                if (transaction.data.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  _buildDetail('Data', transaction.data),
                ],
                const SizedBox(height: AppSpacing.sm),
                _buildDetail('Signature', _shortenHash(transaction.signature)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetail(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.caption),
        Text(value, style: AppTextStyles.body2),
      ],
    );
  }

  String _formatTimestamp(int timestamp) {
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
  }

  String _shortenHash(String hash) {
    if (hash.length <= 16) return hash;
    return '${hash.substring(0, 8)}...${hash.substring(hash.length - 8)}';
  }

  String _shortenAddress(String address) {
    if (address.length <= 16) return address;
    return '${address.substring(0, 8)}...${address.substring(address.length - 4)}';
  }
}