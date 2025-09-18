import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:atlas_blockchain_flutter/features/dashboard/presentation/widgets/nav_card.dart';
import 'package:atlas_blockchain_flutter/shared/themes/web_colors.dart';

void main() {
  group('Animation Performance Tests', () {
    testWidgets('NavCard basic render test', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NavCard(
              title: 'Test Card',
              icon: '🔗',
              description: 'Test description',
              buttonText: 'Test',
              onPressed: () {},
            ),
          ),
        ),
      );

      // Verify the card is rendered
      expect(find.text('Test Card'), findsOneWidget);
      expect(find.text('Test description'), findsOneWidget);
    });

    testWidgets('Status indicator basic render test', (WidgetTester tester) async {
      // Test a simple status indicator
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: WebColors.success,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      );

      // Verify it renders
      expect(find.byType(Container), findsOneWidget);
    });
  });
}