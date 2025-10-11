import 'package:flutter_bloc/flutter_bloc.dart';

// Clean stub BLoCs that provide basic functionality without complex dependencies

// Identity Stub
abstract class IdentityEvent {}

class LoadIdentity extends IdentityEvent {}

abstract class IdentityState {}

class IdentityInitial extends IdentityState {}

class IdentityLoading extends IdentityState {}

class IdentityLoaded extends IdentityState {}

class IdentityBloc extends Bloc<IdentityEvent, IdentityState> {
  IdentityBloc() : super(IdentityInitial()) {
    on<LoadIdentity>((event, emit) => emit(IdentityLoaded()));
  }
}

// Explorer Stub
abstract class ExplorerEvent {}

class LoadRecentBlocks extends ExplorerEvent {}

class LoadRecentTransactions extends ExplorerEvent {}

class StartAutoRefresh extends ExplorerEvent {}

class StopAutoRefresh extends ExplorerEvent {}

class RefreshData extends ExplorerEvent {}

enum ExplorerStatus { initial, loading, success, failure }

abstract class ExplorerState {
  final ExplorerStatus status;
  final List<Map<String, dynamic>> blocks;
  final List<Map<String, dynamic>> transactions;
  final String? errorMessage;

  const ExplorerState({
    this.status = ExplorerStatus.initial,
    this.blocks = const [],
    this.transactions = const [],
    this.errorMessage,
  });
}

class ExplorerInitial extends ExplorerState {
  const ExplorerInitial() : super(status: ExplorerStatus.initial);
}

class ExplorerLoading extends ExplorerState {
  const ExplorerLoading() : super(status: ExplorerStatus.loading);
}

class ExplorerLoaded extends ExplorerState {
  const ExplorerLoaded({
    List<Map<String, dynamic>> blocks = const [
      {
        'height': 12345,
        'hash': '0x742d35Cc6634C0532925a3b8D4C0532925a3b8D4',
        'transactions': 5,
        'timestamp': '2024-01-15 14:30:00',
        'miner': '0x8ba1f109551bD432803012645Hac136c22C177e9',
        'gasUsed': 21000,
        'gasLimit': 8000000,
      },
    ],
    List<Map<String, dynamic>> transactions = const [
      {
        'hash': '0x1a2b3c4d5e6f7890abcdef1234567890abcdef12',
        'from': '0x742d35Cc6634C0532925a3b8D4C0532925a3b8D4',
        'to': '0x8ba1f109551bD432803012645Hac136c22C177e9',
        'value': '50.0 ATLAS',
        'gasPrice': '20 Gwei',
        'gasUsed': 21000,
        'status': 'Success',
        'blockNumber': 12345,
        'timestamp': '2024-01-15 14:30:00',
      },
    ],
  }) : super(
         status: ExplorerStatus.success,
         blocks: blocks,
         transactions: transactions,
       );
}

class ExplorerBloc extends Bloc<ExplorerEvent, ExplorerState> {
  ExplorerBloc() : super(const ExplorerInitial()) {
    on<LoadRecentBlocks>((event, emit) => emit(const ExplorerLoaded()));
    on<LoadRecentTransactions>((event, emit) => emit(const ExplorerLoaded()));
    on<StartAutoRefresh>((event, emit) {});
    on<StopAutoRefresh>((event, emit) {});
    on<RefreshData>((event, emit) {
      emit(const ExplorerLoading());
      Future.delayed(const Duration(milliseconds: 500), () {
        emit(const ExplorerLoaded());
      });
    });
  }
}

// Wallet Stub
abstract class WalletEvent {}

class LoadWallet extends WalletEvent {}

class SendTransaction extends WalletEvent {
  final String recipient;
  final double amount;
  final String message;
  SendTransaction({
    required this.recipient,
    required this.amount,
    required this.message,
  });
}

class RequestTestTokens extends WalletEvent {}

class SelectAccount extends WalletEvent {
  final Map<String, dynamic> account;
  SelectAccount(this.account);
}

class CreateAccount extends WalletEvent {
  final String name;
  CreateAccount({required this.name});
}

abstract class WalletState {}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletError extends WalletState {
  final String message;
  WalletError(this.message);
}

class WalletActionSuccess extends WalletState {
  final String message;
  WalletActionSuccess(this.message);
}

class WalletLoaded extends WalletState {
  final double balance;
  final String address;
  final List<Map<String, dynamic>> transactions;
  final List<Map<String, dynamic>> accounts;
  final int selectedAccountIndex;

  WalletLoaded({
    this.balance = 1000.0,
    this.address = '0x742d35Cc6634C0532925a3b8D4C0532925a3b8D4',
    this.selectedAccountIndex = 0,
    this.accounts = const [
      {'name': 'Main Account', 'balance': 1000.0},
      {'name': 'Trading Account', 'balance': 250.0},
    ],
    this.transactions = const [
      {
        'from': '0x742d35Cc6634C0532925a3b8D4C0532925a3b8D4',
        'to': '0x8ba1f109551bD432803012645Hac136c22C177e9',
        'amount': 50.0,
        'message': 'Payment for services',
        'timestamp': '2024-01-15 14:30:00',
        'hash': '0x1a2b3c4d5e6f...',
      },
    ],
  });
}

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc() : super(WalletInitial()) {
    on<LoadWallet>((event, emit) => emit(WalletLoaded()));
    on<SendTransaction>((event, emit) {
      emit(WalletActionSuccess('Transaction sent successfully!'));
      emit(WalletLoaded(balance: 950.0));
    });
    on<RequestTestTokens>((event, emit) {
      emit(WalletActionSuccess('Test tokens received!'));
      emit(WalletLoaded(balance: 1100.0));
    });
    on<SelectAccount>((event, emit) => emit(WalletLoaded()));
    on<CreateAccount>((event, emit) {
      emit(
        WalletActionSuccess('Account "${event.name}" created successfully!'),
      );
      emit(WalletLoaded());
    });
  }
}

