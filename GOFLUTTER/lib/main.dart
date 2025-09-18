import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/routing/app_router.dart';
import 'core/navigation/navigation_state_manager.dart'; // Add this import
import 'features/auth/services/auth_service.dart';
import 'core/network/api_client.dart' as core_api_client;
import 'features/auth/services/api_client_implementation.dart';
import 'features/auth/services/secure_storage_implementation.dart';
import 'features/governance/data/repositories/governance_repository.dart';
import 'features/governance/data/repositories/governance_repository_impl.dart';
import 'features/governance/data/data_sources/governance_api_client.dart';
import 'features/identity/data/repositories/identity_repository.dart';
import 'features/identity/data/repositories/identity_repository_impl.dart';
import 'features/identity/data/data_sources/identity_api_client.dart';
import 'features/social/data/repositories/social_repository.dart';
import 'features/social/data/repositories/social_repository_impl.dart';
import 'features/social/data/data_sources/social_api_client.dart';
import 'features/contracts/data/repositories/contracts_repository.dart';
import 'features/contracts/data/repositories/contracts_repository_impl.dart';
import 'features/contracts/data/data_sources/contracts_api_client.dart';
import 'features/health/data/repositories/health_repository.dart';
import 'features/health/data/repositories/health_repository_impl.dart';
import 'features/health/data/data_sources/health_api_client.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'features/dashboard/data/repositories/dashboard_repository.dart';
import 'features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'features/dashboard/data/data_sources/dashboard_api_client.dart';
import 'features/explorer/presentation/bloc/explorer_bloc.dart';
import 'features/explorer/data/repositories/explorer_repository.dart';
import 'features/explorer/data/repositories/explorer_repository_impl.dart';
import 'features/explorer/data/data_sources/explorer_api_client.dart';
import 'features/wallet/presentation/bloc/wallet_bloc.dart';
import 'features/wallet/data/repositories/wallet_repository.dart';
import 'features/wallet/data/repositories/wallet_repository_impl.dart';
import 'features/wallet/data/data_sources/wallet_api_client.dart';
import 'features/wallet/services/wallet_service.dart';
import 'features/node_dashboard/presentation/bloc/node_dashboard_bloc.dart';
import 'features/node_dashboard/data/repositories/node_dashboard_repository.dart';
import 'features/node_dashboard/data/repositories/node_dashboard_repository_impl.dart';
import 'features/node_dashboard/data/data_sources/node_dashboard_api_client.dart';
import 'features/governance/presentation/bloc/governance_bloc.dart';
import 'features/identity/presentation/bloc/identity_bloc.dart';
import 'features/defi/presentation/bloc/defi_bloc.dart';
import 'features/social/presentation/bloc/social_bloc.dart';
import 'features/wallet_setup/presentation/bloc/wallet_setup_bloc.dart';
import 'features/wallet_setup/data/repositories/wallet_setup_repository.dart';
import 'features/wallet_setup/data/repositories/wallet_setup_repository_impl.dart';
import 'features/defi/data/repositories/defi_repository.dart';
import 'features/defi/data/repositories/defi_repository_impl.dart';
import 'features/defi/data/data_sources/defi_api_client.dart';
// Import the AuthProvider
import 'features/auth/presentation/providers/auth_provider.dart';
import 'core/storage/secure_storage.dart' as core_secure_storage;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load saved port from shared preferences
  final prefs = await SharedPreferences.getInstance();
  final savedPort = prefs.getInt('selectedNodePort') ?? 8080;
  final baseUrl = 'http://localhost:$savedPort';
  
  core_api_client.ApiClient.initialize(baseUrl: baseUrl);
  final apiClientCore = core_api_client.ApiClient();

  // Initialize services
  final secureStorage = SecureStorage();
  final coreSecureStorage = core_secure_storage.SecureStorage();
  final authApiClient = ApiClient(); // Create an instance of ApiClient for auth
  final authService = AuthService(authApiClient, secureStorage);
  final governanceApiClient = GovernanceApiClient(apiClientCore);
  final governanceRepository =
      GovernanceRepositoryImpl(apiClient: governanceApiClient);
  final identityApiClient = IdentityApiClient(apiClientCore);
  final identityRepository =
      IdentityRepositoryImpl(apiClient: identityApiClient);
  final socialApiClient = SocialApiClient(apiClientCore);
  final socialRepository = SocialRepositoryImpl(apiClient: socialApiClient);
  final contractsApiClient = ContractsApiClient(apiClientCore);
  final contractsRepository =
      ContractsRepositoryImpl(apiClient: contractsApiClient);
  final healthApiClient = HealthApiClient(apiClientCore);
  final healthRepository = HealthRepositoryImpl(apiClient: healthApiClient);
  final dashboardApiClient = DashboardApiClient(apiClientCore);
  final dashboardRepository =
      DashboardRepositoryImpl(apiClient: dashboardApiClient);
  final explorerApiClient = ExplorerApiClient(apiClientCore);
  final explorerRepository =
      ExplorerRepositoryImpl(apiClient: explorerApiClient);
  final walletApiClient = WalletApiClient(apiClientCore);
  final walletRepository = WalletRepositoryImpl(apiClient: walletApiClient);
  final walletService = WalletService(apiClientCore, coreSecureStorage);
  final nodeDashboardApiClient = NodeDashboardApiClient(apiClientCore);
  final nodeDashboardRepository =
      NodeDashboardRepositoryImpl(apiClient: nodeDashboardApiClient);
  final defiApiClient = DeFiApiClient(apiClientCore);
  final defiRepository = DeFiRepositoryImpl(apiClient: defiApiClient);
  final walletSetupRepository = WalletSetupRepositoryImpl();

  runApp(MyApp(
    authService: authService,
    governanceRepository: governanceRepository,
    identityRepository: identityRepository,
    socialRepository: socialRepository,
    contractRepository: contractsRepository,
    healthRepository: healthRepository,
    dashboardRepository: dashboardRepository,
    explorerRepository: explorerRepository,
    walletRepository: walletRepository,
    walletService: walletService,
    nodeDashboardRepository: nodeDashboardRepository,
    defiRepository: defiRepository,
    walletSetupRepository: walletSetupRepository,
    apiClient: apiClientCore,
  ));
}

