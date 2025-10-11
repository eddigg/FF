import 'package:flutter/material.dart';
import '../../data/models/block_model.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/themes/app_text_styles.dart';

class BlockDetailModal extends StatelessWidget {
  final BlockModel block;

  const BlockDetailModal({Key? key, required this.block}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(block.timestamp * 1000);
    final String formattedTimestamp = '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';

    return AlertDialog(
      title: Text('Block #${block.index}'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Hash', block.hash, true),
            _buildDetailRow('Previous Hash', block.prevHash, true),
            _buildDetailRow('Timestamp', formattedTimestamp),
            _buildDetailRow('Validator', block.validator, true),
            _buildDetailRow('Signature', block.signature, true),
            const SizedBox(height: 20),
            Text(
              'Transactions (${block.transactions.length})',
              style: AppTextStyles.h3,
            ),
            const SizedBox(height: 10),
            if (block.transactions.isEmpty)
              const Text('No transactions in this block')
            else
              ...block.transactions.map((tx) {
                final txData = tx as Map<String, dynamic>;
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('From', txData['Sender'] ?? '', true),
                      _buildDetailRow('To', txData['Recipient'] ?? '', true),
                      _buildDetailRow('Amount', '${txData['Amount'] ?? 0} tokens'),
                      _buildDetailRow('Fee', '${txData['Fee'] ?? 0} tokens'),
                    ],
                  ),
                );
              }).toList(),
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