// Node Dashboard Stub
abstract class NodeDashboardEvent {}

class LoadNodeData extends NodeDashboardEvent {}

abstract class NodeDashboardState {}

class NodeDashboardInitial extends NodeDashboardState {}

class NodeDashboardLoading extends NodeDashboardState {}

class NodeDashboardLoaded extends NodeDashboardState {
  final int connectedPeers;
  final String nodeStatus;
  final double syncProgress;
  final Map<String, dynamic> networkStats;
  final Map<String, dynamic> nodeMetrics;
  final Map<String, dynamic> validatorInfo;
  final List<Map<String, dynamic>> validators;

  NodeDashboardLoaded({
    this.connectedPeers = 8,
    this.nodeStatus = 'Running',
    this.syncProgress = 100.0,
    this.networkStats = const {
      'totalValidators': 45,
      'networkHashRate': '2.5 TH/s',
      'avgBlockTime': '12.3s',
      'networkDifficulty': 'High',
    },
    this.nodeMetrics = const {
      'uptime': '7 days, 14 hours',
      'blocksProduced': 156,
      'transactionsProcessed': 45678,
    },
    this.validatorInfo = const {
      'stake': 10000.0,
      'status': 'Active',
      'address': '0x742d35Cc6634C0532925a3b8D4C0532925a3b8D4',
      'rank': 5,
      'nodeMode': 'Validator',
    },
    this.validators = const [
      {
        'address': '0x742d35Cc6634C0532925a3b8D4C0532925a3b8D4',
        'stake': 10000.0,
        'status': 'Active',
        'uptime': 99.8,
      },
    ],
  });
}

class NodeDashboardBloc extends Bloc<NodeDashboardEvent, NodeDashboardState> {
  NodeDashboardBloc() : super(NodeDashboardInitial()) {
    on<LoadNodeData>((event, emit) => emit(NodeDashboardLoaded()));
  }
}

// Dashboard Stub
abstract class DashboardEvent {}

class LoadDashboard extends DashboardEvent {}

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final Map<String, dynamic> stats;
  DashboardLoaded({
    this.stats = const {
      'totalTransactions': 145678,
      'activeNodes': 156,
      'networkHealth': 'Excellent',
    },
  });
}

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<LoadDashboard>((event, emit) => emit(DashboardLoaded()));
  }
}

// Other simplified stub BLoCs
abstract class DeFiEvent {}

class LoadDeFiData extends DeFiEvent {}

abstract class DeFiState {}

class DeFiInitial extends DeFiState {}

class DeFiLoaded extends DeFiState {}

class DeFiBloc extends Bloc<DeFiEvent, DeFiState> {
  DeFiBloc() : super(DeFiInitial()) {
    on<LoadDeFiData>((event, emit) => emit(DeFiLoaded()));
  }
}

abstract class HealthEvent {}

class LoadHealthData extends HealthEvent {}

abstract class HealthState {}

class HealthInitial extends HealthState {}

class HealthLoaded extends HealthState {}

class HealthBloc extends Bloc<HealthEvent, HealthState> {
  HealthBloc() : super(HealthInitial()) {
    on<LoadHealthData>((event, emit) => emit(HealthLoaded()));
  }
}

abstract class GovernanceEvent {}

class LoadProposals extends GovernanceEvent {}

abstract class GovernanceState {}

class GovernanceInitial extends GovernanceState {}

class GovernanceLoaded extends GovernanceState {}

class GovernanceBloc extends Bloc<GovernanceEvent, GovernanceState> {
  GovernanceBloc() : super(GovernanceInitial()) {
    on<LoadProposals>((event, emit) => emit(GovernanceLoaded()));
  }
}

abstract class ContractsEvent {}

class LoadContracts extends ContractsEvent {}

abstract class ContractsState {}

class ContractsInitial extends ContractsState {}

class ContractsLoaded extends ContractsState {}

class ContractsBloc extends Bloc<ContractsEvent, ContractsState> {
  ContractsBloc() : super(ContractsInitial()) {
    on<LoadContracts>((event, emit) => emit(ContractsLoaded()));
  }
}

abstract class SocialEvent {}

class LoadSocialFeed extends SocialEvent {}

abstract class SocialState {}

class SocialInitial extends SocialState {}

class SocialLoaded extends SocialState {}

class SocialBloc extends Bloc<SocialEvent, SocialState> {
  SocialBloc() : super(SocialInitial()) {
    on<LoadSocialFeed>((event, emit) => emit(SocialLoaded()));
  }
}
