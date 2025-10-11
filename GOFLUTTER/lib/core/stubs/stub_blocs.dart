import 'package:flutter_bloc/flutter_bloc.dart';

// Stub BLoCs that provide basic functionality without complex dependencies

// Identity Stub
abstract class IdentityEvent {}

class LoadIdentity extends IdentityEvent {}

abstract class IdentityState {}

class IdentityInitial extends IdentityState {}

class IdentityLoading extends IdentityState {}

class IdentityLoaded extends IdentityState {
  final String username;
  final String email;
  final bool isVerified;
  final Map<String, dynamic> profile;
  final Map<String, dynamic> reputation;
  final List<Map<String, dynamic>> credentials;
  final List<Map<String, dynamic>> activities;

  IdentityLoaded({
    this.username = 'Alex Thompson',
    this.email = 'alex.thompson@atlas.com',
    this.isVerified = true,
    this.profile = const {
      'displayName': 'Alex Thompson',
      'bio': 'Blockchain developer and DeFi enthusiast',
      'location': 'San Francisco, CA',
      'website': 'https://alexthompson.dev',
      'joinDate': '2024-01-01',
      'avatar': '👨‍💻',
    },
    this.reputation = const {
      'score': 850,
      'level': 'Expert',
      'badges': ['Early Adopter', 'Developer', 'Validator'],
      'transactions': 156,
      'successRate': 99.2,
      'endorsements': 23,
    },
    this.credentials = const [
      {
        'type': 'KYC Verification',
        'status': 'Verified',
        'issuer': 'ATLAS Identity Service',
        'issuedDate': '2024-01-05',
        'expiryDate': '2025-01-05',
      },
      {
        'type': 'Developer Certificate',
        'status': 'Active',
        'issuer': 'ATLAS Foundation',
        'issuedDate': '2024-01-10',
        'expiryDate': '2024-12-31',
      },
      {
        'type': 'Validator License',
        'status': 'Active',
        'issuer': 'Network Governance',
        'issuedDate': '2024-01-08',
        'expiryDate': '2024-07-08',
      },
    ],
    this.activities = const [
      {
        'type': 'Transaction',
        'description': 'Sent 50 ATLAS to 0x8ba1f109...',
        'timestamp': '2024-01-15 14:30:00',
        'status': 'Completed',
      },
      {
        'type': 'Staking',
        'description': 'Staked 500 ATLAS in validator pool',
        'timestamp': '2024-01-14 09:15:00',
        'status': 'Active',
      },
      {
        'type': 'Governance',
        'description': 'Voted on Protocol Upgrade proposal',
        'timestamp': '2024-01-13 16:45:00',
        'status': 'Recorded',
      },
    ],
  });
}

class IdentityBloc extends Bloc<IdentityEvent, IdentityState> {
  IdentityBloc() : super(IdentityInitial()) {
    on<LoadIdentity>((event, emit) {
      emit(IdentityLoaded());
    });
  }
}

// DeFi Stub
abstract class DeFiEvent {}

class LoadDeFiData extends DeFiEvent {}

abstract class DeFiState {}

class DeFiInitial extends DeFiState {}

class DeFiLoading extends DeFiState {}

class DeFiLoaded extends DeFiState {
  final double totalValue;
  final List<Map<String, dynamic>> assets;
  final List<Map<String, dynamic>> stakingPools;
  final List<Map<String, dynamic>> liquidityPools;
  final List<Map<String, dynamic>> yieldFarms;

  DeFiLoaded({
    this.totalValue = 2450.75,
    this.assets = const [
      {'symbol': 'ATLAS', 'balance': 1000.0, 'value': 1000.0, 'price': 1.0},
      {'symbol': 'ETH', 'balance': 0.5, 'value': 950.0, 'price': 1900.0},
      {'symbol': 'BTC', 'balance': 0.01, 'value': 500.75, 'price': 50075.0},
    ],
    this.stakingPools = const [
      {
        'name': 'ATLAS Staking',
        'apy': 12.5,
        'staked': 500.0,
        'rewards': 15.2,
        'lockPeriod': '30 days',
      },
      {
        'name': 'ETH 2.0 Staking',
        'apy': 8.3,
        'staked': 0.25,
        'rewards': 0.02,
        'lockPeriod': 'Flexible',
      },
    ],
    this.liquidityPools = const [
      {
        'pair': 'ATLAS/ETH',
        'liquidity': 1250.0,
        'apy': 15.8,
        'fees24h': 12.5,
        'volume24h': 45000.0,
      },
      {
        'pair': 'ATLAS/USDC',
        'liquidity': 800.0,
        'apy': 22.3,
        'fees24h': 8.7,
        'volume24h': 32000.0,
      },
    ],
    this.yieldFarms = const [
      {
        'name': 'ATLAS-ETH Farm',
        'apy': 45.2,
        'deposited': 300.0,
        'rewards': 25.8,
        'token': 'ATLAS-ETH LP',
      },
      {
        'name': 'Multi-Asset Farm',
        'apy': 67.5,
        'deposited': 150.0,
        'rewards': 18.3,
        'token': 'MULTI LP',
      },
    ],
  });
}

