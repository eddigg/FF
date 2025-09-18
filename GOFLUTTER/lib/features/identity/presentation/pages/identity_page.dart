import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/identity_bloc.dart';
import '../../../../shared/themes/web_parity_theme.dart';
import '../../../../shared/themes/web_typography.dart';
import '../../../../shared/widgets/web_scaffold.dart';
import '../../../../shared/widgets/glass_card.dart';
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
      child: Row(
        children: [
          IdentitySidebar(
            selectedSection: _selectedSection,
            onSectionSelected: _onSectionSelected,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(WebParityTheme.containerPadding),
                child: BlocBuilder<IdentityBloc, IdentityState>(
                  builder: (context, state) {
                    // Always show content, even if data is not loaded
                    return Column(
                      children: [
                        _buildSectionHeader(),
                        const SizedBox(height: WebParityTheme.spacingMd),
                        _buildMockContent(),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    String title = 'Identity Management';
    String description = 'Manage your digital identity on the ATLAS blockchain';

    switch (_selectedSection) {
      case 'profile':
        title = 'Profile Management';
        description = 'View and update your personal information';
        break;
      case 'kyc':
        title = 'KYC Verification';
        description = 'Complete identity verification processes';
        break;
      case 'privacy':
        title = 'Privacy Settings';
        description = 'Control your privacy and data sharing preferences';
        break;
      case 'verification':
        title = 'Verification Options';
        description = 'Manage your verification methods and security';
        break;
      case 'activity':
        title = 'Activity History';
        description = 'View your identity-related activities and transactions';
        break;
      case 'reputation':
        title = 'Reputation System';
        description = 'Track your reputation score and standing';
        break;
    }

    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(WebParityTheme.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: WebTypography.h3,
            ),
            const SizedBox(height: WebParityTheme.spacingSm),
            Text(
              description,
              style: WebTypography.body1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMockContent() {
    String content = 'This section allows you to manage your digital identity on the ATLAS blockchain.';
    
    switch (_selectedSection) {
      case 'profile':
        content = 'Manage your profile information, including your name, avatar, and contact details.';
        break;
      case 'kyc':
        content = 'Complete KYC (Know Your Customer) verification to access advanced features and higher transaction limits.';
        break;
      case 'privacy':
        content = 'Control your privacy settings and decide what information to share with different parties.';
        break;
      case 'verification':
        content = 'Set up and manage various verification methods to secure your identity.';
        break;
      case 'activity':
        content = 'View your identity-related activities, including login attempts, profile changes, and verification events.';
        break;
      case 'reputation':
        content = 'Track your reputation score based on your activities and interactions on the network.';
        break;
    }

    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(WebParityTheme.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Identity Management',
              style: WebTypography.h3,
            ),
            const SizedBox(height: WebParityTheme.spacingMd),
            Text(
              content,
              style: WebTypography.body1,
            ),
            const SizedBox(height: WebParityTheme.spacingLg),
            Text(
              'This is a mockup of the $_selectedSection section. In a real implementation, this would show live identity data and allow you to manage your digital identity.',
              style: WebTypography.body2,
            ),
            const SizedBox(height: WebParityTheme.spacingMd),
            // Add some mock data visualization
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.purple.withValues(alpha: 0.1),
                    Colors.blue.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(WebParityTheme.radiusMd),
                border: Border.all(color: Colors.purple.withValues(alpha: 0.3)),
              ),
              child: const Center(
                child: Text(
                  '👤 Identity Data Visualization\n(Coming Soon)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}