# Flutter UI Translation Design Document

## Overview

This document outlines the design for translating the existing ATLAS Blockchain web frontend to a native Flutter mobile application. The web frontend consists of 14 HTML pages with comprehensive blockchain functionality including dashboard, wallet management, DeFi features, explorer, governance, and more.

### Project Scope
- **Source**: Web-based blockchain dashboard (HTML/CSS/JavaScript)
- **Target**: Cross-platform Flutter mobile application  
- **Platform Support**: iOS and Android
- **Architecture**: Clean Architecture with BLoC pattern

## Technology Stack & Dependencies

### Core Flutter Dependencies
```yaml
dependencies:
  flutter: sdk: flutter
  cupertino_icons: ^1.0.2
  
  # State Management
  flutter_bloc: ^8.1.3
  bloc: ^8.1.2
  equatable: ^2.0.5
  
  # HTTP & API
  http: ^1.1.0
  dio: ^5.3.2
  
  # Local Storage
  shared_preferences: ^2.2.2
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # Crypto & Security
  crypto: ^3.0.3
  pointycastle: ^3.7.3
  convert: ^3.1.1
  
  # UI Components
  flutter_svg: ^2.0.7
  lottie: ^2.6.0
  shimmer: ^3.0.0
  
  # Navigation
  go_router: ^10.1.2
  
  # Utilities
  logger: ^2.0.2
  intl: ^0.18.1
```

### Development Dependencies
```yaml
dev_dependencies:
  flutter_test: sdk: flutter
  mockito: ^5.4.2
  bloc_test: ^9.1.4
  build_runner: ^2.4.6
  hive_generator: ^2.0.1
  json_annotation: ^4.8.1
  json_serializable: ^6.7.1
```

## Component Architecture

### Application Structure
```
lib/
├── core/
│   ├── constants/
│   ├── errors/
│   ├── network/
│   ├── storage/
│   └── utils/
├── features/
│   ├── dashboard/
│   ├── wallet/
│   ├── explorer/
│   ├── defi/
│   ├── governance/
│   ├── identity/
│   ├── social/
│   ├── contracts/
│   └── node_management/
├── shared/
│   ├── widgets/
│   ├── themes/
│   └── services/
└── main.dart
```

### Component Hierarchy

#### Main Navigation Structure
```
MaterialApp
├── AppRouter (GoRouter)
├── BlocProviders
│   ├── WalletBloc
│   ├── BlockchainBloc
│   ├── DeFiBloc
│   └── NetworkBloc
└── MainScaffold
    ├── BottomNavigationBar
    └── PageView
        ├── DashboardPage
        ├── WalletPage
        ├── ExplorerPage
        ├── DeFiPage
        └── MorePage
```

#### Dashboard Component Tree
```
DashboardPage
├── AppBar
│   ├── NetworkSelector
│   └── NotificationIcon
├── RefreshIndicator
└── ScrollView
    ├── WalletOverviewCard
    ├── NetworkStatsGrid
    ├── RecentTransactionsList
    ├── BlockchainDataTable
    └── QuickActionsGrid
```

#### Wallet Component Tree
```
WalletPage
├── WalletHeader
│   ├── BalanceDisplay
│   ├── AddressDisplay
│   └── QRCodeButton
├── WalletActions
│   ├── SendButton
│   ├── ReceiveButton
│   ├── StakeButton
│   └── SwapButton
├── TransactionHistory
└── WalletSettings
```

## Routing & Navigation

### Route Configuration
```dart
final GoRouter appRouter = GoRouter(
  initialLocation: '/dashboard',
  routes: [
    GoRoute(
      path: '/dashboard',
      name: 'dashboard',
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
      path: '/wallet',
      name: 'wallet',
      builder: (context, state) => const WalletPage(),
      routes: [
        GoRoute(
          path: '/send',
          name: 'send',
          builder: (context, state) => const SendTransactionPage(),
        ),
        GoRoute(
          path: '/receive',
          name: 'receive', 
          builder: (context, state) => const ReceivePage(),
        ),
      ],
    ),
    GoRoute(
      path: '/explorer',
      name: 'explorer',
      builder: (context, state) => const ExplorerPage(),
      routes: [
        GoRoute(
          path: '/block/:hash',
          name: 'blockDetail',
          builder: (context, state) => BlockDetailPage(
            blockHash: state.pathParameters['hash']!,
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/defi',
      name: 'defi',
      builder: (context, state) => const DeFiPage(),
    ),
    GoRoute(
      path: '/governance',
      name: 'governance',
      builder: (context, state) => const GovernancePage(),
    ),
  ],
);
```

