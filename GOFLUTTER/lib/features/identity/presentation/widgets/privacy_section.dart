import 'package:flutter/material.dart';
import 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' as glass_card;
import '../../../../shared/themes/web_parity_theme.dart';

const ButtonStyle fallbackSecondaryButtonStyle = ButtonStyle(
  backgroundColor: WidgetStatePropertyAll(Color(0xFF4A5568)),
  foregroundColor: WidgetStatePropertyAll(Colors.white),
  padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
);

const ButtonStyle fallbackWarningButtonStyle = ButtonStyle(
  backgroundColor: WidgetStatePropertyAll(Color(0xFFED8936)),
  foregroundColor: WidgetStatePropertyAll(Colors.white),
  padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
);

const ButtonStyle fallbackDangerButtonStyle = ButtonStyle(
  backgroundColor: WidgetStatePropertyAll(Color(0xFFF56565)),
  foregroundColor: WidgetStatePropertyAll(Colors.white),
  padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
);

class PrivacySection extends StatelessWidget {
  const PrivacySection({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock privacy settings data
    final mockPrivacySettings = {
      'profileVisibility': true,
      'activityVisibility': true,
      'allowDirectMessages': true,
      'showOnlineStatus': false,
      'dataSharing': false,
      'analyticsTracking': true,
      'marketingEmails': false,
      'thirdPartySharing': false,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('🔒 Privacy Settings', style: WebParityTheme.panelTitleStyle),
        const SizedBox(height: 20),
        Column(
          children: [
            glass_card.GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Privacy Controls', style: WebParityTheme.cardTitleStyle),
                  const SizedBox(height: 15),
                  _PrivacyOption(
                    title: 'Public Profile',
                    description: 'Allow others to view your profile',
                    value: mockPrivacySettings['profileVisibility'] as bool,
                    onChanged: (val) {
                      // For stub implementation, we just show a snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Privacy setting updated')),
                      );
                    },
                  ),
                  _PrivacyOption(
                    title: 'Activity Visibility',
                    description: 'Show your activity to others',
                    value: mockPrivacySettings['activityVisibility'] as bool,
                    onChanged: (val) {
                      // For stub implementation, we just show a snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Privacy setting updated')),
                      );
                    },
                  ),
                  _PrivacyOption(
                    title: 'Direct Messages',
                    description: 'Allow others to send you messages',
                    value: mockPrivacySettings['allowDirectMessages'] as bool,
                    onChanged: (val) {
                      // For stub implementation, we just show a snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Privacy setting updated')),
                      );
                    },
                  ),
                  _PrivacyOption(
                    title: 'Online Status',
                    description: 'Show when you are online',
                    value: mockPrivacySettings['showOnlineStatus'] as bool,
                    onChanged: (val) {
                      // For stub implementation, we just show a snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Privacy setting updated')),
                      );
                    },
                  ),
                  _PrivacyOption(
                    title: 'Data Sharing',
                    description: 'Share data with ATLAS partners',
                    value: mockPrivacySettings['dataSharing'] as bool,
                    onChanged: (val) {
                      // For stub implementation, we just show a snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Privacy setting updated')),
                      );
                    },
                  ),
                  _PrivacyOption(
                    title: 'Analytics Tracking',
                    description: 'Allow analytics and usage tracking',
                    value: mockPrivacySettings['analyticsTracking'] as bool,
                    onChanged: (val) {
                      // For stub implementation, we just show a snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Privacy setting updated')),
                      );
                    },
                  ),
                  _PrivacyOption(
                    title: 'Marketing Emails',
                    description: 'Receive marketing communications',
                    value: mockPrivacySettings['marketingEmails'] as bool,
                    onChanged: (val) {
                      // For stub implementation, we just show a snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Privacy setting updated')),
                      );
                    },
                  ),
                  _PrivacyOption(
                    title: 'Third-party Sharing',
                    description: 'Share data with third parties',
                    value: mockPrivacySettings['thirdPartySharing'] as bool,
                    onChanged: (val) {
                      // For stub implementation, we just show a snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Privacy setting updated')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            glass_card.GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Data Management', style: WebParityTheme.cardTitleStyle),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // For stub implementation, we just show a snackbar
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Exporting your data...')),
                        );
                      },
                      style: fallbackSecondaryButtonStyle,
                      child: const Text('Export My Data'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // For stub implementation, we just show a snackbar
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Anonymizing your data...')),
                        );
                      },
                      style: fallbackWarningButtonStyle,
                      child: const Text('Anonymize Data'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // For stub implementation, we just show a snackbar
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Deleting your account...')),
                        );
                      },
                      style: fallbackDangerButtonStyle,
                      child: const Text('Delete Account'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PrivacyOption extends StatelessWidget {
  final String title;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _PrivacyOption({required this.title, required this.description, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF2D3748))),
                Text(description, style: const TextStyle(fontSize: 14, color: Color(0xFF718096))),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF48BB78),
          ),
        ],
      ),
    );
  }
}