import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:atlas_blockchain_flutter/features/dashboard/presentation/widgets/node_selector.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:atlas_blockchain_flutter/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:atlas_blockchain_flutter/core/network/api_client.dart';

void main() {
  group('NodeSelector Widget Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('renders with status indicator and port buttons', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NodeSelector(),
          ),
        ),
      );

      // Wait for async initialization
      await tester.pumpAndSettle();

      // Check if status indicator is displayed
      expect(find.textContaining('Connected to Node'), findsOneWidget);
      
      // Check if port buttons are displayed
      expect(find.text('8080'), findsOneWidget);
      expect(find.text('8081'), findsOneWidget);
      expect(find.text('8082'), findsOneWidget);
      expect(find.text('8083'), findsOneWidget);
    });
  });
}

// Simple mock classes for testing
class MockDashboardRepository extends Mock implements DashboardRepository {}

class MockApiClient extends Mock implements ApiClient {}

class MockDio extends Mock implements Dio {}