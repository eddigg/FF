# ATLAS Blockchain Flutter App

A complete Flutter mobile application that translates the ATLAS Blockchain web frontend into a native mobile experience. This app provides all the functionality of the web dashboard in an optimized mobile interface.

## 🌟 Features

### 📱 Core Pages Translated from Web Frontend

- **Dashboard** (`index.html` → `DashboardPage`)
  - Network statistics display
  - Quick action navigation cards
  - Real-time blockchain data
  - Glass morphism design matching web

- **Wallet Management** (`wallet.html` → `WalletPage`)
  - Wallet generation and management
  - Balance display with gradient styling
  - Transaction sending interface
  - Transaction history
  - Address display with copy functionality

- **Blockchain Explorer** (`explorer.html` → `ExplorerPage`)
  - Block exploration and search
  - Transaction browsing
  - Real-time network data
  - Hash lookup functionality

- **DeFi Platform** (`defi.html` → `DeFiPage`)
  - Portfolio overview
  - Trading pairs interface
  - Staking pools
  - Liquidity pools
  - Yield farming sections
  - Navigation sidebar matching web layout

- **Governance** (`governance.html` → `GovernancePage`)
  - Proposal voting interface
  - Active proposals display
  - Voting statistics
  - Governance participation

### 🎨 Design System

- **Color Palette**: Exact translation of web CSS colors
- **Typography**: Inter font family with matching weights
- **Animations**: CSS transition equivalents in Flutter
- **Glass Morphism**: Backdrop blur effects translated to Flutter
- **Gradients**: Linear gradients matching web design
- **Shadows**: Box shadow system equivalent

### 🏗️ Architecture

- **Clean Architecture**: Feature-based modular structure
- **BLoC Pattern**: State management with reactive programming
- **Go Router**: Declarative navigation system
- **Dependency Injection**: Service locator pattern
- **Local Storage**: Hive for offline data persistence

## 📁 Project Structure

```
lib/
├── core/                           # Core infrastructure
│   ├── constants/                  # App constants
│   ├── errors/                     # Error handling
│   ├── network/                    # API client setup
│   ├── storage/                    # Local storage
│   └── utils/                      # Utility functions
├── features/                       # Feature modules
│   ├── dashboard/                  # Dashboard feature
│   │   ├── data/                   # Data layer
│   │   ├── domain/                 # Domain layer
│   │   └── presentation/           # Presentation layer
│   │       ├── bloc/               # BLoC state management
│   │       ├── pages/              # Page widgets
│   │       └── widgets/            # Feature widgets
│   ├── wallet/                     # Wallet management
│   ├── explorer/                   # Blockchain explorer
│   ├── defi/                       # DeFi platform
│   └── governance/                 # Governance voting
├── shared/                         # Shared components
│   ├── themes/                     # App theming
│   ├── widgets/                    # Reusable widgets
│   └── services/                   # Shared services
└── main.dart                       # App entry point
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   cd c:\Users\bryan\Desktop\FF\GOFLUTTER
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Configuration

1. **API Endpoint**: Update the base URL in `main.dart`
   ```dart
   ApiClient.initialize(baseUrl: 'http://localhost:8080');
   ```

2. **Assets**: Add font files to `assets/fonts/`
   - Inter-Regular.ttf
   - Inter-Medium.ttf
   - Inter-SemiBold.ttf
   - Inter-Bold.ttf
   - Inter-ExtraBold.ttf

## 🎯 Features Translated from Web

### CSS to Flutter Translation

| Web Component | Flutter Widget | Description |
|---------------|----------------|-------------|
| `.glass-card` | `GlassCard` | Glass morphism container with backdrop blur |
| `.nav-card` | `NavigationCard` | Feature navigation cards with hover effects |
| `.gradient-btn` | `GradientButton` | Gradient buttons with animations |
| `.wallet-info` | Container + LinearGradient | Wallet balance display |
| CSS Grid | `GridView` | Responsive grid layouts |
| CSS Flexbox | `Row`/`Column` | Flexible layouts |
| CSS Animations | `AnimatedContainer` | Hover and transition effects |

### State Management

- **Dashboard State**: Network stats, block data, transaction counts
- **Wallet State**: Balance, address, transaction history
- **Explorer State**: Block list, transaction list, search results
- **DeFi State**: Portfolio data, trading pairs, staking pools

### Navigation Structure

```
/ (Dashboard)
├── /wallet
│   ├── /send
│   ├── /receive
│   └── /setup
├── /explorer
│   ├── /block/:hash
│   └── /transaction/:hash
├── /defi
├── /governance
├── /contracts
├── /identity
├── /social
├── /health
└── /node-dashboard
```

## 🔧 Development

### Adding New Features

1. **Create Feature Module**
   ```bash
   mkdir -p lib/features/new_feature/{data,domain,presentation}/{models,repositories,entities,usecases,bloc,pages,widgets}
   ```

2. **Implement BLoC Pattern**
   - Create events, states, and bloc files
   - Add to main.dart providers

3. **Add Routes**
   - Update GoRouter configuration in main.dart

### Styling Guidelines

- Use `AppColors` for consistent color scheme
- Follow `AppTextStyles` for typography
- Apply `AppSpacing` for consistent spacing
- Use `GlassCard` for container components
- Implement `GradientButton` for actions

### Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/

# Generate coverage report
flutter test --coverage
```

## 📱 Platform Support

- ✅ **Android**: Full support with Material Design
- ✅ **iOS**: Full support with Cupertino elements
- 🚧 **Web**: Responsive web support (future)
- 🚧 **Desktop**: Desktop support (future)

## 🔮 Roadmap

### Phase 1: Core Translation ✅
- [x] Basic UI translation from web
- [x] Navigation setup
- [x] Theme system
- [x] State management structure

### Phase 2: Blockchain Integration 🚧
- [ ] API service implementation
- [ ] Real blockchain data integration
- [ ] Wallet cryptography
- [ ] Transaction signing

### Phase 3: Advanced Features 🚧
- [ ] Push notifications
- [ ] Biometric authentication
- [ ] Offline mode
- [ ] Deep linking
- [ ] Analytics integration

### Phase 4: Performance & Polish 🚧
- [ ] Performance optimization
- [ ] Animation refinements
- [ ] Accessibility improvements
- [ ] Testing coverage
- [ ] Documentation completion

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Original web frontend design from ATLAS Blockchain
- Flutter community for excellent packages
- Material Design guidelines
- Clean Architecture principles

---

**Built with ❤️ using Flutter**