### Navigation Patterns
- **Bottom Navigation**: Primary navigation between main sections
- **Tab Navigation**: Within DeFi section (Trading, Staking, Liquidity)
- **Stack Navigation**: Detail pages and modal screens
- **Drawer Navigation**: Settings and secondary features

## Styling Strategy

### Design System Foundation
```dart
// Color Palette (matching web theme)
class AppColors {
  static const Color primary = Color(0xFF4299E1);
  static const Color secondary = Color(0xFF48BB78);
  static const Color tertiary = Color(0xFF9F7AEA);
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFE53E3E);
  static const Color warning = Color(0xFFED8936);
  static const Color success = Color(0xFF38A169);
  
  // Gradient definitions
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4299E1), Color(0xFF3182CE)],
  );
}

// Typography Scale
class AppTextStyles {
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.02,
  );
  
  static const TextStyle h2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.01,
  );
  
  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.01,
  );
}

// Spacing System
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}
```

### Component Styling Patterns
- **Glass Morphism Cards**: Matching web's backdrop-blur effect
- **Gradient Backgrounds**: Translating CSS gradients to Flutter
- **Elevation System**: Using Material Design shadows
- **Border Radius**: Consistent rounded corners (8dp, 12dp, 16dp, 20dp)

## State Management

### BLoC Architecture Pattern
```
Feature/
├── bloc/
│   ├── feature_bloc.dart
│   ├── feature_event.dart
│   ├── feature_state.dart
│   └── feature_repository.dart
├── data/
│   ├── models/
│   ├── datasources/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── pages/
    ├── widgets/
    └── bloc/
```

### Core State Management
```dart
// Wallet State Management
class WalletState extends Equatable {
  final String? address;
  final double balance;
  final bool isLoading;
  final String? errorMessage;
  final List<Transaction> transactions;
  
  const WalletState({
    this.address,
    this.balance = 0.0,
    this.isLoading = false,
    this.errorMessage,
    this.transactions = const [],
  });
}

// Blockchain State Management  
class BlockchainState extends Equatable {
  final List<Block> blocks;
  final NetworkStats networkStats;
  final bool isLoading;
  final String? errorMessage;
  final int blockCount;
  final int transactionCount;
  
  const BlockchainState({
    this.blocks = const [],
    this.networkStats = const NetworkStats(),
    this.isLoading = false,
    this.errorMessage,
    this.blockCount = 0,
    this.transactionCount = 0,
  });
}
```

### Global State Providers
- **WalletBloc**: Wallet management, balance, transactions
- **BlockchainBloc**: Block data, network statistics
- **DeFiBloc**: Trading, staking, liquidity pools
- **NetworkBloc**: Node selection, connectivity status
- **ThemeBloc**: Dark/light mode, accessibility settings

## API Integration Layer

### HTTP Client Configuration
```dart
class ApiClient {
  late final Dio _dio;
  
  ApiClient({required String baseUrl}) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    
    _dio.interceptors.addAll([
      LogInterceptor(),
      ErrorInterceptor(),
      AuthInterceptor(),
    ]);
  }
}
```

### API Service Layer
```dart
abstract class BlockchainApiService {
  Future<List<Block>> getBlocks({int limit = 10});
  Future<Block> getBlockByHash(String hash);
  Future<double> getBalance(String address);
  Future<List<Transaction>> getTransactions(String address);
  Future<String> sendTransaction(Transaction transaction);
  Future<NetworkStats> getNetworkStats();
  Future<List<String>> getPeers();
}

abstract class DeFiApiService {
  Future<List<TradingPair>> getTradingPairs();
  Future<StakingInfo> getStakingInfo(String address);
  Future<List<LiquidityPool>> getLiquidityPools();
  Future<YieldFarmInfo> getYieldFarmInfo();
}
```

