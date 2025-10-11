import 'package:flutter/material.dart';
import 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' as glass_card;
import 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart';

class ContentModerationSection extends StatelessWidget {
  const ContentModerationSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for moderation queue
    final mockModerationQueue = [
      {
        'id': '1',
        'type': 'post',
        'content': 'This is a sample post that needs moderation for review.',
        'author': 'user123',
      },
      {
        'id': '2',
        'type': 'comment',
        'content': 'This comment might violate community guidelines.',
        'author': 'user456',
      },
      {
        'id': '3',
        'type': 'image',
        'content': 'Image post requiring manual review.',
        'author': 'user789',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('🛡️ Content Moderation', style: WebParityTheme.panelTitleStyle),
        const SizedBox(height: 20),
        if (mockModerationQueue.isEmpty)
          const Center(child: Text('No content pending moderation.'))
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: mockModerationQueue.length,
            itemBuilder: (context, index) {
              final item = mockModerationQueue[index];
              return _ModerationItem(item: item);
            },
          ),
      ],
    );
  }
}

class _ModerationItem extends StatelessWidget {
  final Map<String, dynamic> item;

  const _ModerationItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return glass_card.GlassCard(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item['type'].toString().toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF2D3748)),
          ),
          const SizedBox(height: 4),
          Text(
            item['content'],
            style: const TextStyle(fontSize: 14, color: Color(0xFF718096)),
          ),
          Text(
            'by ${item['author']}',
            style: const TextStyle(fontSize: 13, color: Color(0xFFA0AEC0)),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  // For stub implementation, we just show a snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Content approved')),
                  );
                },
                style: WebParityTheme.successButtonStyle.copyWith(
                  padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 12, vertical: 6)),
                  textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 13)),
                ),
                child: const Text('Approve'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  // For stub implementation, we just show a snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Content rejected')),
                  );
                },
                style: WebParityTheme.dangerButtonStyle.copyWith(
                  padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 12, vertical: 6)),
                  textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 13)),
                ),
                child: const Text('Reject'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}