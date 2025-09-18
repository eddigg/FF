import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/common_widgets.dart';
import '../widgets/intro_carousel.dart';
import '../widgets/intro_feature_card.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(context),
                const SizedBox(height: 32), // Use direct values since we can't import AppSpacing
                const IntroCarousel(),
                const SizedBox(height: 32),
                _buildFeaturesGrid(context),
                const SizedBox(height: 32),
                _buildLaunchSection(context),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20), // Use direct value instead of AppSpacing.containerPadding
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (bounds) =>
                const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFFFFF), Color(0xFFF0F0F0)],
                ).createShader(bounds),
            child: const Text(
              '🔗 ATLAS B.C.',
              style: TextStyle(
                fontSize: 56, // 3.5rem
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.02,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16), // Use direct value instead of AppSpacing.md
          Text(
            'Welcome to the Future of Blockchain Technology',
            style: TextStyle(
              fontSize: 20.8, // 1.3rem
              color: Colors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8), // Use direct value instead of AppSpacing.sm
          Text(
            'Decentralized • Secure • Scalable',
            style: TextStyle(
              fontSize: 17.6, // 1.1rem
              color: Colors.white.withValues(alpha: 0.8),
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesGrid(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20), // Use direct value instead of AppSpacing.containerPadding
      child: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 16, // Use direct value instead of AppSpacing.md
        mainAxisSpacing: 16, // Use direct value instead of AppSpacing.md
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          IntroFeatureCard(
            icon: '🔍',
            title: 'Block Explorer',
            description: 'Browse blocks, transactions, and network activity in real-time with our comprehensive explorer.',
            route: '/explorer', // Add route
          ),
          IntroFeatureCard(
            icon: '💼',
            title: 'Wallet Management',
            description: 'Manage your accounts, balances, and send transactions securely with our advanced wallet system.',
            route: '/wallet', // Add route
          ),
          IntroFeatureCard(
            icon: '🌐',
            title: 'Network Monitoring',
            description: 'Monitor node status, peers, and validator performance with detailed analytics and insights.',
            route: '/node-dashboard', // Add route
          ),
        ],
      ),
    );
  }

  Widget _buildLaunchSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20), // Use direct value instead of AppSpacing.containerPadding
      child: Center(
        child: GradientButton(
          text: '🚀 Launch ATLAS B.C. Dashboard',
          onPressed: () {
            context.go('/login'); // Link to login page
          },
          gradient: AppColors.successGradient,
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24), // Use direct values instead of AppSpacing
          textStyle: TextStyle( // Use direct styling instead of AppTextStyles
            color: Colors.white,
            fontSize: 20.8, // 1.3rem
            fontWeight: FontWeight.w600,
          ),
          borderRadius: BorderRadius.circular(50), // 50px border radius
        ),
      ),
    );
  }
}