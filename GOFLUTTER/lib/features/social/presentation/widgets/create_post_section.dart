import 'package:flutter/material.dart';
import 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' as glass_card;
import 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart';

class CreatePostSection extends StatelessWidget {
  const CreatePostSection({super.key});

  @override
  Widget build(BuildContext context) {
    final postContentController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('✏️ Create New Post', style: WebParityTheme.panelTitleStyle),
        const SizedBox(height: 20),
        glass_card.GlassCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: postContentController,
                maxLines: 5,
                decoration: WebParityTheme.inputDecoration('What\'s on your mind? Share your thoughts with the ATLAS community...'),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      _PostOptionButton(
                        text: '🌍 Public',
                        onPressed: () {
                          // For stub implementation, we just show a snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Privacy set to Public')),
                          );
                        },
                      ),
                      const SizedBox(width: 10),
                      _PostOptionButton(
                        text: '# Add Hashtag',
                        onPressed: () => postContentController.text += ' #',
                      ),
                      const SizedBox(width: 10),
                      _PostOptionButton(
                        text: '📷 Add Image',
                        onPressed: () {
                          // For stub implementation, we just show a snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Image upload feature')),
                          );
                        },
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (postContentController.text.isNotEmpty) {
                        // For stub implementation, we just show a snackbar
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Post created successfully!')),
                        );
                        postContentController.clear();
                      }
                    },
                    style: WebParityTheme.primaryButtonStyle,
                    child: const Text('Post'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PostOptionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _PostOptionButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF667EEA).withOpacity(0.1),
        foregroundColor: const Color(0xFF667EEA),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: BorderSide(color: const Color(0xFF667EEA).withOpacity(0.2)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }
}