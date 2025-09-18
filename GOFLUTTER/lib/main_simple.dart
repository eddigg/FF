import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/routing/app_router.dart';
import 'features/auth/services/auth_service.dart';
import 'core/network/api_client.dart' as core_api_client;
import 'features/auth/services/secure_storage_implementation.dart';
import 'features/auth/services/api_client_implementation.dart';
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
import 'features/wallet/services/wallet_service.dart'; // Add this import
import 'features/wallet_setup/presentation/bloc/wallet_setup_bloc.dart';
import 'features/wallet_setup/data/repositories/wallet_setup_repository.dart';
import 'features/wallet_setup/data/repositories/wallet_setup_repository_impl.dart';
// Import the AuthProvider
import 'features/auth/presentation/providers/auth_provider.dart';
import 'core/storage/secure_storage.dart' as core_secure_storage; // Add this import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the ApiClient properly
  core_api_client.ApiClient.initialize(baseUrl: 'http://localhost:8080');
  final apiClientCore = core_api_client.ApiClient(); // Create an instance of ApiClient

  // Initialize services
  final secureStorage = SecureStorage();
  final coreSecureStorage = core_secure_storage.SecureStorage(); // Add this line
  final authApiClient = ApiClient(); // Create an instance of ApiClient for auth
  final authService = AuthService(authApiClient, secureStorage);
  final dashboardApiClient = DashboardApiClient(apiClientCore);
  final dashboardRepository =
      DashboardRepositoryImpl(apiClient: dashboardApiClient);
  final explorerApiClient = ExplorerApiClient(apiClientCore);
  final explorerRepository =
      ExplorerRepositoryImpl(apiClient: explorerApiClient);
  final walletApiClient = WalletApiClient(apiClientCore);
  final walletRepository = WalletRepositoryImpl(apiClient: walletApiClient);
  final walletService = WalletService(apiClientCore, coreSecureStorage); // Add this line
  final walletSetupRepository = WalletSetupRepositoryImpl();

  runApp(MyApp(
    authService: authService,
    dashboardRepository: dashboardRepository,
    explorerRepository: explorerRepository,
    walletRepository: walletRepository,
    walletService: walletService, // Add this line
    walletSetupRepository: walletSetupRepository,
    apiClient: apiClientCore,
  ));
}

class MyApp extends StatelessWidget {
  final AuthService authService;
  final DashboardRepository dashboardRepository;
  final ExplorerRepository explorerRepository;
  final WalletRepository walletRepository;
  final WalletService walletService; // Add this line
  final WalletSetupRepository walletSetupRepository;
  final core_api_client.ApiClient apiClient;

  const MyApp({
    super.key,
    required this.authService,
    required this.dashboardRepository,
    required this.explorerRepository,
    required this.walletRepository,
    required this.walletService, // Add this line
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
              WalletBloc(walletRepository: walletRepository, walletService: walletService) // Fix this line
                ..add(LoadWallet()),
        ),
        BlocProvider<WalletSetupBloc>(
          create: (context) =>
              WalletSetupBloc(walletSetupRepository: walletSetupRepository),
        ),
      ],
      child: MaterialApp.router(
        title: 'ATLAS Blockchain Flutter',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        routerConfig: appRouter,
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
        context.go('/login');
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
                        'Explorer',
                        Icons.explore,
                        Colors.orange,
                        '/explorer',
                      ),
                      _buildFeatureCard(
                        context,
                        'Dashboard',
                        Icons.dashboard,
                        Colors.indigo,
                        '/dashboard',
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
