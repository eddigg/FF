import 'package:flutter_test/flutter_test.dart';
import 'package:atlas_blockchain_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:atlas_blockchain_flutter/features/auth/services/auth_service.dart';
import 'package:atlas_blockchain_flutter/features/auth/services/api_client_implementation.dart';
import 'package:atlas_blockchain_flutter/features/auth/services/secure_storage_implementation.dart';
import 'package:atlas_blockchain_flutter/features/governance/data/repositories/governance_repository_impl.dart';
import 'package:atlas_blockchain_flutter/features/governance/data/data_sources/governance_api_client.dart';
import 'package:atlas_blockchain_flutter/features/identity/data/repositories/identity_repository_impl.dart';
import 'package:atlas_blockchain_flutter/features/identity/data/data_sources/identity_api_client.dart';
import 'package:atlas_blockchain_flutter/features/social/data/repositories/social_repository_impl.dart';
import 'package:atlas_blockchain_flutter/features/social/data/data_sources/social_api_client.dart';
import 'package:atlas_blockchain_flutter/features/contracts/data/repositories/contracts_repository_impl.dart';
import 'package:atlas_blockchain_flutter/features/contracts/data/data_sources/contracts_api_client.dart';
import 'package:atlas_blockchain_flutter/features/health/data/repositories/health_repository_impl.dart';
import 'package:atlas_blockchain_flutter/features/health/data/data_sources/health_api_client.dart';
import 'package:atlas_blockchain_flutter/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:atlas_blockchain_flutter/features/dashboard/data/data_sources/dashboard_api_client.dart';
import 'package:atlas_blockchain_flutter/features/explorer/data/repositories/explorer_repository_impl.dart';
import 'package:atlas_blockchain_flutter/features/explorer/data/data_sources/explorer_api_client.dart';
import 'package:atlas_blockchain_flutter/features/wallet/data/repositories/wallet_repository_impl.dart';
import 'package:atlas_blockchain_flutter/features/wallet/data/data_sources/wallet_api_client.dart';
import 'package:atlas_blockchain_flutter/features/node_dashboard/data/repositories/node_dashboard_repository_impl.dart';
import 'package:atlas_blockchain_flutter/features/node_dashboard/data/data_sources/node_dashboard_api_client.dart';
import 'package:atlas_blockchain_flutter/features/defi/data/repositories/defi_repository_impl.dart';
import 'package:atlas_blockchain_flutter/features/defi/data/data_sources/defi_api_client.dart';
import 'package:atlas_blockchain_flutter/features/wallet_setup/data/repositories/wallet_setup_repository_impl.dart';
import 'package:atlas_blockchain_flutter/features/wallet/services/wallet_service.dart';
import 'package:atlas_blockchain_flutter/core/network/api_client.dart' as core_api_client;
import 'package:atlas_blockchain_flutter/core/storage/secure_storage.dart' as core_secure_storage;

void main() {
  testWidgets('App starts successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final authApiClient = ApiClient();
    final secureStorage = SecureStorage();
    final authService = AuthService(authApiClient, secureStorage);
    
    // Create mock API clients
    final coreApiClient = core_api_client.ApiClient();
    final coreSecureStorage = core_secure_storage.SecureStorage();
    
    final governanceApiClient = GovernanceApiClient(coreApiClient);
    final governanceRepository = GovernanceRepositoryImpl(apiClient: governanceApiClient);
    
    final identityApiClient = IdentityApiClient(coreApiClient);
    final identityRepository = IdentityRepositoryImpl(apiClient: identityApiClient);
    
    final socialApiClient = SocialApiClient(coreApiClient);
    final socialRepository = SocialRepositoryImpl(apiClient: socialApiClient);
    
    final contractsApiClient = ContractsApiClient(coreApiClient);
    final contractRepository = ContractsRepositoryImpl(apiClient: contractsApiClient);
    
    final healthApiClient = HealthApiClient(coreApiClient);
    final healthRepository = HealthRepositoryImpl(apiClient: healthApiClient);
    
    final dashboardApiClient = DashboardApiClient(coreApiClient);
    final dashboardRepository = DashboardRepositoryImpl(apiClient: dashboardApiClient);
    
    final explorerApiClient = ExplorerApiClient(coreApiClient);
    final explorerRepository = ExplorerRepositoryImpl(apiClient: explorerApiClient);
    
    final walletApiClient = WalletApiClient(coreApiClient);
    final walletRepository = WalletRepositoryImpl(apiClient: walletApiClient);
    final walletService = WalletService(coreApiClient, coreSecureStorage);
    
    final nodeDashboardApiClient = NodeDashboardApiClient(coreApiClient);
    final nodeDashboardRepository = NodeDashboardRepositoryImpl(apiClient: nodeDashboardApiClient);
    
    final defiApiClient = DeFiApiClient(coreApiClient);
    final defiRepository = DeFiRepositoryImpl(apiClient: defiApiClient);
    
    final walletSetupRepository = WalletSetupRepositoryImpl();
    
    await tester.pumpWidget(MyApp(
      authService: authService,
      governanceRepository: governanceRepository,
      identityRepository: identityRepository,
      socialRepository: socialRepository,
      contractRepository: contractRepository,
      healthRepository: healthRepository,
      dashboardRepository: dashboardRepository,
      explorerRepository: explorerRepository,
      walletRepository: walletRepository,
      walletService: walletService,
      nodeDashboardRepository: nodeDashboardRepository,
      defiRepository: defiRepository,
      walletSetupRepository: walletSetupRepository,
      apiClient: coreApiClient,
    ));

    // Verify that the app starts without errors
    expect(find.byType(Scaffold), findsOneWidget);
  });
}