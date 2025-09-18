import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:atlas_blockchain_flutter/shared/widgets/app_scaffold.dart';

void main() {
  group('App Scaffold Tests', () {
    testWidgets('AppScaffold displays title', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        const MaterialApp(
          home: AppScaffold(
            title: 'Test Title',
            child: Text('Test Content'),
          ),
        ),
      );

      // Verify that the title is displayed
      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Content'), findsOneWidget);
    });

    testWidgets('AppScaffold has navigation bar', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AppScaffold(
            title: 'Test Title',
            child: Text('Test Content'),
          ),
        ),
      );

      // Verify that the bottom navigation bar exists
      expect(find.byType(BottomAppBar), findsOneWidget);
      
      // Verify that navigation icons exist
      expect(find.byIcon(Icons.dashboard), findsOneWidget);
      expect(find.byIcon(Icons.account_balance_wallet), findsOneWidget);
      expect(find.byIcon(Icons.explore), findsOneWidget);
      expect(find.byIcon(Icons.how_to_vote), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });
  });
}