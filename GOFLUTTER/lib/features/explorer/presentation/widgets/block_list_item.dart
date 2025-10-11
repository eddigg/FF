import 'package:flutter/material.dart';
import '../../data/models/block_model.dart';
import 'block_detail_modal.dart';
import '../../../../shared/widgets/common_widgets.dart';

class BlockListItem extends StatelessWidget {
  final dynamic block; // Accept both BlockModel and Map

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
                      'Block #${_getBlockProperty('height')}',
                      style: AppTextStyles.h4.copyWith(fontSize: 18),
                    ),
                    Text(
                      _getBlockProperty('timestamp').toString(),
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Hash: ${_shortenHash(_getBlockProperty('hash'))}',
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
                    _buildDetail(
                      'Transactions',
                      _getBlockProperty('transactions').toString(),
                    ),
                    _buildDetail(
                      'Validator',
                      _shortenAddress(_getBlockProperty('miner') ?? 'Unknown'),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                _buildDetail(
                  'Gas Used',
                  _getBlockProperty('gasUsed').toString(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  dynamic _getBlockProperty(String key) {
    if (block is Map<String, dynamic>) {
      return block[key];
    } else if (block is BlockModel) {
      switch (key) {
        case 'height':
          return block.index;
        case 'hash':
          return block.hash;
        case 'timestamp':
          return block.timestamp;
        case 'transactions':
          return block.transactions.length;
        case 'miner':
          return block.validator;
        case 'gasUsed':
          return 'N/A';
        default:
          return 'N/A';
      }
    }
    return 'N/A';
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
