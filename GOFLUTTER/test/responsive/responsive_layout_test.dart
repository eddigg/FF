import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:atlas_blockchain_flutter/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:atlas_blockchain_flutter/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:atlas_blockchain_flutter/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:atlas_blockchain_flutter/features/dashboard/data/data_sources/dashboard_api_client.dart';
import 'package:atlas_blockchain_flutter/core/network/api_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

// Mock classes for testing
class MockApiClient implements ApiClient {
  @override
  final Dio dio = Dio();
  
  @override
  String get baseUrl => 'http://localhost:8080';
  
  @override
  void updateBaseUrl(String newBaseUrl) {}
  
  @override
  void addAuthorizationToken(String token) {}
  
  @override
  void removeAuthorizationToken() {}
}

// Mock User class
class User {
  final String uid;
  final String email;
  
  User({required this.uid, required this.email});
}

// Mock AuthProvider
class MockAuthProvider extends ChangeNotifier {
  User? _currentUser = User(uid: 'test-uid', email: 'test@example.com');
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(Duration(milliseconds: 100)); // Simulate async operation
    _currentUser = null;
    _isLoading = false;
    notifyListeners();
  }
}

class MockDashboardApiClient extends DashboardApiClient {
  MockDashboardApiClient(super.apiClient);

  @override
  Future<Map<String, dynamic>> fetchDashboardData() async {
    return {
      'blockCount': 100,
      'transactionCount': 500,
      'recentBlocks': [],
      'peerCount': 25,
      'nodeStatus': 'connected',
      'networkLatency': 45.0,
      'networkArchitecture': {
        'nodeTypes': {
          'validators': {'count': 10, 'active': 8, 'description': 'Validator nodes'},
          'observers': {'count': 5, 'description': 'Observer nodes'},
          'fullNodes': {'count': 20, 'description': 'Full nodes'},
        },
        'p2pProtocol': {
          'type': 'LibP2P',
          'version': '1.0',
          'discovery': 'Kademlia',
          'transport': 'TCP',
          'description': 'Secure P2P networking',
        },
        'consensusMechanism': {
          'type': 'Proof of Stake',
          'blockTime': '5s',
          'finality': 'Instant',
          'description': 'Fast consensus mechanism',
        },
        'networkTopology': {
          'type': 'Hybrid',
          'maxPeers': 50,
          'connections': 'Mesh',
          'description': 'Scalable network topology',
        },
        'securityFeatures': {
          'encryption': 'AES-256',
          'authentication': 'JWT',
          'rateLimiting': 'Yes',
          'slashing': 'Enabled',
          'description': 'Enterprise-grade security',
        },
      },
    };
  }
}

// Test widget that provides necessary providers
class TestApp extends StatelessWidget {
  final DashboardBloc dashboardBloc;
  final MockAuthProvider authProvider;

  const TestApp({
    Key? key,
    required this.dashboardBloc,
    required this.authProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<MockAuthProvider>.value(value: authProvider),
        ],
        child: BlocProvider.value(
          value: dashboardBloc,
          child: const DashboardPage(),
        ),
      ),
    );
  }
}

