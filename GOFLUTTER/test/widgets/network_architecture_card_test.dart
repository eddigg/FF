import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:atlas_blockchain_flutter/features/dashboard/presentation/widgets/network_architecture_card.dart';
import 'package:atlas_blockchain_flutter/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:atlas_blockchain_flutter/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:atlas_blockchain_flutter/core/network/api_client.dart';
import 'package:atlas_blockchain_flutter/features/dashboard/data/models/dashboard_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

class MockDashboardRepository implements DashboardRepository {
  @override
  Future<DashboardModel> getDashboardData() async {
    // Return a mock DashboardModel with sample data
    return DashboardModel(
      blockCount: 12345,
      transactionCount: 67890,
      recentBlocks: [],
      peerCount: 42,
      nodeStatus: 'active',
      networkLatency: 12.5,
      networkArchitecture: {
        'nodeTypes': {
          'validators': {'count': 10, 'active': 8, 'description': 'Validator nodes'},
          'observers': {'count': 5, 'description': 'Observer nodes'},
          'fullNodes': {'count': 20, 'description': 'Full nodes'},
        },
        'p2pProtocol': {
          'type': 'Libp2p',
          'version': '0.32.1',
          'discovery': 'Kademlia DHT',
          'transport': 'WebRTC',
          'description': 'Secure peer-to-peer networking',
        },
        'consensusMechanism': {
          'type': 'Proof of Stake',
          'blockTime': '5s',
          'finality': 'Instant',
          'description': 'Energy-efficient consensus algorithm',
        },
        'networkTopology': {
          'type': 'Mesh',
          'maxPeers': 50,
          'connections': 'Dynamic',
          'description': 'Resilient mesh network topology',
        },
        'securityFeatures': {
          'encryption': 'AES-256',
          'authentication': 'JWT',
          'rateLimiting': 'Yes',
          'slashing': 'Enabled',
          'description': 'Multi-layer security protection',
        },
      },
    );
  }
}

class MockApiClient extends ApiClient {
  @override
  Dio get dio => Dio();

  @override
  void addAuthorizationToken(String token) {
    // Mock implementation
  }

  @override
  void removeAuthorizationToken() {
    // Mock implementation
  }

  @override
  void updateBaseUrl(String newBaseUrl) {
    // Mock implementation
  }
}

void main() {
  group('NetworkArchitectureCard Widget Tests', () {
    testWidgets('renders with title and architecture cards', (WidgetTester tester) async {
      // Create a mock DashboardBloc with initial state
      final dashboardBloc = DashboardBloc(
        dashboardRepository: MockDashboardRepository(),
        apiClient: MockApiClient(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<DashboardBloc>.value(
            value: dashboardBloc,
            child: const Scaffold(
              body: NetworkArchitectureCard(),
            ),
          ),
        ),
      );

      // Check if the main title is displayed
      expect(find.text('🌐 Network Architecture'), findsOneWidget);
      
      // Check if architecture card titles are displayed
      expect(find.text('Node Types'), findsOneWidget);
      expect(find.text('P2P Protocol'), findsOneWidget);
      expect(find.text('Consensus Mechanism'), findsOneWidget);
      expect(find.text('Network Topology'), findsOneWidget);
      expect(find.text('Security Features'), findsOneWidget);
    });
  });
}