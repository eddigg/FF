import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart'; // For SchedulerBinding
import '../../main.dart';
import '../navigation/navigation_state_manager.dart';
import '../../features/governance/presentation/pages/governance_page.dart';
import '../../features/governance/presentation/pages/proposal_detail_page.dart';
import '../../features/governance/presentation/pages/create_proposal_page.dart';
import '../../features/wallet/presentation/pages/wallet_page.dart';
import '../../features/wallet/presentation/pages/send_page.dart';
import '../../features/wallet/presentation/pages/receive_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/explorer/presentation/pages/explorer_page.dart';
import '../../features/defi/presentation/pages/defi_page.dart';
import '../../features/node_dashboard/presentation/pages/node_dashboard_page.dart';
import '../../features/identity/presentation/pages/identity_page.dart';
import '../../features/social/presentation/pages/social_page.dart';
import '../../features/contracts/presentation/pages/contracts_page.dart';
import '../../features/health/presentation/pages/health_page.dart';
import '../../features/intro/presentation/pages/intro_page.dart';
import '../../features/wallet_setup/presentation/pages/wallet_setup_page.dart';
import '../../features/auth/presentation/screens/auth_screens.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/', // Set splash as the initial location
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/wallet',
      builder: (context, state) => const WalletPage(),
    ),
    GoRoute(
      path: '/wallet/send',
      builder: (context, state) => const SendPage(),
    ),
    GoRoute(
      path: '/wallet/receive',
      builder: (context, state) => const ReceivePage(),
    ),
    GoRoute(
      path: '/explorer',
      builder: (context, state) => const ExplorerPage(),
    ),
    GoRoute(
      path: '/defi',
      builder: (context, state) => const DeFiPage(),
    ),
    GoRoute(
      path: '/node-dashboard',
      builder: (context, state) => const NodeDashboardPage(),
    ),
    GoRoute(
      path: '/governance',
      builder: (context, state) => const GovernancePage(),
    ),
    GoRoute(
      path: '/governance/create',
      builder: (context, state) => const CreateProposalPage(),
    ),
    GoRoute(
      path: '/governance/proposal/:id',
      builder: (context, state) => ProposalDetailPage(proposalId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/identity',
      builder: (context, state) => const IdentityPage(),
    ),
    GoRoute(
      path: '/social',
      builder: (context, state) => const SocialPage(),
    ),
    GoRoute(
      path: '/contracts',
      builder: (context, state) => const ContractsPage(),
    ),
    GoRoute(
      path: '/health',
      builder: (context, state) => const HealthPage(),
    ),
    GoRoute(
      path: '/intro',
      builder: (context, state) => const IntroPage(),
    ),
    GoRoute(
      path: '/wallet-setup',
      builder: (context, state) => const WalletSetupPage(),
    ),
  ],
  // Add navigation listener to track route changes
  redirect: (context, state) {
    // Update navigation state when route changes
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final navManager = Provider.of<NavigationStateManager>(context, listen: false);
      navManager.updateCurrentRoute(state.uri.toString());
    });
    
    return null;
  },
);