class DeFiBloc extends Bloc<DeFiEvent, DeFiState> {
  DeFiBloc() : super(DeFiInitial()) {
    on<LoadDeFiData>((event, emit) {
      emit(DeFiLoaded());
    });
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
  const ExplorerLoaded({super.blocks, super.transactions})
    : super(status: ExplorerStatus.success);

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
      {
        'height': 12344,
        'hash': '0x8ba1f109551bD432803012645Hac136c22C177e9',
        'transactions': 3,
        'timestamp': '2024-01-15 14:29:45',
        'miner': '0x9cb2f210662cE543904013756Ibd247d33D288f0',
        'gasUsed': 15750,
        'gasLimit': 8000000,
      },
      {
        'height': 12343,
        'hash': '0x9cb2f210662cE543904013756Ibd247d33D288f0',
        'transactions': 8,
        'timestamp': '2024-01-15 14:29:30',
        'miner': '0x742d35Cc6634C0532925a3b8D4C0532925a3b8D4',
        'gasUsed': 42000,
        'gasLimit': 8000000,
      },
    ],
    this.transactions = const [
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
      {
        'hash': '0x2b3c4d5e6f7a8901bcdef2345678901bcdef2345',
        'from': '0x8ba1f109551bD432803012645Hac136c22C177e9',
        'to': '0x9cb2f210662cE543904013756Ibd247d33D288f0',
        'value': '25.5 ATLAS',
        'gasPrice': '18 Gwei',
        'gasUsed': 21000,
        'status': 'Success',
        'blockNumber': 12344,
        'timestamp': '2024-01-15 14:29:45',
      },
    ],
  });
}

class ExplorerBloc extends Bloc<ExplorerEvent, ExplorerState> {
  ExplorerBloc() : super(ExplorerInitial()) {
    on<LoadRecentBlocks>((event, emit) {
      emit(ExplorerLoaded());
    });

    on<LoadRecentTransactions>((event, emit) {
      emit(ExplorerLoaded());
    });

    on<StartAutoRefresh>((event, emit) {
      // Auto refresh functionality - stub implementation
    });

    on<StopAutoRefresh>((event, emit) {
      // Stop auto refresh functionality - stub implementation
    });

    on<RefreshData>((event, emit) {
      emit(ExplorerLoading());
      // Simulate network delay
      Future.delayed(const Duration(milliseconds: 500), () {
        emit(ExplorerLoaded());
      });
    });
  }
}

// Health Stub
abstract class HealthEvent {}

class LoadHealthData extends HealthEvent {}

abstract class HealthState {}

class HealthInitial extends HealthState {}

class HealthLoading extends HealthState {}

class HealthLoaded extends HealthState {
  final String status;
  final double cpuUsage;
  final double memoryUsage;
  final double diskUsage;
  final double networkLatency;
  final List<Map<String, dynamic>> alerts;
  final List<Map<String, dynamic>> healthChecks;
  final Map<String, dynamic> systemMetrics;

  HealthLoaded({
    this.status = 'Healthy',
    this.cpuUsage = 45.2,
    this.memoryUsage = 67.8,
    this.diskUsage = 34.5,
    this.networkLatency = 12.3,
    this.alerts = const [
      {
        'type': 'info',
        'message': 'System running optimally',
        'timestamp': '2024-01-15 14:30:00',
      },
      {
        'type': 'warning',
        'message': 'Memory usage above 60%',
        'timestamp': '2024-01-15 14:25:00',
      },
    ],
    this.healthChecks = const [
      {
        'name': 'Database Connection',
        'status': 'Healthy',
        'responseTime': '5ms',
      },
      {'name': 'API Endpoints', 'status': 'Healthy', 'responseTime': '12ms'},
      {'name': 'Blockchain Sync', 'status': 'Healthy', 'responseTime': '8ms'},
      {'name': 'Storage Access', 'status': 'Warning', 'responseTime': '45ms'},
    ],
    this.systemMetrics = const {
      'uptime': '7 days, 14 hours',
      'totalRequests': 145678,
      'errorRate': 0.02,
      'avgResponseTime': 15.7,
      'activeConnections': 234,
    },
  });
}