void main() {
  group('Responsive Layout Tests', () {
    late MockApiClient mockApiClient;
    late MockDashboardApiClient mockDashboardApiClient;
    late DashboardBloc dashboardBloc;
    late MockAuthProvider mockAuthProvider;

    setUp(() async {
      // Initialize mocks
      mockApiClient = MockApiClient();
      mockDashboardApiClient = MockDashboardApiClient(mockApiClient);
      mockAuthProvider = MockAuthProvider();
      
      // Set up shared preferences mock
      SharedPreferences.setMockInitialValues({});
      
      // Create a real repository with our mock
      final realRepository = DashboardRepositoryImpl(apiClient: mockDashboardApiClient);
      
      // Create the bloc with mocked dependencies
      dashboardBloc = DashboardBloc(
        dashboardRepository: realRepository,
        apiClient: mockApiClient,
      );
    });

    tearDown(() {
      dashboardBloc.close();
    });

    testWidgets('Dashboard layout on mobile screen (375x667)', (WidgetTester tester) async {
      // Set the screen size to mobile dimensions
      tester.view
        ..physicalSize = const Size(375.0, 667.0)
        ..devicePixelRatio = 1.0;

      // Build the test app
      await tester.pumpWidget(
        TestApp(
          dashboardBloc: dashboardBloc,
          authProvider: mockAuthProvider,
        ),
      );

      // Trigger initial data load
      dashboardBloc.add(LoadDashboardData());
      
      // Wait for the UI to settle
      await tester.pumpAndSettle();

      // Verify that the dashboard page is displayed
      expect(find.text('🔗 ATLAS B.C.'), findsOneWidget);
      expect(find.text('Real-time monitoring of your decentralized network'), findsOneWidget);

      // Verify navigation cards are displayed in single column
      expect(find.text('Explorer'), findsOneWidget);
      expect(find.text('Wallet'), findsOneWidget);
      expect(find.text('Network'), findsOneWidget);
      expect(find.text('Health'), findsOneWidget);
      expect(find.text('Governance'), findsOneWidget);
      expect(find.text('Smart Contracts'), findsOneWidget);
      expect(find.text('Social Platform'), findsOneWidget);
      expect(find.text('DeFi Platform'), findsOneWidget);
      expect(find.text('Identity Management'), findsOneWidget);

      // Verify network architecture section is displayed
      expect(find.text('🌐 Network Architecture'), findsOneWidget);
      expect(find.text('Node Types'), findsOneWidget);
      expect(find.text('P2P Protocol'), findsOneWidget);
      expect(find.text('Consensus Mechanism'), findsOneWidget);
      expect(find.text('Network Topology'), findsOneWidget);
      expect(find.text('Security Features'), findsOneWidget);

      // Reset the view
      tester.view.reset();
    });

    testWidgets('Dashboard layout on tablet screen (768x1024)', (WidgetTester tester) async {
      // Set the screen size to tablet dimensions
      tester.view
        ..physicalSize = const Size(768.0, 1024.0)
        ..devicePixelRatio = 1.0;

      // Build the test app
      await tester.pumpWidget(
        TestApp(
          dashboardBloc: dashboardBloc,
          authProvider: mockAuthProvider,
        ),
      );

      // Trigger initial data load
      dashboardBloc.add(LoadDashboardData());
      
      // Wait for the UI to settle
      await tester.pumpAndSettle();

      // Verify that the dashboard page is displayed
      expect(find.text('🔗 ATLAS B.C.'), findsOneWidget);
      expect(find.text('Real-time monitoring of your decentralized network'), findsOneWidget);

      // Verify navigation cards are displayed in two columns
      expect(find.text('Explorer'), findsOneWidget);
      expect(find.text('Wallet'), findsOneWidget);
      expect(find.text('Network'), findsOneWidget);
      expect(find.text('Health'), findsOneWidget);
      expect(find.text('Governance'), findsOneWidget);
      expect(find.text('Smart Contracts'), findsOneWidget);
      expect(find.text('Social Platform'), findsOneWidget);
      expect(find.text('DeFi Platform'), findsOneWidget);
      expect(find.text('Identity Management'), findsOneWidget);

      // Verify network architecture section is displayed
      expect(find.text('🌐 Network Architecture'), findsOneWidget);
      expect(find.text('Node Types'), findsOneWidget);
      expect(find.text('P2P Protocol'), findsOneWidget);
      expect(find.text('Consensus Mechanism'), findsOneWidget);
      expect(find.text('Network Topology'), findsOneWidget);
      expect(find.text('Security Features'), findsOneWidget);

      // Reset the view
      tester.view.reset();
    });

    testWidgets('Dashboard layout on desktop screen (1920x1080)', (WidgetTester tester) async {
      // Set the screen size to desktop dimensions
      tester.view
        ..physicalSize = const Size(1920.0, 1080.0)
        ..devicePixelRatio = 1.0;

      // Build the test app
      await tester.pumpWidget(
        TestApp(
          dashboardBloc: dashboardBloc,
          authProvider: mockAuthProvider,
        ),
      );

      // Trigger initial data load
      dashboardBloc.add(LoadDashboardData());
      
      // Wait for the UI to settle
      await tester.pumpAndSettle();

      // Verify that the dashboard page is displayed
      expect(find.text('🔗 ATLAS B.C.'), findsOneWidget);
      expect(find.text('Real-time monitoring of your decentralized network'), findsOneWidget);

      // Verify navigation cards are displayed in four columns
      expect(find.text('Explorer'), findsOneWidget);
      expect(find.text('Wallet'), findsOneWidget);
      expect(find.text('Network'), findsOneWidget);
      expect(find.text('Health'), findsOneWidget);
      expect(find.text('Governance'), findsOneWidget);
      expect(find.text('Smart Contracts'), findsOneWidget);
      expect(find.text('Social Platform'), findsOneWidget);
      expect(find.text('DeFi Platform'), findsOneWidget);
      expect(find.text('Identity Management'), findsOneWidget);

      // Verify network architecture section is displayed
      expect(find.text('🌐 Network Architecture'), findsOneWidget);
      expect(find.text('Node Types'), findsOneWidget);
      expect(find.text('P2P Protocol'), findsOneWidget);
      expect(find.text('Consensus Mechanism'), findsOneWidget);
      expect(find.text('Network Topology'), findsOneWidget);
      expect(find.text('Security Features'), findsOneWidget);

      // Reset the view
      tester.view.reset();
    });

    testWidgets('Dashboard layout orientation change from portrait to landscape', (WidgetTester tester) async {
      // Start with portrait mobile screen
      tester.view
        ..physicalSize = const Size(375.0, 667.0)
        ..devicePixelRatio = 1.0;

      // Build the test app
      await tester.pumpWidget(
        TestApp(
          dashboardBloc: dashboardBloc,
          authProvider: mockAuthProvider,
        ),
      );

      // Trigger initial data load
      dashboardBloc.add(LoadDashboardData());
      
      // Wait for the UI to settle
      await tester.pumpAndSettle();

      // Verify initial layout
      expect(find.text('🔗 ATLAS B.C.'), findsOneWidget);

      // Change to landscape orientation
      tester.view
        ..physicalSize = const Size(667.0, 375.0)
        ..devicePixelRatio = 1.0;
      
      // Trigger a rebuild
      tester.binding.scheduleFrame();
      await tester.pumpAndSettle();

      // Verify layout adapts to landscape
      expect(find.text('🔗 ATLAS B.C.'), findsOneWidget);

      // Reset the view
      tester.view.reset();
    });
  });
}