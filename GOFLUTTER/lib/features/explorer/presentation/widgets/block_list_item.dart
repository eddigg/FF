import 'package:flutter/material.dart';
import '../../data/models/block_model.dart';
import 'block_detail_modal.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/custom_widgets.dart';

class BlockListItem extends StatelessWidget {
  final BlockModel block;

  const BlockListItem({Key? key, required this.block}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return BlockDetailModal(block: block);
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
                      'Block #${block.index}',
                      style: AppTextStyles.h4.copyWith(fontSize: 18),
                    ),
                    Text(
                      _formatTimestamp(block.timestamp),
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Hash: ${_shortenHash(block.hash)}',
                  style: AppTextStyles.address,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Previous Hash: ${_shortenHash(block.prevHash)}',
                  style: AppTextStyles.address,
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDetail('Transactions', block.transactions.length.toString()),
                    _buildDetail('Validator', _shortenAddress(block.validator)),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                _buildDetail('Signature', _shortenHash(block.signature)),
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