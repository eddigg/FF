import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goflutter/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:goflutter/features/wallet/presentation/pages/wallet_page.dart';
import 'package:mockito/mockito.dart';

class MockWalletBloc extends Mock implements WalletBloc {}

void main() {
  group('WalletPage', () {
    late MockWalletBloc mockWalletBloc;

    setUp(() {
      mockWalletBloc = MockWalletBloc();
    });

    testWidgets('renders a loading indicator when the state is WalletLoading', (WidgetTester tester) async {
      when(mockWalletBloc.state).thenReturn(WalletLoading());

      await tester.pumpWidget(
        BlocProvider<WalletBloc>.value(
          value: mockWalletBloc,
          child: const MaterialApp(home: WalletPage()),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders the wallet data when the state is WalletLoaded', (WidgetTester tester) async {
      when(mockWalletBloc.state).thenReturn(const WalletLoaded(
        address: 'test_address',
        balance: 100.0,
        transactions: [],
        accounts: [],
      ));

      await tester.pumpWidget(
        BlocProvider<WalletBloc>.value(
          value: mockWalletBloc,
          child: const MaterialApp(home: WalletPage()),
        ),
      );

      expect(find.text('test_address'), findsOneWidget);
      expect(find.text('100.0 tokens'), findsOneWidget);
    });

    testWidgets('renders an error message when the state is WalletError', (WidgetTester tester) async {
      when(mockWalletBloc.state).thenReturn(const WalletError('test_error'));

      await tester.pumpWidget(
        BlocProvider<WalletBloc>.value(
          value: mockWalletBloc,
          child: const MaterialApp(home: WalletPage()),
        ),
      );

      expect(find.text('test_error'), findsOneWidget);
    });
  });
}
