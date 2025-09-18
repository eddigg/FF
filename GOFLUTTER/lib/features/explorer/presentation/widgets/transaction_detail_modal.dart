import 'package:flutter/material.dart';
import '../../data/models/transaction_model.dart';
import '../../../../shared/themes/app_colors.dart';

class TransactionDetailModal extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionDetailModal({Key? key, required this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(transaction.timestamp * 1000);
    final String formattedTimestamp = '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';

    return AlertDialog(
      title: const Text('Transaction Details'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Hash', transaction.hash, true),
            _buildDetailRow('From', transaction.from, true),
            _buildDetailRow('To', transaction.to, true),
            _buildDetailRow('Amount', '${transaction.amount} tokens'),
            _buildDetailRow('Fee', '${transaction.fee} tokens'),
            _buildDetailRow('Timestamp', formattedTimestamp),
            _buildDetailRow('Nonce', transaction.nonce.toString()),
            if (transaction.data.isNotEmpty)
              _buildDetailRow('Data', transaction.data),
            _buildDetailRow('Signature', transaction.signature, true),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, [bool isMonospace = false]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.caption,
          ),
          Text(
            value,
            style: isMonospace
                ? AppTextStyles.address
                : AppTextStyles.body1,
          ),
        ],
      ),
    );
  }
}