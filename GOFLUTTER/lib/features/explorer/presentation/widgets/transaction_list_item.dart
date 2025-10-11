import 'package:flutter/material.dart';
import '../../data/models/transaction_model.dart';
import 'transaction_detail_modal.dart';
import '../../../../shared/widgets/common_widgets.dart';

class TransactionListItem extends StatelessWidget {
  final dynamic transaction; // Accept both TransactionModel and Map

  const TransactionListItem({Key? key, required this.transaction})
    : super(key: key);

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
        margin: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.md,
        ),
        child: GlassCard(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_getTransactionProperty('value')}',
                      style: AppTextStyles.h4.copyWith(
                        fontSize: 18,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      _getTransactionProperty('timestamp').toString(),
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Hash: ${_shortenHash(_getTransactionProperty('hash'))}',
                  style: AppTextStyles.address,
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDetail(
                      'From',
                      _shortenAddress(_getTransactionProperty('from')),
                    ),
                    _buildDetail(
                      'To',
                      _shortenAddress(_getTransactionProperty('to')),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDetail(
                      'Gas Price',
                      _getTransactionProperty('gasPrice').toString(),
                    ),
                    _buildDetail(
                      'Status',
                      _getTransactionProperty('status').toString(),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                _buildDetail(
                  'Block',
                  _getTransactionProperty('blockNumber').toString(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  dynamic _getTransactionProperty(String key) {
    if (transaction is Map<String, dynamic>) {
      return transaction[key] ?? 'N/A';
    } else {
      // Handle TransactionModel if needed
      return 'N/A';
    }
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
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
      timestamp * 1000,
    );
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
