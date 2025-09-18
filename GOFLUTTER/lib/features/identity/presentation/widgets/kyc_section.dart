import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/kyc_status_model.dart';
import '../../data/models/user_profile_model.dart';
import '../../presentation/bloc/identity_bloc.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/common_widgets.dart';

class KycSection extends StatelessWidget {
  final KycStatusModel kycStatus;
  final UserProfileModel userProfile;

  const KycSection({Key? key, required this.kycStatus, required this.userProfile}) : super(key: key);

  void _startKYC(BuildContext context, String kycType) {
    // For now, we'll just show a snackbar. In a real implementation, this would open a form
    // to collect the required KYC information.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Starting $kycType verification...')),
    );
  }

  void _checkKYCStatus(BuildContext context, String address) {
    context.read<IdentityBloc>().add(CheckKYCStatus(address: address));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Checking KYC status...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // For now, we'll use a placeholder address. In a real implementation, 
    // this would come from the user profile or wallet service.
    final userAddress = 'user_address_placeholder'; // Replace with actual user address from userProfile
    
    final kycItems = [
      {
        'key': 'personalInfo',
        'title': 'Personal Information',
        'description': 'Basic personal details verification',
        'status': kycStatus.personalInfoStatus,
        'date': kycStatus.personalInfoDate,
      },
      {
        'key': 'identityDocument',
        'title': 'Identity Document',
        'description': 'Government-issued ID verification',
        'status': kycStatus.identityDocumentStatus,
        'date': kycStatus.identityDocumentDate,
      },
      {
        'key': 'addressProof',
        'title': 'Address Proof',
        'description': 'Residential address verification',
        'status': kycStatus.addressProofStatus,
        'date': kycStatus.addressProofDate,
      },
      {
        'key': 'financialInfo',
        'title': 'Financial Information',
        'description': 'Bank account and financial details',
        'status': kycStatus.financialInfoStatus,
        'date': kycStatus.financialInfoDate,
      },
      {
        'key': 'sourceOfFunds',
        'title': 'Source of Funds',
        'description': 'Income and fund source verification',
        'status': kycStatus.sourceOfFundsStatus,
        'date': kycStatus.sourceOfFundsDate,
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
                const Text('🆔 KYC Verification Status', style: AppTextStyles.h4),
                const SizedBox(height: AppSpacing.md),
                ...kycItems.map((item) {
                  final status = item['status'] as String;
                  final statusIcon = status == 'verified'
                      ? '✅'
                      : status == 'pending'
                          ? '⏳'
                          : '❌';

                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: GlassCard(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: status == 'verified'
                                    ? AppColors.success.withValues(alpha: 0.1)
                                    : status == 'pending'
                                        ? AppColors.warning.withValues(alpha: 0.1)
                                        : AppColors.error.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  statusIcon,
                                  style: TextStyle(
                                    color: status == 'verified'
                                        ? AppColors.success
                                        : status == 'pending'
                                            ? AppColors.warning
                                            : AppColors.error,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title'] as String,
                                    style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    item['description'] as String,
                                    style: AppTextStyles.caption,
                                  ),
                                  if (item['date'] != null)
                                    Text(
                                      'Verified: ${item['date']}',
                                      style: AppTextStyles.caption,
                                    ),
                                ],
                              ),
                            ),
                            if (status == 'unverified')
                              GradientButton(
                                text: 'Start Verification',
                                onPressed: () => _startKYC(context, item['key'] as String),
                                width: 120,
                              )
                            else if (status == 'pending')
                              GradientButton(
                                text: 'Check Status',
                                onPressed: () => _checkKYCStatus(context, userAddress),
                                gradient: AppColors.warningGradient,
                                width: 100,
                              )
                            else
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                                decoration: BoxDecoration(
                                  color: AppColors.success,
                                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                ),
                                child: const Text(
                                  'Verified',
                                  style: TextStyle(color: Colors.white, fontSize: 12),
                                ),
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
        const GlassCard(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('💎 KYC Benefits', style: AppTextStyles.h4),
                SizedBox(height: AppSpacing.md),
                Text(
                  '• Higher transaction limits\n'
                  '• Access to advanced DeFi features\n'
                  '• Enhanced security and fraud protection\n'
                  '• Priority customer support\n'
                  '• Governance voting rights',
                  style: AppTextStyles.body1,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}