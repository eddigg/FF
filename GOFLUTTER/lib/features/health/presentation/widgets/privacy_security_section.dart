import 'package:flutter/material.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/common_widgets.dart';

class PrivacySecuritySection extends StatelessWidget {
  const PrivacySecuritySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Privacy & Security', style: AppTextStyles.h4),
            const SizedBox(height: AppSpacing.md),
            _buildPrivacyGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyGrid() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildPrivacyCard(
                '🔐 Data Encryption',
                [
                  _buildTextField('Data to Encrypt', maxLines: 3),
                  const SizedBox(height: AppSpacing.sm),
                  _buildTextField('Password (optional)', isPassword: true),
                  const SizedBox(height: AppSpacing.sm),
                  GradientButton(text: 'Encrypt', onPressed: () {}),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildPrivacyCard(
                '🔓 Data Decryption',
                [
                  _buildTextField('Encrypted Data', maxLines: 3),
                  const SizedBox(height: AppSpacing.sm),
                  _buildTextField('Password', isPassword: true),
                  const SizedBox(height: AppSpacing.sm),
                  GradientButton(text: 'Decrypt', onPressed: () {}),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildPrivacyCard(
                '🔍 Zero-Knowledge Proofs',
                [
                  _buildTextField('Data for Proof', maxLines: 3),
                  const SizedBox(height: AppSpacing.sm),
                  GradientButton(text: 'Create Proof', onPressed: () {}),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildPrivacyCard(
                '✅ Proof Verification',
                [
                  _buildTextField('Proof to Verify', maxLines: 3),
                  const SizedBox(height: AppSpacing.sm),
                  GradientButton(text: 'Verify Proof', onPressed: () {}),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _buildPrivacyCard(
          '🗑️ GDPR Compliance',
          [
            _buildTextField('User Address'),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                GradientButton(text: 'Delete Data', onPressed: () {}),
                const SizedBox(width: AppSpacing.sm),
                GradientButton(
                  text: 'Anonymize Data',
                  onPressed: () {},
                  gradient: AppColors.secondaryGradient,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPrivacyCard(String title, List<Widget> children) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.h5.copyWith(color: AppColors.primary)),
            const SizedBox(height: AppSpacing.sm),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, {int maxLines = 1, bool isPassword = false}) {
    return TextField(
      maxLines: maxLines,
      obscureText: isPassword,
      style: AppTextStyles.body1,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(color: AppColors.border, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(color: AppColors.border, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      ),
    );
  }
}