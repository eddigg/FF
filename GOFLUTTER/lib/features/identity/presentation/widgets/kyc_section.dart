import 'package:flutter/material.dart';
import '../../../../shared/themes/web_parity_theme.dart';
import 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' as glass_card;

class KycSection extends StatelessWidget {
  const KycSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock KYC status data
    final mockKycStatus = {
      'personalInfoStatus': 'verified',
      'personalInfoDate': '2024-01-15',
      'identityDocumentStatus': 'verified',
      'identityDocumentDate': '2024-01-16',
      'addressProofStatus': 'pending',
      'addressProofDate': '',
      'financialInfoStatus': 'unverified',
      'financialInfoDate': '',
      'sourceOfFundsStatus': 'unverified',
      'sourceOfFundsDate': '',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('🆔 KYC Verification', style: WebParityTheme.panelTitleStyle),
        const SizedBox(height: 20),
        Column(
          children: [
            glass_card.GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('KYC Verification Status', style: WebParityTheme.cardTitleStyle),
                  const SizedBox(height: 15),
                  _KycStatusItem(
                    title: 'Personal Information',
                    description: 'Basic personal details verification',
                    status: mockKycStatus['personalInfoStatus'] as String,
                    date: mockKycStatus['personalInfoDate'] as String,
                  ),
                  _KycStatusItem(
                    title: 'Identity Document',
                    description: 'Government-issued ID verification',
                    status: mockKycStatus['identityDocumentStatus'] as String,
                    date: mockKycStatus['identityDocumentDate'] as String,
                  ),
                  _KycStatusItem(
                    title: 'Address Proof',
                    description: 'Residential address verification',
                    status: mockKycStatus['addressProofStatus'] as String,
                    date: mockKycStatus['addressProofDate'] as String,
                  ),
                  _KycStatusItem(
                    title: 'Financial Information',
                    description: 'Bank account and financial details',
                    status: mockKycStatus['financialInfoStatus'] as String,
                    date: mockKycStatus['financialInfoDate'] as String,
                  ),
                  _KycStatusItem(
                    title: 'Source of Funds',
                    description: 'Income and fund source verification',
                    status: mockKycStatus['sourceOfFundsStatus'] as String,
                    date: mockKycStatus['sourceOfFundsDate'] as String,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            glass_card.GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('KYC Benefits', style: WebParityTheme.cardTitleStyle),
                  const SizedBox(height: 15),
                  _buildBenefitItem('Higher transaction limits'),
                  _buildBenefitItem('Access to advanced DeFi features'),
                  _buildBenefitItem('Enhanced security and fraud protection'),
                  _buildBenefitItem('Priority customer support'),
                  _buildBenefitItem('Governance voting rights'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: Color(0xFF48BB78), size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16, color: Color(0xFF4A5568)))),
        ],
      ),
    );
  }
}

class _KycStatusItem extends StatelessWidget {
  final String title;
  final String description;
  final String status;
  final String? date;

  const _KycStatusItem({required this.title, required this.description, required this.status, this.date});

  @override
  Widget build(BuildContext context) {
    Color iconColor;
    String iconText;
    Color statusButtonColor;
    String statusButtonText;
    VoidCallback? onButtonPressed;

    switch (status.toLowerCase()) {
      case 'verified':
        iconColor = const Color(0xFF48BB78);
        iconText = '✅';
        statusButtonColor = const Color(0xFF48BB78);
        statusButtonText = 'Verified';
        onButtonPressed = null;
        break;
      case 'pending':
        iconColor = const Color(0xFFED8936);
        iconText = '⏳';
        statusButtonColor = const Color(0xFFED8936);
        statusButtonText = 'Check Status';
        onButtonPressed = () {
          // For stub implementation, we just show a snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Checking KYC status...')),
          );
        };
        break;
      case 'unverified':
      default:
        iconColor = const Color(0xFFF56565);
        iconText = '❌';
        statusButtonColor = const Color(0xFF718096);
        statusButtonText = 'Start Verification';
        onButtonPressed = () {
          // For stub implementation, we just show a snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Starting verification process...')),
          );
        };
        break;
    }

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
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(child: Text(iconText, style: const TextStyle(fontSize: 20))),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF2D3748))),
                Text(description, style: const TextStyle(fontSize: 14, color: Color(0xFF718096))),
                if (date != null && date!.isNotEmpty) Text('Verified: $date', style: const TextStyle(fontSize: 14, color: Color(0xFF718096))),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onButtonPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: statusButtonColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(statusButtonText, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}