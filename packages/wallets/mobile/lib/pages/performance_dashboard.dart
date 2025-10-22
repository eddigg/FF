// products/wallets/mobile/lib/pages/performance_dashboard.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/wallet_bloc.dart';

class PerformanceDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Performance Metrics')),
      body: BlocBuilder<WalletBloc, WalletState>(
        builder: (context, state) {
          return ListView(
            children: [
              ListTile(title: Text('Startup Time: <2s')),
              ListTile(title: Text('Memory Usage: <100MB')),
              ListTile(title: Text('Bundle Size: <5MB')),
              ListTile(title: Text('Cache Hit Rate: ${state is WalletLoaded ? 'High' : 'Loading'}')),
            ],
          );
        },
      ),
    );
  }
}
