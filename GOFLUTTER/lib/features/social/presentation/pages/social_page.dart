import 'package:flutter/material.dart';
import '../widgets/social_feed.dart';
import '../widgets/create_post_section.dart';
import '../widgets/trending_topics_section.dart';
import '../widgets/content_moderation_section.dart';
import '../widgets/social_sidebar.dart';
import '../widgets/social_right_sidebar.dart';
import '../../../../shared/themes/web_parity_theme.dart';
import '../../../../shared/widgets/web_scaffold.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({Key? key}) : super(key: key);

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  String _selectedSection = 'feed';

  void _onSectionSelected(String section) {
    setState(() {
      _selectedSection = section;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WebScaffold(
      title: 'ATLAS Social Platform',
      showBackButton: true,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 250,
            child: SocialSidebar(
              selectedSection: _selectedSection,
              onSectionSelected: _onSectionSelected,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(WebParityTheme.containerPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ATLAS Social Platform',
                      style: WebParityTheme.panelTitleStyle,
                    ),
                    const SizedBox(height: WebParityTheme.spacingLg),
                    const Text(
                      'Connect with the ATLAS community, share ideas, and collaborate on blockchain projects.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: WebParityTheme.spacingLg * 2),
                    if (_selectedSection == 'feed') const SocialFeed(),
                    if (_selectedSection == 'create') const CreatePostSection(),
                    if (_selectedSection == 'trending') const TrendingTopicsSection(),
                    if (_selectedSection == 'moderation') const ContentModerationSection(),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: WebParityTheme.spacingMd),
          const SizedBox(
            width: 250,
            child: SocialRightSidebar(),
          ),
        ],
      ),
    );
  }
}