### Data Models
```dart
@JsonSerializable()
class Block {
  final int index;
  final String hash;
  final String previousHash;
  final List<Transaction> transactions;
  final int timestamp;
  final int nonce;
  
  Block({
    required this.index,
    required this.hash,
    required this.previousHash,
    required this.transactions,
    required this.timestamp,
    required this.nonce,
  });
}

@JsonSerializable()
class Transaction {
  final String sender;
  final String recipient;
  final double amount;
  final double fee;
  final String signature;
  final int timestamp;
  final String? data;
  
  Transaction({
    required this.sender,
    required this.recipient,
    required this.amount,
    required this.fee,
    required this.signature,
    required this.timestamp,
    this.data,
  });
}
```

## Crypto & Security Implementation

### Wallet Key Management
```dart
class WalletService {
  static const String _walletPrivKey = 'wallet_private_key';
  static const String _walletPubKey = 'wallet_public_key';
  
  Future<ECKeyPair> generateWallet() async {
    final keyGen = ECKeyGenerator();
    final secureRandom = FortunaRandom();
    
    keyGen.init(ParametersWithRandom(
      ECKeyGeneratorParameters(ECCurve_secp256r1()),
      secureRandom,
    ));
    
    final keyPair = keyGen.generateKeyPair();
    await _saveWalletLocally(keyPair);
    return keyPair;
  }
  
  Future<String> signTransaction(Transaction transaction) async {
    final keyPair = await _loadWalletFromStorage();
    final privateKey = keyPair.privateKey as ECPrivateKey;
    
    final signer = ECDSASigner(SHA256Digest());
    signer.init(true, PrivateKeyParameter(privateKey));
    
    final message = _buildTransactionMessage(transaction);
    final signature = signer.generateSignature(message);
    
    return _formatSignature(signature);
  }
}
```

### Secure Storage Implementation
```dart
class SecureStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: IOSAccessibility.first_unlock_this_device,
    ),
  );
  
  Future<void> storeWalletKeys(String privateKey, String publicKey) async {
    await _storage.write(key: 'private_key', value: privateKey);
    await _storage.write(key: 'public_key', value: publicKey);
  }
  
  Future<Map<String, String?>> getWalletKeys() async {
    final privateKey = await _storage.read(key: 'private_key');
    final publicKey = await _storage.read(key: 'public_key');
    return {'private': privateKey, 'public': publicKey};
  }
}
```

## Feature Translation Matrix

### Dashboard Page Translation
| Web Component | Flutter Widget | Description |
|---------------|----------------|-------------|
| `.header h1` | `AppBar.title` | Gradient text header |
| `.nav-bar` | `Card` + `Row` | Navigation buttons container |
| `.nav-card` | `GestureDetector` + `Card` | Feature cards with hover effects |
| CSS Gradients | `LinearGradient` | Background gradients |
| CSS Animations | `AnimatedContainer` | Hover and transition effects |

### Wallet Page Translation
| Web Component | Flutter Widget | Description |
|---------------|----------------|-------------|
| `.wallet-info` | `Container` + `LinearGradient` | Balance display card |
| `.address-display` | `Text` + `monospace` | Wallet address with copy button |
| `.wallet-actions` | `GridView` | Action buttons grid |
| `.transaction-form` | `Form` + `TextFormField` | Send transaction form |
| Transaction History | `ListView.builder` | Scrollable transaction list |

### Explorer Page Translation  
| Web Component | Flutter Widget | Description |
|---------------|----------------|-------------|
| `.search-bar` | `TextField` + `SearchDelegate` | Block/transaction search |
| `.block-list` | `ListView.separated` | Block listing with dividers |
| `.block-item` | `ListTile` + `Card` | Individual block display |
| Hash display | `Text` + `overflow: ellipsis` | Truncated hash with tooltip |

