import 'dart:io' show HttpOverrides;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Import the app router
import 'core/routing/app_router.dart';

// Import providers and navigation
import 'core/navigation/navigation_state_manager.dart';

// Import all BLoCs
import 'features/wallet_setup/presentation/bloc/wallet_setup_bloc.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'features/wallet/presentation/bloc/wallet_bloc.dart';
import 'features/identity/presentation/bloc/identity_bloc.dart';
import 'features/defi/presentation/bloc/defi_bloc.dart';
import 'features/explorer/presentation/bloc/explorer_bloc.dart';
import 'features/health/presentation/bloc/health_bloc.dart';
import 'features/node_dashboard/presentation/bloc/node_dashboard_bloc.dart';
import 'features/governance/presentation/bloc/governance_bloc.dart';
import 'features/contracts/presentation/bloc/contracts_bloc.dart';
import 'features/social/presentation/bloc/social_bloc.dart';

// Import all repositories
import 'features/wallet_setup/data/repositories/wallet_setup_repository.dart';
import 'features/wallet_setup/data/repositories/wallet_setup_repository_impl.dart';
import 'features/dashboard/data/repositories/dashboard_repository.dart';
import 'features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'features/wallet/data/repositories/wallet_repository.dart';
import 'features/wallet/data/repositories/wallet_repository_impl.dart';
import 'features/identity/data/repositories/identity_repository.dart';
import 'features/identity/data/repositories/identity_repository_impl.dart';
import 'features/defi/data/repositories/defi_repository.dart';
import 'features/defi/data/repositories/defi_repository_impl.dart';
import 'features/explorer/data/repositories/explorer_repository.dart';
import 'features/explorer/data/repositories/explorer_repository_impl.dart';
import 'features/health/data/repositories/health_repository.dart';
import 'features/health/data/repositories/health_repository_impl.dart';
import 'features/node_dashboard/data/repositories/node_dashboard_repository.dart';
import 'features/node_dashboard/data/repositories/node_dashboard_repository_impl.dart';
import 'features/governance/data/repositories/governance_repository.dart';
import 'features/governance/data/repositories/governance_repository_impl.dart';
import 'features/contracts/data/repositories/contracts_repository.dart';
import 'features/contracts/data/repositories/contracts_repository_impl.dart';
import 'features/social/data/repositories/social_repository.dart';
import 'features/social/data/repositories/social_repository_impl.dart';

// Import the separate page files for direct navigation in HomePage
import 'features/explorer/presentation/pages/explorer_page.dart';
import 'features/wallet/presentation/pages/wallet_page.dart';
import 'features/defi/presentation/pages/defi_page.dart';
import 'features/governance/presentation/pages/governance_page.dart';
import 'features/health/presentation/pages/health_page.dart';
import 'features/node_dashboard/presentation/pages/node_dashboard_page.dart';
import 'features/contracts/presentation/pages/contracts_page.dart';
import 'features/social/presentation/pages/social_page.dart';
import 'features/identity/presentation/pages/identity_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  if (kIsWeb) {
    // Handle CORS for web
    HttpOverrides.global = MyHttpOverrides();
  }
  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  createHttpClient(context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Navigation state manager
        ChangeNotifierProvider(create: (_) => NavigationStateManager()),

        // Repositories
        Provider<WalletSetupRepository>(
          create: (_) => WalletSetupRepositoryImpl(),
        ),
        Provider<DashboardRepository>(create: (_) => DashboardRepositoryImpl()),
        Provider<WalletRepository>(create: (_) => WalletRepositoryImpl()),
        Provider<IdentityRepository>(create: (_) => IdentityRepositoryImpl()),
        Provider<DeFiRepository>(create: (_) => DeFiRepositoryImpl()),
        Provider<ExplorerRepository>(create: (_) => ExplorerRepositoryImpl()),
        Provider<HealthRepository>(create: (_) => HealthRepositoryImpl()),
        Provider<NodeDashboardRepository>(
          create: (_) => NodeDashboardRepositoryImpl(),
        ),
        Provider<GovernanceRepository>(
          create: (_) => GovernanceRepositoryImpl(),
        ),
        Provider<ContractsRepository>(create: (_) => ContractsRepositoryImpl()),
        Provider<SocialRepository>(create: (_) => SocialRepositoryImpl()),

        // BLoCs
        BlocProvider(
          create: (context) => WalletSetupBloc(
            walletSetupRepository: context.read<WalletSetupRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => DashboardBloc(
            dashboardRepository: context.read<DashboardRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) =>
              WalletBloc(walletRepository: context.read<WalletRepository>()),
        ),
        BlocProvider(
          create: (context) => IdentityBloc(
            identityRepository: context.read<IdentityRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) =>
              DeFiBloc(defiRepository: context.read<DeFiRepository>()),
        ),
        BlocProvider(
          create: (context) => ExplorerBloc(
            explorerRepository: context.read<ExplorerRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) =>
              HealthBloc(healthRepository: context.read<HealthRepository>()),
        ),
        BlocProvider(
          create: (context) => NodeDashboardBloc(
            nodeDashboardRepository: context.read<NodeDashboardRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => GovernanceBloc(
            governanceRepository: context.read<GovernanceRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => ContractsBloc(
            contractsRepository: context.read<ContractsRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) =>
              SocialBloc(socialRepository: context.read<SocialRepository>()),
        ),
      ],
      child: MaterialApp.router(
        title: 'ATLAS B.C.',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Inter'),
        routerConfig: appRouter,
      ),
    );
  }
}

