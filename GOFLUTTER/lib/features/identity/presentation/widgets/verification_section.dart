import 'package:flutter/material.dart';
import '../../../../shared/widgets/common_widgets.dart' as glass_card;

class VerificationSection extends StatelessWidget {
  const VerificationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('✅ Identity Verification', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        glass_card.GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Identity Verification Methods', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              const _VerificationItem(icon: '📧', title: 'Email Verification', description: 'Status: Verified', status: 'verified'),
              const _VerificationItem(icon: '📱', title: 'Phone Verification', description: 'Status: Pending', status: 'pending'),
              const _VerificationItem(icon: '🔐', title: 'Two-Factor Authentication', description: 'Status: Unverified', status: 'unverified'),
              const _VerificationItem(icon: '🌐', title: 'Social Media Verification', description: 'Status: Verified', status: 'verified'),
              const _VerificationItem(icon: '💼', title: 'Professional Verification', description: 'Status: Pending', status: 'pending'),
              const _VerificationItem(icon: '👥', title: 'Community Verification', description: 'Status: Unverified', status: 'unverified'),
            ],
          ),
        ),
      ],
    );
  }
}

class _VerificationItem extends StatelessWidget {
  final String icon;
  final String title;
  final String description;
  final String status;

  const _VerificationItem({required this.icon, required this.title, required this.description, required this.status});

  @override
  Widget build(BuildContext context) {
    Color iconBgColor;
    Color iconColor;
    String buttonText;
    VoidCallback? onPressed;
    Color buttonColor;

    switch (status.toLowerCase()) {
      case 'verified':
      case 'active':
        iconBgColor = const Color(0xFF48BB78).withOpacity(0.1);
        iconColor = const Color(0xFF48BB78);
        buttonText = 'Verified';
        onPressed = null;
        buttonColor = const Color(0xFF48BB78);
        break;
      case 'pending':
        iconBgColor = const Color(0xFFED8936).withOpacity(0.1);
        iconColor = const Color(0xFFED8936);
        buttonText = 'Check';
        onPressed = () {
          // For stub implementation, we just show a snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Checking verification status...')),
          );
        };
        buttonColor = const Color(0xFFED8936);
        break;
      case 'unverified':
      default:
        iconBgColor = const Color(0xFFF56565).withOpacity(0.1);
        iconColor = const Color(0xFFF56565);
        buttonText = 'Verify';
        onPressed = () {
          // For stub implementation, we just show a snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Starting verification process...')),
          );
        };
        buttonColor = const Color(0xFF718096);
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
            decoration: BoxDecoration(color: iconBgColor, borderRadius: BorderRadius.circular(20)),
            child: Center(child: Text(icon, style: TextStyle(fontSize: 20, color: iconColor))),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF2D3748))),
                Text(description, style: const TextStyle(fontSize: 14, color: Color(0xFF718096))),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(buttonText, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}