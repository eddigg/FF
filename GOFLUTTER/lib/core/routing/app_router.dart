import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/dashboard/presentation/pages/unified_dashboard_page.dart';
import '../../features/intro/presentation/pages/intro_page.dart';
import '../../features/wallet_setup/presentation/pages/wallet_setup_page.dart';
import '../../features/auth/presentation/screens/auth_screens.dart';
import '../../features/wallet/presentation/pages/wallet_page.dart';
import '../../features/wallet/presentation/pages/send_page.dart';
import '../../features/wallet/presentation/pages/receive_page.dart';
import '../../features/defi/presentation/pages/defi_page.dart';
import '../../features/explorer/presentation/pages/explorer_page.dart';
import '../../features/health/presentation/pages/health_page.dart';
import '../../features/node_dashboard/presentation/pages/node_dashboard_page.dart';
import '../../features/governance/presentation/pages/governance_page.dart';
import '../../features/governance/presentation/pages/create_proposal_page.dart';
import '../../features/governance/presentation/pages/proposal_detail_page.dart';
import '../../features/identity/presentation/pages/identity_page.dart';
import '../../features/social/presentation/pages/social_page.dart';
import '../../features/contracts/presentation/pages/contracts_page.dart';
// Network route uses node dashboard

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    print('💫 Splash screen initialized');
    // Check if wallet exists and navigate accordingly
    _checkWalletAndNavigate();
  }

  Future<void> _checkWalletAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    
    final prefs = await SharedPreferences.getInstance();
    final walletExists = prefs.getString('wallet_private_key') != null;
    
    print('💫 Wallet exists: $walletExists');
    
    if (walletExists) {
      print('💫 Splash screen navigating to dashboard');
      context.go('/dashboard');
    } else {
      print('💫 Splash screen navigating to intro');
      context.go('/intro');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.white, Color(0xFFF0F0F0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: const Text(
                  "🔗 ATLAS B.C.",
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/', // Start with splash screen
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const UnifiedDashboardPage(),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    // Restored actual feature pages
    GoRoute(path: '/wallet', builder: (context, state) => const WalletPage()),
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
    GoRoute(path: '/defi', builder: (context, state) => const DeFiPage()),
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
      builder: (context, state) =>
          ProposalDetailPage(proposalId: state.pathParameters['id'] ?? ''),
    ),
    GoRoute(
      path: '/identity',
      builder: (context, state) => const IdentityPage(),
    ),
    GoRoute(path: '/social', builder: (context, state) => const SocialPage()),
    GoRoute(
      path: '/contracts',
      builder: (context, state) => const ContractsPage(),
    ),
    GoRoute(path: '/health', builder: (context, state) => const HealthPage()),
    GoRoute(path: '/intro', builder: (context, state) => const IntroPage()),
    GoRoute(
      path: '/wallet-setup',
      builder: (context, state) => const WalletSetupPage(),
    ),
    // Network route uses node dashboard
    GoRoute(
      path: '/network',
      builder: (context, state) => const NodeDashboardPage(),
    ),
  ],
);