### DeFi Page Translation
| Web Component | Flutter Widget | Description |
|---------------|----------------|-------------|
| `.defi-layout` | `Row` + `Expanded` | Sidebar + main content |
| `.nav-menu` | `NavigationRail` / `Drawer` | Feature navigation |
| `.portfolio-summary` | `Card` + `Column` | Portfolio overview |
| Trading pairs | `DataTable` / `ListView` | Token pair listings |
| Charts (if added) | `fl_chart` package | Price/volume charts |

## Testing Strategy

### Unit Testing Approach
```dart
// BLoC Testing Example
void main() {
  group('WalletBloc', () {
    late WalletBloc walletBloc;
    late MockWalletRepository mockRepository;
    
    setUp(() {
      mockRepository = MockWalletRepository();
      walletBloc = WalletBloc(repository: mockRepository);
    });
    
    blocTest<WalletBloc, WalletState>(
      'emits [loading, success] when GenerateWallet is added',
      build: () => walletBloc,
      act: (bloc) => bloc.add(const GenerateWallet()),
      expect: () => [
        const WalletState(isLoading: true),
        const WalletState(
          isLoading: false,
          address: 'test_address',
          balance: 0.0,
        ),
      ],
    );
  });
}
```

### Widget Testing Coverage
- **Dashboard Components**: Network stats, recent transactions
- **Wallet Components**: Balance display, transaction forms
- **Explorer Components**: Block list, search functionality
- **DeFi Components**: Trading interface, staking forms

### Integration Testing
- **API Integration**: Mock server responses
- **Navigation Flow**: Complete user journeys
- **State Persistence**: Local storage functionality
- **Crypto Operations**: Wallet generation and signing

## Performance Optimization

### Rendering Performance
- **List Virtualization**: `ListView.builder` for large datasets
- **Image Caching**: `CachedNetworkImage` for network assets
- **State Optimization**: `Equatable` for efficient rebuilds
- **Lazy Loading**: Pagination for blockchain data

### Memory Management
- **Stream Subscriptions**: Proper disposal in BLoC
- **Large Lists**: `AutomaticKeepAliveClientMixin` for tabs
- **Image Memory**: Size constraints and compression

### Network Optimization
- **Request Caching**: Dio interceptors for API caching
- **Batch Operations**: Combine multiple API calls
- **Connection Pooling**: Reuse HTTP connections
- **Offline Support**: Hive for local data persistence

## Accessibility & Internationalization

### Accessibility Features
- **Semantic Labels**: Screen reader support
- **High Contrast**: Accessible color combinations
- **Text Scaling**: Dynamic type support
- **Focus Management**: Keyboard navigation

### Internationalization Support
```dart
// Generated localization files
class AppLocalizations {
  static const String walletBalance = 'wallet_balance';
  static const String sendTransaction = 'send_transaction';
  static const String recentTransactions = 'recent_transactions';
  // ... more translations
}
```

### Supported Locales
- English (en)
- Spanish (es) 
- French (fr)
- German (de)
- Chinese Simplified (zh-CN)
- Japanese (ja)

## Migration Strategy

### Phase 1: Core Infrastructure (Week 1-2)
- Set up Flutter project structure
- Implement basic navigation
- Create design system (colors, typography, spacing)
- Implement core BLoC architecture

### Phase 2: Essential Features (Week 3-4)
- Dashboard with basic blockchain data
- Wallet functionality (generate, import, view balance)
- Basic transaction sending/receiving
- Explorer with block/transaction viewing

### Phase 3: Advanced Features (Week 5-6)
- DeFi integration (trading, staking)
- Governance features
- Identity management
- Social features

### Phase 4: Polish & Testing (Week 7-8)
- Comprehensive testing suite
- Performance optimization
- Accessibility improvements
- Final UI/UX refinements

### Data Migration Approach
- **Local Storage**: Migrate from localStorage to Hive/SharedPreferences
- **Wallet Keys**: Secure migration to FlutterSecureStorage
- **API Compatibility**: Maintain compatibility with existing backend
- **Progressive Enhancement**: Gradual feature rollout