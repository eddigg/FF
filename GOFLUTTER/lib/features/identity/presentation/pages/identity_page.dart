import 'package:flutter/material.dart';
import '../widgets/profile_section.dart';
import '../widgets/kyc_section.dart';
import '../widgets/privacy_section.dart';
import '../widgets/verification_section.dart';
import '../widgets/activity_section.dart';
import '../widgets/reputation_section.dart';
import '../../../../shared/themes/web_parity_theme.dart';
import '../../../../shared/widgets/web_scaffold.dart';
import '../widgets/identity_sidebar.dart';

class IdentityPage extends StatefulWidget {
  const IdentityPage({Key? key}) : super(key: key);

  @override
  State<IdentityPage> createState() => _IdentityPageState();
}

class _IdentityPageState extends State<IdentityPage> {
  String _selectedSection = 'profile';

  void _onSectionSelected(String section) {
    setState(() {
      _selectedSection = section;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WebScaffold(
      title: 'ATLAS Identity Management',
      showBackButton: true,
      body: Row(
        children: [
          SizedBox(
            width: 250,
            child: IdentitySidebar(
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
                      'ATLAS Identity Management',
                      style: WebParityTheme.panelTitleStyle,
                    ),
                    const SizedBox(height: WebParityTheme.spacingLg),
                    const Text(
                      'Manage your digital identity on the ATLAS blockchain.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: WebParityTheme.spacingLg * 2),
                    if (_selectedSection == 'profile') const ProfileSection(),
                    if (_selectedSection == 'kyc') const KycSection(),
                    if (_selectedSection == 'privacy') const PrivacySection(),
                    if (_selectedSection == 'verification') const VerificationSection(),
                    if (_selectedSection == 'activity') const ActivitySection(),
                    if (_selectedSection == 'reputation') const ReputationSection(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}