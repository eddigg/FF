import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/navigation/navigation_state_manager.dart';
import '../themes/web_colors.dart';
import '../themes/web_typography.dart';
import '../themes/web_gradients.dart';
import '../widgets/glass_card.dart';

/// Navigation history widget for displaying and navigating through recent routes
/// Matches the web implementation patterns for navigation history
class NavigationHistory extends StatelessWidget {
  final bool showFullHistory;
  
  const NavigationHistory({
    Key? key,
    this.showFullHistory = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationStateManager>(
      builder: (context, navManager, child) {
        final history = navManager.navigationHistory;
        
        // If no history or only current route, don't show anything
        if (history.isEmpty || (history.length == 1 && !showFullHistory)) {
          return const SizedBox.shrink();
        }
        
        // Determine how many items to show
        final itemsToShow = showFullHistory 
            ? history 
            : history.length > 1 
                ? history.sublist(history.length - 2) // Show last 2 items
                : history;
        
        return GlassCard(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Navigation History',
                  style: WebTypography.h4.copyWith(
                    color: WebColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                ...itemsToShow.map((route) => _buildHistoryItem(context, route, navManager)).toList(),
              ],
            ),
          ),
        );
      },
    );
  }
  
  /// Build a history item
  Widget _buildHistoryItem(BuildContext context, String route, NavigationStateManager navManager) {
    final isCurrent = navManager.isCurrentRoute(route);
    final routeName = _getRouteName(route);
    
    return InkWell(
      onTap: () {
        if (!isCurrent) {
          context.go(route);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          gradient: isCurrent ? WebGradients.buttonPrimary : null,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Icon(
              isCurrent ? Icons.arrow_forward : Icons.history,
              size: 16,
              color: isCurrent ? Colors.white : WebColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                routeName,
                style: WebTypography.body1.copyWith(
                  color: isCurrent ? Colors.white : WebColors.textPrimary,
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isCurrent)
              Icon(
                Icons.check_circle,
                size: 16,
                color: Colors.white,
              ),
          ],
        ),
      ),
    );
  }
  
  /// Get a human-readable name for a route
  String _getRouteName(String route) {
    switch (route) {
      case '/':
        return 'Home';
      case '/dashboard':
        return 'Dashboard';
      case '/wallet':
        return 'Wallet';
      case '/wallet/send':
        return 'Send';
      case '/wallet/receive':
        return 'Receive';
      case '/explorer':
        return 'Explorer';
      case '/defi':
        return 'DeFi';
      case '/node-dashboard':
        return 'Node Dashboard';
      case '/governance':
        return 'Governance';
      case '/governance/create':
        return 'Create Proposal';
      case '/identity':
        return 'Identity';
      case '/social':
        return 'Social';
      case '/contracts':
        return 'Contracts';
      case '/health':
        return 'Health';
      case '/intro':
        return 'Intro';
      case '/wallet-setup':
        return 'Wallet Setup';
      case '/login':
        return 'Login';
      case '/register':
        return 'Register';
      default:
        // Try to extract a meaningful name from the route
        final parts = route.split('/');
        if (parts.length > 1) {
          return parts.sublist(1).join(' > ');
        }
        return route;
    }
  }
}