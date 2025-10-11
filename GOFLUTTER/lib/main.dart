import 'dart:io' show HttpOverrides;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Import the app router
import 'core/routing/app_router.dart';

// Import providers and navigation
import 'core/navigation/navigation_state_manager.dart';

// Import essential BLoCs
import 'features/wallet_setup/presentation/bloc/wallet_setup_bloc.dart';
import 'features/wallet_setup/data/repositories/wallet_setup_repository.dart';
import 'features/wallet_setup/data/repositories/wallet_setup_repository_impl.dart';

// Import stub BLoCs for features
import 'core/stubs/stub_blocs_clean.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    // Ignore if .env file doesn't exist
  }

  if (kIsWeb) {
    // Handle CORS for web
    HttpOverrides.global = MyHttpOverrides();
  }
  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  createHttpClient(context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Navigation state manager
        ChangeNotifierProvider(create: (_) => NavigationStateManager()),

        // Only include working repositories
        Provider<WalletSetupRepository>(
          create: (_) => WalletSetupRepositoryImpl(),
        ),

        // Working BLoCs
        BlocProvider(
          create: (context) => WalletSetupBloc(
            walletSetupRepository: context.read<WalletSetupRepository>(),
          ),
        ),

        // Stub BLoCs for all features
        BlocProvider(create: (_) => IdentityBloc()),
        BlocProvider(create: (_) => DeFiBloc()),
        BlocProvider(create: (_) => ExplorerBloc()),
        BlocProvider(create: (_) => HealthBloc()),
        BlocProvider(create: (_) => NodeDashboardBloc()),
        BlocProvider(create: (_) => GovernanceBloc()),
        BlocProvider(create: (_) => ContractsBloc()),
        BlocProvider(create: (_) => SocialBloc()),
        BlocProvider(create: (_) => DashboardBloc()),
        BlocProvider(create: (_) => WalletBloc()),
      ],
      child: MaterialApp.router(
        title: 'ATLAS B.C.',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Inter'),
        routerConfig: appRouter,
      ),
    );
  }
}