class MyApp extends StatelessWidget {
  final AuthService authService;
  final GovernanceRepository governanceRepository;
  final IdentityRepository identityRepository;
  final SocialRepository socialRepository;
  final ContractsRepository contractRepository;
  final HealthRepository healthRepository;
  final DashboardRepository dashboardRepository;
  final ExplorerRepository explorerRepository;
  final WalletRepository walletRepository;
  final WalletService walletService;
  final NodeDashboardRepository nodeDashboardRepository;
  final DeFiRepository defiRepository;
  final WalletSetupRepository walletSetupRepository;
  final core_api_client.ApiClient apiClient;

  const MyApp({
    super.key,
    required this.authService,
    required this.governanceRepository,
    required this.identityRepository,
    required this.socialRepository,
    required this.contractRepository,
    required this.healthRepository,
    required this.dashboardRepository,
    required this.explorerRepository,
    required this.walletRepository,
    required this.walletService,
    required this.nodeDashboardRepository,
    required this.defiRepository,
    required this.walletSetupRepository,
    required this.apiClient,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(authService),
        ),
        ChangeNotifierProvider(
          create: (context) => NavigationStateManager(), // Add NavigationStateManager provider
        ),
        Provider<GovernanceRepository>(
          create: (context) => governanceRepository,
        ),
        Provider<IdentityRepository>(
          create: (context) => identityRepository,
        ),
        Provider<SocialRepository>(
          create: (context) => socialRepository,
        ),
        Provider<ContractsRepository>(
          create: (context) => contractRepository,
        ),
        Provider<HealthRepository>(
          create: (context) => healthRepository,
        ),
        BlocProvider<DashboardBloc>(
          create: (context) => DashboardBloc(
              dashboardRepository: dashboardRepository, apiClient: apiClient)
            ..add(LoadDashboardData()),
        ),
        BlocProvider<ExplorerBloc>(
          create: (context) =>
              ExplorerBloc(explorerRepository: explorerRepository)
                ..add(LoadRecentBlocks()),
        ),
        BlocProvider<WalletBloc>(
          create: (context) =>
              WalletBloc(walletRepository: walletRepository, walletService: walletService)
                ..add(LoadWallet()),
        ),
        BlocProvider<NodeDashboardBloc>(
          create: (context) => NodeDashboardBloc(
              nodeDashboardRepository: nodeDashboardRepository)
            ..add(LoadNodeDashboardData()),
        ),
        BlocProvider<GovernanceBloc>(
          create: (context) =>
              GovernanceBloc(governanceRepository: governanceRepository)
                ..add(LoadGovernanceData()),
        ),
        BlocProvider<IdentityBloc>(
          create: (context) =>
              IdentityBloc(identityRepository: identityRepository)
                ..add(LoadIdentityData()),
        ),
        BlocProvider<SocialBloc>(
          create: (context) => SocialBloc(socialRepository: socialRepository)
            ..add(LoadSocialData()),
        ),
        BlocProvider<DeFiBloc>(
          create: (context) =>
              DeFiBloc(defiRepository: defiRepository)..add(LoadDeFiData()),
        ),
        BlocProvider<WalletSetupBloc>(
          create: (context) => WalletSetupBloc(
              walletSetupRepository: walletSetupRepository),
        ),
      ],
      child: MaterialApp.router(
        title: 'GOFLUTTER',
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    await Future.delayed(
        const Duration(seconds: 2)); // Show splash for 2 seconds

    if (mounted) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.isAuthenticated) {
        context.go('/dashboard');
      } else {
        context.go('/intro');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet,
              size: 100,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 24),
            const Text(
              'ATLAS Blockchain',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your Digital Wallet',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ATLAS Wallet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final authProvider =
                  Provider.of<AuthProvider>(context, listen: false);
              await authProvider.logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final user = authProvider.currentUser;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, ${user?.displayName ?? user?.email ?? 'User'}!',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Wallet Address',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          user?.walletAddress ?? 'No wallet address',
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Features',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildFeatureCard(
                        context,
                        'Send',
                        Icons.send,
                        Colors.blue,
                        '/wallet',
                      ),
                      _buildFeatureCard(
                        context,
                        'Receive',
                        Icons.receipt,
                        Colors.green,
                        '/wallet',
                      ),
                      _buildFeatureCard(
                        context,
                        'Governance',
                        Icons.how_to_vote,
                        Colors.purple,
                        '/governance',
                      ),
                      _buildFeatureCard(
                        context,
                        'Explorer',
                        Icons.explore,
                        Colors.orange,
                        '/explorer',
                      ),
                      _buildFeatureCard(
                        context,
                        'DeFi',
                        Icons.account_balance,
                        Colors.teal,
                        '/defi',
                      ),
                      _buildFeatureCard(
                        context,
                        'Node Dashboard',
                        Icons.dashboard,
                        Colors.indigo,
                        '/node-dashboard',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, IconData icon,
      Color color, String route) {
    return Card(
      child: InkWell(
        onTap: () {
          context.go(route);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}