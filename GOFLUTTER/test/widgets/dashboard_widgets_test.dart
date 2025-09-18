import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:atlas_blockchain_flutter/features/dashboard/presentation/widgets/nav_card.dart';
import 'package:atlas_blockchain_flutter/features/dashboard/presentation/widgets/node_metrics_card.dart';

void main() {
  group('Dashboard Widgets Tests', () {
    testWidgets('NavCard displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NavCard(
              title: 'Test Card',
              icon: '📊',
              description: 'Test description',
              buttonText: 'Test Button',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Card'), findsOneWidget);
      expect(find.text('Test description'), findsOneWidget);
      expect(find.text('Test Button'), findsOneWidget);
    });

    testWidgets('NodeMetricsCard displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NodeMetricsCard(),
          ),
        ),
      );

      expect(find.text('📈 Node Metrics'), findsOneWidget);
    });
  });
}