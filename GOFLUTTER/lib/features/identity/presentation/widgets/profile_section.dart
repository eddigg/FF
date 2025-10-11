import 'package:flutter/material.dart';
import '../../../../shared/themes/web_parity_theme.dart';

// Temporary workaround for widget import issues
class GlassCard extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsets? margin;
  final EdgeInsets? padding;

  const GlassCard({Key? key, this.child, this.width, this.height, this.margin, this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      child: child,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
    );
  }
}

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock user profile data
    final mockUserProfile = {
      'username': 'alice_blockchain',
      'fullName': 'Alice Johnson',
      'email': 'alice@example.com',
      'location': 'San Francisco, CA',
      'website': 'https://alice.blockchain',
      'bio': 'Blockchain developer and enthusiast. Working on decentralized identity solutions.',
      'socialLinks': {
        'twitter': '@alice_blockchain',
        'github': 'alice-blockchain',
        'linkedin': 'alice-johnson-blockchain',
      } as Map<String, String>,
    } as Map<String, dynamic>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('👤 Profile Information', style: WebParityTheme.panelTitleStyle),
        const SizedBox(height: 20),
        Column(
          children: [
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Basic Information', style: WebParityTheme.cardTitleStyle),
                  const SizedBox(height: 15),
                  _buildTextField(label: 'Username', initialValue: mockUserProfile['username'] as String),
                  _buildTextField(label: 'Full Name', initialValue: mockUserProfile['fullName'] as String),
                  _buildTextField(label: 'Email', initialValue: mockUserProfile['email'] as String, keyboardType: TextInputType.emailAddress),
                  _buildTextField(label: 'Location', initialValue: mockUserProfile['location'] as String),
                  _buildTextField(label: 'Website', initialValue: mockUserProfile['website'] as String, keyboardType: TextInputType.url),
                  _buildTextField(label: 'Bio', initialValue: mockUserProfile['bio'] as String, maxLines: 3),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // For stub implementation, we just show a snackbar
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Profile updated successfully!')),
                        );
                      },
                      style: WebParityTheme.primaryButtonStyle,
                      child: const Text('Update Profile'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Social Links', style: WebParityTheme.cardTitleStyle),
                  const SizedBox(height: 15),
                  _buildTextField(label: 'Twitter', initialValue: (mockUserProfile['socialLinks'] as Map<String, String>)['twitter']!),
                  _buildTextField(label: 'GitHub', initialValue: (mockUserProfile['socialLinks'] as Map<String, String>)['github']!),
                  _buildTextField(label: 'LinkedIn', initialValue: (mockUserProfile['socialLinks'] as Map<String, String>)['linkedin']!),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // For stub implementation, we just show a snackbar
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Social links updated successfully!')),
                        );
                      },
                      style: WebParityTheme.primaryButtonStyle,
                      child: const Text('Update Social Links'),
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

  Widget _buildTextField({required String label, String? initialValue, int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF4A5568))),
          const SizedBox(height: 5),
          TextFormField(
            initialValue: initialValue,
            maxLines: maxLines,
            keyboardType: keyboardType,
            decoration: WebParityTheme.inputDecoration(''),
          ),
        ],
      ),
    );
  }
}