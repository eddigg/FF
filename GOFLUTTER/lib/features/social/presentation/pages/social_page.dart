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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SocialSidebar(
            selectedSection: _selectedSection,
            onSectionSelected: _onSectionSelected,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(WebParityTheme.containerPadding),
                child: Column(
                  children: [
                    if (_selectedSection == 'feed') const SocialFeed(),
                    if (_selectedSection == 'create') const CreatePostSection(),
                    if (_selectedSection == 'trending') const TrendingTopicsSection(),
                    if (_selectedSection == 'moderation') const ContentModerationSection(),
                  ],
                ),
              ),
            ),
          ),
          const SocialRightSidebar(),
        ],
      ),
    );
  }
}