class HealthBloc extends Bloc<HealthEvent, HealthState> {
  HealthBloc() : super(HealthInitial()) {
    on<LoadHealthData>((event, emit) {
      emit(HealthLoaded());
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
  final List<Map<String, dynamic>> validators;
  final Map<String, dynamic> nodeMetrics;

  NodeDashboardLoaded({
    this.connectedPeers = 8,
    this.nodeStatus = 'Running',
    this.syncProgress = 100.0,
    this.networkStats = const {
      'totalNodes': 156,
      'activeValidators': 45,
      'networkHashrate': '2.5 TH/s',
      'blockTime': '12.3s',
      'difficulty': 'High',
      'chainHeight': 12345,
    },
    this.validators = const [
      {
        'address': '0x742d35Cc6634C0532925a3b8D4C0532925a3b8D4',
        'stake': 10000.0,
        'status': 'Active',
        'uptime': 99.8,
        'rewards': 125.5,
      },
      {
        'address': '0x8ba1f109551bD432803012645Hac136c22C177e9',
        'stake': 8500.0,
        'status': 'Active',
        'uptime': 98.2,
        'rewards': 98.7,
      },
    ],
    this.nodeMetrics = const {
      'cpuUsage': 34.2,
      'memoryUsage': 56.8,
      'diskUsage': 23.1,
      'networkIn': '1.2 MB/s',
      'networkOut': '0.8 MB/s',
      'blocksProcessed': 12345,
      'transactionsProcessed': 45678,
    },
  });
}

class NodeDashboardBloc extends Bloc<NodeDashboardEvent, NodeDashboardState> {
  NodeDashboardBloc() : super(NodeDashboardInitial()) {
    on<LoadNodeData>((event, emit) {
      emit(NodeDashboardLoaded());
    });
  }
}

// Governance Stub
abstract class GovernanceEvent {}

class LoadProposals extends GovernanceEvent {}

abstract class GovernanceState {}

class GovernanceInitial extends GovernanceState {}

class GovernanceLoading extends GovernanceState {}

class GovernanceLoaded extends GovernanceState {
  final List<Map<String, dynamic>> proposals;
  final Map<String, dynamic> treasuryInfo;
  final Map<String, dynamic> governanceStats;

  GovernanceLoaded({
    this.proposals = const [
      {
        'id': 1,
        'title': 'Protocol Upgrade v2.1',
        'description': 'Implement sharding and improve transaction throughput',
        'status': 'Active',
        'votesFor': 15420,
        'votesAgainst': 3280,
        'totalVotes': 18700,
        'endDate': '2024-01-20',
        'proposer': '0x742d35Cc6634C0532925a3b8D4C0532925a3b8D4',
      },
      {
        'id': 2,
        'title': 'Treasury Allocation Q1 2024',
        'description': 'Allocate 500,000 ATLAS for development and marketing',
        'status': 'Pending',
        'votesFor': 8950,
        'votesAgainst': 1200,
        'totalVotes': 10150,
        'endDate': '2024-01-25',
        'proposer': '0x8ba1f109551bD432803012645Hac136c22C177e9',
      },
      {
        'id': 3,
        'title': 'Validator Reward Adjustment',
        'description':
            'Increase validator rewards by 15% to improve network security',
        'status': 'Draft',
        'votesFor': 0,
        'votesAgainst': 0,
        'totalVotes': 0,
        'endDate': '2024-02-01',
        'proposer': '0x9cb2f210662cE543904013756Ibd247d33D288f0',
      },
    ],
    this.treasuryInfo = const {
      'totalBalance': 2500000.0,
      'availableBalance': 1800000.0,
      'allocatedFunds': 700000.0,
      'monthlyBurn': 45000.0,
      'proposalsActive': 2,
      'proposalsPending': 5,
    },
    this.governanceStats = const {
      'totalVoters': 1250,
      'activeProposals': 2,
      'passedProposals': 18,
      'rejectedProposals': 3,
      'participationRate': 67.8,
      'quorumThreshold': 15.0,
    },
  });
}

class GovernanceBloc extends Bloc<GovernanceEvent, GovernanceState> {
  GovernanceBloc() : super(GovernanceInitial()) {
    on<LoadProposals>((event, emit) {
      emit(GovernanceLoaded());
    });
  }
}

// Contracts Stub
abstract class ContractsEvent {}

class LoadContracts extends ContractsEvent {}

abstract class ContractsState {}

class ContractsInitial extends ContractsState {}

class ContractsLoading extends ContractsState {}

class ContractsLoaded extends ContractsState {
  final List<Map<String, dynamic>> contracts;
  final List<Map<String, dynamic>> contractExamples;

  ContractsLoaded({
    this.contracts = const [
      {
        'address': '0x742d35Cc6634C0532925a3b8D4C0532925a3b8D4',
        'name': 'ATLAS Token',
        'type': 'ERC20',
        'status': 'Verified',
        'transactions': 15420,
        'balance': '1,000,000 ATLAS',
        'creator': '0x8ba1f109551bD432803012645Hac136c22C177e9',
        'deployedAt': '2024-01-10 12:00:00',
      },
      {
        'address': '0x8ba1f109551bD432803012645Hac136c22C177e9',
        'name': 'ATLAS NFT Collection',
        'type': 'ERC721',
        'status': 'Verified',
        'transactions': 3280,
        'balance': '500 NFTs',
        'creator': '0x9cb2f210662cE543904013756Ibd247d33D288f0',
        'deployedAt': '2024-01-12 15:30:00',
      },
      {
        'address': '0x9cb2f210662cE543904013756Ibd247d33D288f0',
        'name': 'Staking Pool',
        'type': 'Custom',
        'status': 'Active',
        'transactions': 8950,
        'balance': '250,000 ATLAS',
        'creator': '0x742d35Cc6634C0532925a3b8D4C0532925a3b8D4',
        'deployedAt': '2024-01-08 09:15:00',
      },
    ],
    this.contractExamples = const [
      {
        'name': 'Simple Token',
        'description': 'Basic ERC20 token implementation',
        'difficulty': 'Beginner',
        'gasEstimate': '1,200,000',
        'category': 'Token',
      },
      {
        'name': 'NFT Marketplace',
        'description': 'Complete NFT trading platform',
        'difficulty': 'Advanced',
        'gasEstimate': '3,500,000',
        'category': 'Marketplace',
      },
      {
        'name': 'Voting Contract',
        'description': 'Decentralized voting system',
        'difficulty': 'Intermediate',
        'gasEstimate': '2,100,000',
        'category': 'Governance',
      },
    ],
  });
}

class ContractsBloc extends Bloc<ContractsEvent, ContractsState> {
  ContractsBloc() : super(ContractsInitial()) {
    on<LoadContracts>((event, emit) {
      emit(ContractsLoaded());
    });
  }
}

// Social Stub
abstract class SocialEvent {}

class LoadSocialFeed extends SocialEvent {}

abstract class SocialState {}

class SocialInitial extends SocialState {}

class SocialLoading extends SocialState {}

class SocialLoaded extends SocialState {
  final List<Map<String, dynamic>> posts;
  final List<Map<String, dynamic>> trendingTopics;
  final List<Map<String, dynamic>> suggestedUsers;

  SocialLoaded({
    this.posts = const [
      {
        'id': 1,
        'author': 'Alice Chen',
        'username': '@alice_dev',
        'avatar': '👩‍💻',
        'content':
            'Just deployed my first smart contract on ATLAS! The developer experience is amazing 🚀',
        'likes': 45,
        'comments': 12,
        'shares': 8,
        'timestamp': '2 hours ago',
        'verified': true,
      },
      {
        'id': 2,
        'author': 'Bob Martinez',
        'username': '@bob_trader',
        'avatar': '👨‍💼',
        'content':
            'ATLAS DeFi yields are looking great! Just staked 1000 tokens at 12.5% APY 💰',
        'likes': 32,
        'comments': 7,
        'shares': 15,
        'timestamp': '4 hours ago',
        'verified': false,
      },
      {
        'id': 3,
        'author': 'Carol Kim',
        'username': '@carol_validator',
        'avatar': '🛡️',
        'content':
            'Node uptime: 99.8%! Proud to be securing the ATLAS network as a validator ⚡',
        'likes': 67,
        'comments': 23,
        'shares': 11,
        'timestamp': '6 hours ago',
        'verified': true,
      },
    ],
    this.trendingTopics = const [
      {'tag': '#ATLASStaking', 'posts': 156, 'growth': '+23%'},
      {'tag': '#DeFiYield', 'posts': 89, 'growth': '+45%'},
      {'tag': '#SmartContracts', 'posts': 67, 'growth': '+12%'},
      {'tag': '#Governance', 'posts': 34, 'growth': '+67%'},
    ],
    this.suggestedUsers = const [
      {
        'name': 'David Wilson',
        'username': '@david_core',
        'avatar': '⚙️',
        'followers': 1250,
        'bio': 'Core developer at ATLAS',
        'verified': true,
      },
      {
        'name': 'Emma Thompson',
        'username': '@emma_defi',
        'avatar': '💎',
        'followers': 890,
        'bio': 'DeFi researcher and yield farmer',
        'verified': false,
      },
    ],
  });
}

class SocialBloc extends Bloc<SocialEvent, SocialState> {
  SocialBloc() : super(SocialInitial()) {
    on<LoadSocialFeed>((event, emit) {
      emit(SocialLoaded());
    });
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
  final List<Map<String, dynamic>> recentActivity;
  final Map<String, dynamic> networkOverview;

  DashboardLoaded({
    this.stats = const {
      'totalTransactions': 145678,
      'activeNodes': 156,
      'networkHealth': 'Excellent',
      'totalValue': 2450.75,
      'stakingRewards': 125.50,
      'governanceProposals': 3,
    },
    this.recentActivity = const [
      {
        'type': 'transaction',
        'description': 'Sent 50 ATLAS',
        'timestamp': '2 minutes ago',
        'status': 'completed',
      },
      {
        'type': 'staking',
        'description': 'Received staking rewards',
        'timestamp': '1 hour ago',
        'status': 'completed',
      },
      {
        'type': 'governance',
        'description': 'Voted on proposal #1',
        'timestamp': '3 hours ago',
        'status': 'recorded',
      },
    ],
    this.networkOverview = const {
      'blockHeight': 12345,
      'hashRate': '2.5 TH/s',
      'difficulty': 'High',
      'avgBlockTime': '12.3s',
      'totalSupply': '10,000,000 ATLAS',
      'circulatingSupply': '7,500,000 ATLAS',
    },
  });
}

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<LoadDashboard>((event, emit) {
      emit(DashboardLoaded());
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

class SwapTokens extends WalletEvent {
  final String fromToken;
  final String toToken;
  final double amount;
  SwapTokens({
    required this.fromToken,
    required this.toToken,
    required this.amount,
  });
}

class StakeTokens extends WalletEvent {
  final double amount;
  final String validator;
  StakeTokens({required this.amount, required this.validator});
}

class ImportToken extends WalletEvent {
  final String contractAddress;
  ImportToken({required this.contractAddress});
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
  final List<Map<String, dynamic>> tokens;
  final List<Map<String, dynamic>> nfts;
  final Map<String, dynamic> portfolio;

  WalletLoaded({
    this.balance = 1000.0,
    this.address = '0x742d35Cc6634C0532925a3b8D4C0532925a3b8D4',
    this.selectedAccountIndex = 0,
    this.accounts = const [
      {
        'name': 'Main Account',
        'balance': 1000.0,
        'address': '0x742d35Cc6634C0532925a3b8D4C0532925a3b8D4',
        'type': 'Primary',
      },
      {
        'name': 'Trading Account',
        'balance': 250.0,
        'address': '0x8ba1f109551bD432803012645Hac136c22C177e9',
        'type': 'Trading',
      },
      {
        'name': 'Savings Account',
        'balance': 500.0,
        'address': '0x9cb2f210662cE543904013756Ibd247d33D288f0',
        'type': 'Savings',
      },
    ],
    this.transactions = const [
      {
        'from': '0x742d35Cc6634C0532925a3b8D4C0532925a3b8D4',
        'to': '0x8ba1f109551bD432803012645Hac136c22C177e9',
        'amount': 50.0,
        'message': 'Payment for services',
        'timestamp': '2024-01-15 14:30:00',
        'hash': '0x1a2b3c4d5e6f7890abcdef1234567890abcdef12',
        'status': 'Confirmed',
        'gasUsed': 21000,
        'gasPrice': '20 Gwei',
        'type': 'Send',
      },
      {
        'from': '0x8ba1f109551bD432803012645Hac136c22C177e9',
        'to': '0x742d35Cc6634C0532925a3b8D4C0532925a3b8D4',
        'amount': 100.0,
        'message': 'Refund',
        'timestamp': '2024-01-14 09:15:00',
        'hash': '0x2b3c4d5e6f7a8901bcdef2345678901bcdef2345',
        'status': 'Confirmed',
        'gasUsed': 21000,
        'gasPrice': '18 Gwei',
        'type': 'Receive',
      },
      {
        'from': '0x742d35Cc6634C0532925a3b8D4C0532925a3b8D4',
        'to': '0x9cb2f210662cE543904013756Ibd247d33D288f0',
        'amount': 25.0,
        'message': 'Test transaction',
        'timestamp': '2024-01-13 16:45:00',
        'hash': '0x3c4d5e6f7a8b9012cdef3456789012cdef345678',
        'status': 'Confirmed',
        'gasUsed': 21000,
        'gasPrice': '22 Gwei',
        'type': 'Send',
      },
    ],
    this.tokens = const [
      {
        'symbol': 'ATLAS',
        'name': 'ATLAS Token',
        'balance': 1000.0,
        'value': 1000.0,
        'price': 1.0,
        'change24h': 5.2,
        'address': '0x742d35Cc6634C0532925a3b8D4C0532925a3b8D4',
      },
      {
        'symbol': 'ETH',
        'name': 'Ethereum',
        'balance': 0.5,
        'value': 950.0,
        'price': 1900.0,
        'change24h': -2.1,
        'address': '0x0000000000000000000000000000000000000000',
      },
      {
        'symbol': 'USDC',
        'name': 'USD Coin',
        'balance': 500.0,
        'value': 500.0,
        'price': 1.0,
        'change24h': 0.0,
        'address': '0xa0b86a33e6776e681c6c7b6c6c7b6c6c7b6c6c7b',
      },
    ],
    this.nfts = const [
      {
        'id': 1,
        'name': 'ATLAS Genesis #001',
        'collection': 'ATLAS Genesis',
        'image': '🎨',
        'rarity': 'Legendary',
        'value': 2.5,
        'contractAddress': '0x8ba1f109551bD432803012645Hac136c22C177e9',
      },
      {
        'id': 2,
        'name': 'Validator Badge #156',
        'collection': 'Validator Badges',
        'image': '🛡️',
        'rarity': 'Rare',
        'value': 0.8,
        'contractAddress': '0x9cb2f210662cE543904013756Ibd247d33D288f0',
      },
    ],
    this.portfolio = const {
      'totalValue': 2450.75,
      'change24h': 3.2,
      'changePercent24h': 2.1,
      'allocation': {'ATLAS': 40.8, 'ETH': 38.8, 'USDC': 20.4},
    },
  });
}

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc() : super(WalletInitial()) {
    on<LoadWallet>((event, emit) {
      emit(WalletLoaded());
    });

    on<SendTransaction>((event, emit) {
      emit(WalletActionSuccess('Transaction sent successfully!'));
      // Reload wallet with updated balance
      emit(WalletLoaded(balance: 950.0)); // Simulate balance decrease
    });

    on<RequestTestTokens>((event, emit) {
      emit(WalletActionSuccess('Test tokens received!'));
      emit(WalletLoaded(balance: 1100.0)); // Simulate balance increase
    });

    on<SelectAccount>((event, emit) {
      emit(WalletLoaded()); // Reload with selected account
    });

    on<CreateAccount>((event, emit) {
      emit(
        WalletActionSuccess('Account "${event.name}" created successfully!'),
      );
      emit(WalletLoaded()); // Reload with new account
    });

    on<SwapTokens>((event, emit) {
      emit(
        WalletActionSuccess(
          'Swapped ${event.amount} ${event.fromToken} for ${event.toToken}',
        ),
      );
      emit(WalletLoaded()); // Reload with updated balances
    });

    on<StakeTokens>((event, emit) {
      emit(
        WalletActionSuccess(
          'Staked ${event.amount} ATLAS with ${event.validator}',
        ),
      );
      emit(WalletLoaded()); // Reload with updated balance
    });

    on<ImportToken>((event, emit) {
      emit(WalletActionSuccess('Token imported successfully!'));
      emit(WalletLoaded()); // Reload with new token
    });
  }
}
