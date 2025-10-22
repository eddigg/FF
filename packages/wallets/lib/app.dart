import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

// Core imports
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/l10n/generated/l10n.dart';

// Blocs
import 'blocs/auth/auth_bloc.dart';
import 'blocs/blockchain/blockchain_bloc.dart';
import 'blocs/transactions/transactions_bloc.dart';
import 'blocs/wallet/wallet_bloc.dart';

class AtlasWalletApp extends StatefulWidget {
  const AtlasWalletApp({super.key});

  @override
  State<AtlasWalletApp> createState() => _AtlasWalletAppState();
}

class _AtlasWalletAppState extends State<AtlasWalletApp> {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc()..add(AuthInitializeEvent()),
        ),
        BlocProvider<BlockchainBloc>(
          create: (context) => BlockchainBloc(),
        ),
        BlocProvider<WalletBloc>(
          create: (context) => WalletBloc(),
        ),
        BlocProvider<TransactionsBloc>(
          create: (context) => TransactionsBloc(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'ATLAS Wallet',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        routerConfig: _appRouter.router,

        // Internationalization
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,

        // Custom fonts
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              textTheme: GoogleFonts.interTextTheme(
                Theme.of(context).textTheme,
              ),
            ),
            child: child ?? const SizedBox.shrink(),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _appRouter.dispose();
    super.dispose();
  }
}