// Keep HomePage for direct navigation from the main dashboard
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔗 ATLAS B.C.'),
        backgroundColor: const Color(0xFF667EEA),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFf8fafc), Color(0xFFe2e8f0), Color(0xFFcbd5e0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Blockchain Network Dashboard',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                'Real-time monitoring of your decentralized network',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              // Navigation grid similar to the web frontend
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    children: [
                      _buildNavCard(
                        context,
                        '🔍 Explorer',
                        'Browse blocks, transactions, and network activity in real time.',
                        '/explorer',
                        const ExplorerPage(),
                      ),
                      _buildNavCard(
                        context,
                        '💼 Wallet',
                        'Manage your accounts, balances, and send transactions securely.',
                        '/wallet',
                        const WalletPage(),
                      ),
                      _buildNavCard(
                        context,
                        '🌐 Network',
                        'Monitor node status, peers, and validator performance.',
                        '/network',
                        const NodeDashboardPage(),
                      ),
                      _buildNavCard(
                        context,
                        '🏥 Health',
                        'System health monitoring, performance metrics, and testing.',
                        '/health',
                        const HealthPage(),
                      ),
                      _buildNavCard(
                        context,
                        '🛡️ Governance',
                        'On-chain governance, voting, privacy, and sharding management.',
                        '/governance',
                        const GovernancePage(),
                      ),
                      _buildNavCard(
                        context,
                        '⚡ Smart Contracts',
                        'Deploy, interact with, and manage smart contracts on the blockchain.',
                        '/contracts',
                        const ContractsPage(),
                      ),
                      _buildNavCard(
                        context,
                        '📱 Social Platform',
                        'Connect, share, and engage with the ATLAS community.',
                        '/social',
                        const SocialPage(),
                      ),
                      _buildNavCard(
                        context,
                        '💰 DeFi Platform',
                        'Lend, borrow, trade, and earn with DeFi protocols.',
                        '/defi',
                        const DeFiPage(),
                      ),
                      _buildNavCard(
                        context,
                        '👤 Identity Management',
                        'Manage your profile, KYC, privacy, and reputation.',
                        '/identity',
                        const IdentityPage(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavCard(
    BuildContext context,
    String title,
    String description,
    String routePath,
    Widget page,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          // Use GoRouter for navigation
          context.go(routePath);
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Colors.white, Color(0xFFF8FAFC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                description,
                style: const TextStyle(fontSize: 14, color: Color(0xFF4A5568)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  // Use GoRouter for navigation
                  context.go(routePath);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4299E1),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Go'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
