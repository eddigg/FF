import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:atlas_blockchain_flutter/shared/widgets/glass_card.dart';

void main() {
  group('NavigationCard Widget Tests', () {
    testWidgets('renders with title and description', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NavigationCard(
              title: 'Test Card',
              description: 'This is a test card description',
              buttonText: 'Go to Test',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Card'), findsOneWidget);
      expect(find.text('This is a test card description'), findsOneWidget);
      expect(find.text('Go to Test'), findsOneWidget);
    });

    testWidgets('calls onPressed when button is tapped', (WidgetTester tester) async {
      bool pressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NavigationCard(
              title: 'Test Card',
              description: 'This is a test card description',
              buttonText: 'Go to Test',
              onPressed: () {
                pressed = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Go to Test'));
      await tester.pumpAndSettle();

      expect(pressed, isTrue);
    });

    testWidgets('displays icon when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NavigationCard(
              title: 'Test Card',
              description: 'This is a test card description',
              buttonText: 'Go to Test',
              onPressed: () {},
              icon: Icons.home,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.home), findsOneWidget);
    });
  });
}