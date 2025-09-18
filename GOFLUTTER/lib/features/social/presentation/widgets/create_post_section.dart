import 'package:flutter/material.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/common_widgets.dart';

class CreatePostSection extends StatefulWidget {
  const CreatePostSection({Key? key}) : super(key: key);

  @override
  State<CreatePostSection> createState() => _CreatePostSectionState();
}

class _CreatePostSectionState extends State<CreatePostSection> {
  final TextEditingController _postController = TextEditingController();
  String _privacy = 'Public';
  bool _isPublic = true;

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  void _createPost() {
    if (_postController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter some content for your post.')),
      );
      return;
    }

    // TODO: Implement actual post creation logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post created successfully!')),
    );
    
    // Clear the text field
    _postController.clear();
  }

  void _togglePrivacy() {
    setState(() {
      _isPublic = !_isPublic;
      _privacy = _isPublic ? 'Public' : 'Private';
    });
  }

  void _addHashtag() {
    _postController.text += ' #';
    _postController.selection = TextSelection.fromPosition(
      TextPosition(offset: _postController.text.length),
    );
  }

  void _addImage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image upload functionality coming soon!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('✏️ Create New Post', style: AppTextStyles.h4),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _postController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'What\'s on your mind? Share your thoughts with the ATLAS community...',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Wrap(
                  spacing: AppSpacing.sm,
                  children: [
                    GradientButton(
                      text: '🌍 $_privacy',
                      onPressed: _togglePrivacy,
                      gradient: AppColors.primaryGradient,
                      width: 100,
                    ),
                    GradientButton(
                      text: '# Add Hashtag',
                      onPressed: _addHashtag,
                      gradient: AppColors.primaryGradient,
                      width: 120,
                    ),
                    GradientButton(
                      text: '📷 Add Image',
                      onPressed: _addImage,
                      gradient: AppColors.primaryGradient,
                      width: 120,
                    ),
                  ],
                ),
                GradientButton(
                  text: 'Post',
                  onPressed: _createPost,
                  gradient: AppColors.successGradient,
                  width: 100,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}