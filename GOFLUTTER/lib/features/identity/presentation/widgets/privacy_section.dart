import 'package:flutter/material.dart';
import '../../data/models/privacy_settings_model.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/common_widgets.dart';

class PrivacySection extends StatefulWidget {
  final PrivacySettingsModel privacySettings;

  const PrivacySection({Key? key, required this.privacySettings}) : super(key: key);

  @override
  State<PrivacySection> createState() => _PrivacySectionState();
}

class _PrivacySectionState extends State<PrivacySection> {
  late Map<String, bool> _privacySettings;

  @override
  void initState() {
    super.initState();
    _privacySettings = {
      'profileVisibility': widget.privacySettings.profileVisibility,
      'activityVisibility': widget.privacySettings.activityVisibility,
      'allowDirectMessages': widget.privacySettings.allowDirectMessages,
      'showOnlineStatus': widget.privacySettings.showOnlineStatus,
      'dataSharing': widget.privacySettings.dataSharing,
      'analyticsTracking': widget.privacySettings.analyticsTracking,
      'marketingEmails': widget.privacySettings.marketingEmails,
      'thirdPartySharing': widget.privacySettings.thirdPartySharing,
    };
  }

  void _togglePrivacy(String setting) {
    setState(() {
      _privacySettings[setting] = !_privacySettings[setting]!;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Privacy setting updated!')),
    );
  }

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data export initiated!')),
    );
  }

  void _anonymizeData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data anonymization initiated!')),
    );
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text('Are you sure you want to delete your account? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            GradientButton(
              text: 'Delete',
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Account deletion initiated!')),
                );
              },
              gradient: const LinearGradient(colors: [AppColors.error, AppColors.error]),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final privacyOptions = [
      {
        'key': 'profileVisibility',
        'title': 'Public Profile',
        'description': 'Allow others to view your profile',
      },
      {
        'key': 'activityVisibility',
        'title': 'Activity Visibility',
        'description': 'Show your activity to others',
      },
      {
        'key': 'allowDirectMessages',
        'title': 'Direct Messages',
        'description': 'Allow others to send you messages',
      },
      {
        'key': 'showOnlineStatus',
        'title': 'Online Status',
        'description': 'Show when you are online',
      },
      {
        'key': 'dataSharing',
        'title': 'Data Sharing',
        'description': 'Share data with ATLAS partners',
      },
      {
        'key': 'analyticsTracking',
        'title': 'Analytics Tracking',
        'description': 'Allow analytics and usage tracking',
      },
      {
        'key': 'marketingEmails',
        'title': 'Marketing Emails',
        'description': 'Receive marketing communications',
      },
      {
        'key': 'thirdPartySharing',
        'title': 'Third-party Sharing',
        'description': 'Share data with third parties',
      },
    ];

    return Column(
      children: [
        GlassCard(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('🔒 Privacy Controls', style: AppTextStyles.h4),
                const SizedBox(height: AppSpacing.md),
                ...privacyOptions.map((option) {
                  final key = option['key'] as String;
                  final isEnabled = _privacySettings[key] ?? false;
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: GlassCard(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    option['title'] as String,
                                    style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    option['description'] as String,
                                    style: AppTextStyles.caption,
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: isEnabled,
                              onChanged: (value) => _togglePrivacy(key),
                              activeColor: AppColors.success,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        GlassCard(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('🗂️ Data Management', style: AppTextStyles.h4),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    GradientButton(
                      text: 'Export My Data',
                      onPressed: _exportData,
                      gradient: AppColors.primaryGradient,
                      width: 140,
                    ),
                    GradientButton(
                      text: 'Anonymize Data',
                      onPressed: _anonymizeData,
                      gradient: AppColors.warningGradient,
                      width: 140,
                    ),
                    GradientButton(
                      text: 'Delete Account',
                      onPressed: _deleteAccount,
                      gradient: const LinearGradient(colors: [AppColors.error, AppColors.error]),
                      width: 140,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}