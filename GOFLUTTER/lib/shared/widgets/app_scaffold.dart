import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../themes/app_colors.dart';
import '../themes/web_gradients.dart';
import 'glass_card.dart' as glass_card; // Import GlassCard with prefix
import 'common_widgets.dart'; // Import common widgets for GradientButton

class AppScaffold extends StatelessWidget {
  final Widget child;
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final bool showNavigationCards; // New parameter to control navigation card visibility

  const AppScaffold({
    Key? key,
    required this.child,
    this.title = 'ATLAS B.C.',
    this.showBackButton = true,
    this.actions,
    this.bottom,
    this.showNavigationCards = true, // Default to showing navigation cards
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.go('/dashboard'),
              )
            : null,
        actions: actions,
        bottom: bottom,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: WebGradients.backgroundMain, // Use web parity background gradient
        ),
        child: Column(
          children: [
            Expanded(child: child),
            if (showNavigationCards) ...[
              const SizedBox(height: AppSpacing.md),
              _buildNavigationCards(context),
              const SizedBox(height: AppSpacing.md),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationCards(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.containerPadding),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Determine the number of columns based on screen width
          int crossAxisCount = 4;
          if (constraints.maxWidth < 600) {
            crossAxisCount = 2;
          } else if (constraints.maxWidth < 1000) {
            crossAxisCount = 3;
          }
          
          return GridView.count(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildNavigationCard(
                context: context,
                icon: '🔍',
                title: 'Explorer',
                description: 'Browse blocks, transactions, and network activity in real time.',
                route: '/explorer',
              ),
              _buildNavigationCard(
                context: context,
                icon: '💼',
                title: 'Wallet',
                description: 'Manage your accounts, balances, and send transactions securely.',
                route: '/wallet',
                isSuccess: true,
              ),
              _buildNavigationCard(
                context: context,
                icon: '🌐',
                title: 'Network',
                description: 'Monitor node status, peers, and validator performance.',
                route: '/node-dashboard',
                isWarning: true,
              ),
              _buildNavigationCard(
                context: context,
                icon: '🏥',
                title: 'Health',
                description: 'System health monitoring, performance metrics, and testing.',
                route: '/health',
              ),
              _buildNavigationCard(
                context: context,
                icon: '🛡️',
                title: 'Governance',
                description: 'On-chain governance, voting, privacy, and sharding management.',
                route: '/governance',
              ),
              _buildNavigationCard(
                context: context,
                icon: '⚡',
                title: 'Smart Contracts',
                description: 'Deploy, interact with, and manage smart contracts on the blockchain.',
                route: '/contracts',
              ),
              _buildNavigationCard(
                context: context,
                icon: '📱',
                title: 'Social Platform',
                description: 'Connect, share, and engage with the ATLAS community.',
                route: '/social',
              ),
              _buildNavigationCard(
                context: context,
                icon: '💰',
                title: 'DeFi Platform',
                description: 'Lend, borrow, trade, and earn with DeFi protocols.',
                route: '/defi',
              ),
              _buildNavigationCard(
                context: context,
                icon: '👤',
                title: 'Identity Management',
                description: 'Manage your profile, KYC, privacy, and reputation.',
                route: '/identity',
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNavigationCard({
    required BuildContext context,
    required String icon,
    required String title,
    required String description,
    required String route,
    bool isSuccess = false,
    bool isWarning = false,
  }) {
    return glass_card.GlassCard(
      height: 240, // Match web height
      showHoverOverlay: true, // Enable hover overlay effect
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              icon,
              style: const TextStyle(fontSize: 24),
            ),
            Text(
              title,
              style: AppTextStyles.h4.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              description,
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            GradientButton(
              text: 'Go to $title',
              onPressed: () => context.go(route),
              gradient: isSuccess
                  ? AppColors.successGradient
                  : isWarning
                      ? AppColors.warningGradient
                      : AppColors.primaryGradient,
              width: double.infinity,
              size: ButtonSize.small, // Use smaller buttons to match web
            ),
          ],
        ),
      ),
    );
  }
}