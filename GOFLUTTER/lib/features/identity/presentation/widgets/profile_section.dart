import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/identity_bloc.dart';
import '../../data/models/user_profile_model.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/common_widgets.dart';

class ProfileSection extends StatefulWidget {
  final UserProfileModel userProfile;

  const ProfileSection({Key? key, required this.userProfile}) : super(key: key);

  @override
  State<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  late TextEditingController _usernameController;
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _locationController;
  late TextEditingController _websiteController;
  late TextEditingController _bioController;
  late TextEditingController _twitterController;
  late TextEditingController _githubController;
  late TextEditingController _linkedinController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.userProfile.username);
    _fullNameController = TextEditingController(text: widget.userProfile.fullName);
    _emailController = TextEditingController(text: widget.userProfile.email);
    _locationController = TextEditingController(text: widget.userProfile.location);
    _websiteController = TextEditingController(text: widget.userProfile.website);
    _bioController = TextEditingController(text: widget.userProfile.bio);
    _twitterController = TextEditingController(text: widget.userProfile.socialLinks['twitter'] as String? ?? '');
    _githubController = TextEditingController(text: widget.userProfile.socialLinks['github'] as String? ?? '');
    _linkedinController = TextEditingController(text: widget.userProfile.socialLinks['linkedin'] as String? ?? '');
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    _websiteController.dispose();
    _bioController.dispose();
    _twitterController.dispose();
    _githubController.dispose();
    _linkedinController.dispose();
    super.dispose();
  }

  void _updateProfile() {
    final updatedProfile = UserProfileModel(
      username: _usernameController.text,
      fullName: _fullNameController.text,
      email: _emailController.text,
      location: _locationController.text,
      website: _websiteController.text,
      bio: _bioController.text,
      socialLinks: widget.userProfile.socialLinks,
      status: widget.userProfile.status,
      verificationLevel: widget.userProfile.verificationLevel,
    );
    
    context.read<IdentityBloc>().add(UpdateUserProfile(profile: updatedProfile));
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );
  }

  void _updateSocialLinks() {
    final socialLinks = <String, String>{
      'twitter': _twitterController.text,
      'github': _githubController.text,
      'linkedin': _linkedinController.text,
    };
    
    context.read<IdentityBloc>().add(UpdateSocialLinks(socialLinks: socialLinks));
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Social links updated successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GlassCard(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('👤 Basic Information', style: AppTextStyles.h4),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextFormField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextFormField(
                  controller: _websiteController,
                  decoration: const InputDecoration(
                    labelText: 'Website',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextFormField(
                  controller: _bioController,
                  decoration: const InputDecoration(
                    labelText: 'Bio',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: AppSpacing.md),
                GradientButton(
                  text: 'Update Profile',
                  onPressed: _updateProfile,
                  gradient: AppColors.successGradient,
                ),
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
                const Text('🌐 Social Links', style: AppTextStyles.h4),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _twitterController,
                  decoration: const InputDecoration(
                    labelText: 'Twitter',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextFormField(
                  controller: _githubController,
                  decoration: const InputDecoration(
                    labelText: 'GitHub',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextFormField(
                  controller: _linkedinController,
                  decoration: const InputDecoration(
                    labelText: 'LinkedIn',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                GradientButton(
                  text: 'Update Social Links',
                  onPressed: _updateSocialLinks,
                  gradient: AppColors.successGradient,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}