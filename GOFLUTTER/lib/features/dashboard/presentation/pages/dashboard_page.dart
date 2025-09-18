import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../bloc/dashboard_bloc.dart';
import '../widgets/network_architecture_card.dart';
import '../widgets/node_metrics_card.dart';
import '../widgets/node_selector.dart';
import '../../../../shared/widgets/web_scaffold.dart'; // Use WebScaffold instead of AppScaffold
import '../../../../shared/widgets/glass_card.dart' as glass_card; // Import GlassCard with prefix
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../shared/themes/web_parity_theme.dart';
import '../../../../shared/themes/web_colors.dart';
import '../../../../shared/themes/web_typography.dart';
import '../../../../shared/themes/web_gradients.dart';
import '../../../../shared/themes/web_shadows.dart';
import '../../../../shared/widgets/web_background_painter.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Start periodic updates when the page is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardBloc>().add(StartPeriodicUpdates());
    });

    return WebScaffold(
      title: 'Dashboard',
      showBackButton: false,
      actions: [
        // Logout button in the app bar actions (top right)
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: WebGradients.logoutButton,
            borderRadius: BorderRadius.circular(WebParityTheme.radiusLg),
            boxShadow: WebShadows.logoutButton,
          ),
          child: TextButton(
            onPressed: () {
              // Stop periodic updates
              context.read<DashboardBloc>().add(StopPeriodicUpdates());
              
              // Call the proper logout method in the auth provider
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              authProvider.logout().then((_) {
                // Navigate to intro page after logout
                context.go('/intro');
              }).catchError((error) {
                // Handle logout error
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logout failed: $error')),
                );
                // Still navigate to intro page even if logout fails
                context.go('/intro');
              });
            },
            child: Text(
              '🚪 Logout',
              style: WebTypography.button.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
      child: SafeArea(
        child: Stack(
          children: [
            // Background radial gradients matching web CSS
            CustomPaint(
              size: MediaQuery.of(context).size,
              painter: WebBackgroundPainter(),
            ),
            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(WebParityTheme.containerPadding),
                child: Column(
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: WebParityTheme.spacingXl),
                    const NodeSelector(),
                    const SizedBox(height: WebParityTheme.spacingXl),
                    _buildDashboardContent(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => WebGradients.headerTitle.createShader(bounds),
          child: Text(
            '🔗 ATLAS B.C.',
            style: WebTypography.h1.copyWith(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: WebParityTheme.spacingMd),
        Text(
          'Real-time monitoring of your decentralized network',
          style: WebTypography.subtitle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDashboardContent(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine the number of columns based on screen width using web parity theme
        int crossAxisCount = WebParityTheme.getGridColumns(constraints.maxWidth);
        double spacing = WebParityTheme.getResponsiveSpacing(constraints.maxWidth);
        
        return Column(
          children: [
            // Dashboard-specific navigation grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
              children: [
                _buildNavigationCard(
                  context: context,
                  icon: Icons.search,
                  title: 'Explorer',
                  description: 'Browse blocks, transactions, and network activity in real time.',
                  route: '/explorer',
                ),
                _buildNavigationCard(
                  context: context,
                  icon: Icons.account_balance_wallet,
                  title: 'Wallet',
                  description: 'Manage your accounts, balances, and send transactions securely.',
                  route: '/wallet',
                  gradient: WebGradients.buttonSuccess,
                ),
                _buildNavigationCard(
                  context: context,
                  icon: Icons.network_check,
                  title: 'Network',
                  description: 'Monitor node status, peers, and validator performance.',
                  route: '/node-dashboard',
                  gradient: WebGradients.buttonWarning,
                ),
                _buildNavigationCard(
                  context: context,
                  icon: Icons.local_hospital,
                  title: 'Health',
                  description: 'System health monitoring, performance metrics, and testing.',
                  route: '/health',
                ),
                _buildNavigationCard(
                  context: context,
                  icon: Icons.security,
                  title: 'Governance',
                  description: 'On-chain governance, voting, privacy, and sharding management.',
                  route: '/governance',
                ),
                _buildNavigationCard(
                  context: context,
                  icon: Icons.code,
                  title: 'Smart Contracts',
                  description: 'Deploy, interact with, and manage smart contracts on the blockchain.',
                  route: '/contracts',
                ),
                _buildNavigationCard(
                  context: context,
                  icon: Icons.phone_android,
                  title: 'Social Platform',
                  description: 'Connect, share, and engage with the ATLAS community.',
                  route: '/social',
                ),
                _buildNavigationCard(
                  context: context,
                  icon: Icons.attach_money,
                  title: 'DeFi Platform',
                  description: 'Lend, borrow, trade, and earn with DeFi protocols.',
                  route: '/defi',
                ),
                _buildNavigationCard(
                  context: context,
                  icon: Icons.person,
                  title: 'Identity Management',
                  description: 'Manage your profile, KYC, privacy, and reputation.',
                  route: '/identity',
                ),
              ],
            ),
            const SizedBox(height: WebParityTheme.spacingXl),
            const NodeMetricsCard(),
            const SizedBox(height: WebParityTheme.spacingXl),
            const NetworkArchitectureCard(),
            const SizedBox(height: WebParityTheme.spacingLg),
            _buildRefreshButton(context),
          ],
        );
      },
    );
  }

  Widget _buildNavigationCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required String route,
    LinearGradient? gradient,
  }) {
    return glass_card.GlassCard(
      height: WebParityTheme.navCardHeight, // Match web height
      showHoverOverlay: true, // Enable hover overlay effect
      onTap: () {
        context.go(route);
      },
      child: Padding(
        padding: const EdgeInsets.all(WebParityTheme.navCardPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(WebParityTheme.spacingSm),
              decoration: BoxDecoration(
                gradient: gradient ?? WebGradients.buttonPrimary,
                borderRadius: BorderRadius.circular(WebParityTheme.radiusSm),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            Text(
              title,
              style: WebTypography.navCardTitle,
              textAlign: TextAlign.center,
            ),
            Text(
              description,
              style: WebTypography.navCardDescription,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            // Removed WebButton, now the whole card is tappable
            Text(
              'Go to $title',
              style: WebTypography.button.copyWith(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRefreshButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: WebShadows.refreshButton,
        ),
        child: FloatingActionButton(
          onPressed: () {
            context.read<DashboardBloc>().add(RefreshDashboardData());
          },
          backgroundColor: WebColors.primary,
          child: const Icon(Icons.refresh, color: Colors.white),
        ),
      ),
    );
  }
}