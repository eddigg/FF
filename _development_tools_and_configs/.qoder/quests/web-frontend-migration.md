# Web Frontend Migration Specification

## Overview
This document outlines the specification for migrating the HTML/CSS/JavaScript frontend from ATLAS.BC0.0.1/web/frontend to a Flutter implementation within the GOFLUTTER project structure, maintaining feature parity while leveraging Flutter's cross-platform capabilities.

## Current State Analysis

### ATLAS.BC0.0.1/web/frontend
The current web frontend consists of:
- 14 HTML pages covering core blockchain functionality
- Common JavaScript utilities (common.js, main.js)
- Feature areas: Intro, Wallet, Wallet Setup, Explorer, DeFi, Governance, Identity, Social, Contracts, Health, Node Dashboard

### GOFLUTTER Structure
The target Flutter project follows:
- Feature-first organization with clean architecture
- Separation of data, domain, and presentation layers
- Core infrastructure modules (api, network, routing, storage)
- Shared components and themes

### Already Implemented Features
Several features have already been partially or fully implemented in GOFLUTTER:
- Intro page with carousel and feature cards
- Wallet setup with create/import functionality
- Basic wallet functionality with send/receive pages
- Routing for all major features
- Core BLoC state management for features
- Data models and repository patterns

However, many features still need enhancement to match the full functionality of the HTML implementation.

## GOFLUTTER Run Status

After analyzing the GOFLUTTER project structure and codebase, I've identified the following issues that need to be resolved to ensure the app can run properly:

1. **Missing Font Assets**: The app references Inter font family but the font files are missing from the assets directory. However, the pubspec.yaml does not contain font declarations, so this may not be an issue.
2. **Incomplete Feature Implementation**: Most features beyond basic wallet functionality are not fully implemented.
3. **API Integration**: The app has basic API client structure but needs full implementation of endpoints.
4. **Cryptography Implementation**: Wallet signing functionality needs to be implemented using Flutter-compatible libraries.
5. **JavaScript Functionality Migration**: Many functions from common.js and main.js need to be ported to Dart.

## Required Actions to Complete Migration and Ensure GOFLUTTER Runs

## Migration Specification

### 1. Feature Mapping
Each HTML page will be converted to a corresponding Flutter feature module:

| HTML File | Flutter Feature Module | Status | Priority |
|-----------|------------------------|--------|----------|
| index.html | features/dashboard | Partially implemented | High |
| intro.html | features/intro | Partially implemented | Medium |
| wallet.html | features/wallet | Partially implemented | High |
| wallet-setup.html | features/wallet_setup | Partially implemented | High |
| explorer.html | features/explorer | To implement | High |
| defi.html | features/defi | To implement | Medium |
| governance.html | features/governance | To implement | Medium |
| identity.html | features/identity | To implement | Low |
| social.html | features/social | To implement | Low |
| contracts.html | features/contracts | To implement | Medium |
| health.html | features/health | To implement | Medium |
| node-dashboard.html | features/node_dashboard | To implement | Medium |

Note: Some features already have basic implementations but require enhancement to match the full HTML functionality.

### 2. Implementation Approach

#### 2.1 Clean Architecture Layers
Each feature module will implement three layers:
- **Presentation**: UI components (widgets, pages, blocs)
- **Domain**: Business logic entities and repository interfaces
- **Data**: Repository implementations and data sources

#### 2.2 Data Models
Implement the following data models based on the HTML functionality:
- Block model with index, hash, timestamp, and transaction data
- Transaction model with sender, recipient, amount, fee, signature, and hash
- Wallet model with address, balance, and transaction history
- Node model with status, port, and peer information
- Proposal model for governance features (ID, title, description, status)
- Contract model for smart contract functionality
- User profile model for identity management
- Post/comment models for social features
- Health metrics model for system monitoring

#### 2.7 State Management
- Use BLoC pattern for state management as indicated in the GOFLUTTER structure
- Implement feature-specific blocs in each module's presentation/bloc directory

#### 2.3 API Integration
- Utilize existing core/api services for backend communication
- Extend blockchain_api_service.dart as needed for new endpoints
- Implement feature-specific data sources in data/data_sources/

#### 2.4 API Endpoint Implementation (High Priority)
The API client in `GOFLUTTER` must be updated to correctly implement and call the following endpoints from the `ATLAS.BC0.0.1` backend:
- `GET /balance?address=<string>`: Get wallet balance.
- `GET /mempool`: Get recent transactions.
- `GET /peers`: Get network peer information.
- `GET /blocks`: Get recent blocks.
- `GET /validator?address=<string>`: Get validator information.
- `POST /submit-transaction`: Submit a signed transaction.
- `GET /network/architecture`: Get network architecture data.
- `GET /status`: Get node status.
- `POST /faucet`: Request test tokens.

#### 2.8 JavaScript Functionality Migration
Convert the following JavaScript functionality from common.js and main.js to Dart services:
- Wallet generation and management functions
- Cryptographic signing functionality for transactions
- DER to RS signature conversion
- Array buffer to hex conversion
- Wallet address export and display
- Transaction signing with ECDSA
- Status message display functions
- Data fetching functions for wallet balance, transactions, network data, blockchain data, and validator info

#### 2.9 UI Component Conversion
- Translate HTML structure to Flutter widget trees
- Convert CSS styling to Flutter ThemeData and custom widgets
- Implement responsive design using Flutter layout widgets
- Enhance existing Flutter components to match HTML functionality
- Implement missing features that are present in HTML but not in Flutter

#### 2.10 Custom Widget Implementation
Create the following custom widgets to match the HTML design:
- Navigation cards with hover effects and gradient backgrounds
- Status indicators with animated dots
- Data display cards with consistent styling
- Form components with proper validation and error display
- Table components for blockchain data display
- Statistic display widgets for network metrics
- Loading indicators and empty state displays
- Gradient buttons with hover effects

### 3. Detailed Implementation Steps

#### 3.1 Project Setup
1. Ensure Flutter web support is configured
2. Verify core infrastructure components are available
3. Set up routing for all feature modules

#### 3.2 Feature Implementation Sequence
1. **Dashboard Feature**
   - Implement index.html functionality as the main dashboard
   - Create navigation hub with links to all features
   - Implement node status display with port selection
   - Add network architecture information display
   - Create real-time monitoring widgets

2. **Intro Feature**
   - Already partially implemented with carousel and feature cards
   - Enhance to match full functionality of intro.html
   - Add all feature descriptions and navigation links
   - Implement proper logout functionality

3. **Wallet Feature**
   - Enhance existing wallet_page.dart to match full wallet.html functionality
   - Implement complete transaction history display with proper formatting
   - Add wallet balance display with real-time updates
   - Implement full transaction sending capabilities with proper validation
   - Add wallet address display and copying functionality
   - Implement proper wallet loading and saving mechanisms
   - Add wallet generation and import functionality
   - Implement cryptographic signing for transactions
   - Add proper error handling and status messages
   - Create receive transaction functionality with QR code display

4. **Wallet Setup Feature**
   - Already implemented with create/import tabs
   - Enhance to match full functionality of wallet-setup.html
   - Add proper wallet generation and storage mechanisms
   - Implement secure key storage and retrieval
   - Add wallet import functionality with proper validation

5. **Explorer Feature**
   - Implement explorer.html functionality in explorer_page.dart
   - Create block/transaction explorer with search capabilities
   - Implement filtering by address, block number, or transaction hash
   - Add real-time blockchain data display

6. **DeFi Feature**
   - Convert defi.html to decentralized finance interface in defi_page.dart
   - Implement token swapping and staking UI
   - Add liquidity pool management
   - Create yield farming interfaces

7. **Governance Feature**
   - Migrate governance.html to proposal voting system in governance_page.dart
   - Implement proposal creation and management
   - Add voting mechanisms with proper validation
   - Create governance dashboard with proposal tracking

8. **Identity Feature**
   - Transform identity.html to identity management in identity_page.dart
   - Implement profile and verification flows
   - Add KYC and reputation management
   - Create privacy controls and settings

9. **Social Feature**
   - Convert social.html to social networking interface in social_page.dart
   - Implement post creation and feed display
   - Add commenting and reaction systems
   - Create user following and content sharing

10. **Contracts Feature**
    - Migrate contracts.html to smart contract interface in contracts_page.dart
    - Implement contract deployment and interaction
    - Add contract browsing and verification
    - Create contract testing interfaces

11. **Health Feature**
    - Transform health.html to system monitoring dashboard in health_page.dart
    - Implement metrics display and alerting
    - Add performance testing tools
    - Create system diagnostics and debugging interfaces

12. **Node Dashboard Feature**
    - Convert node-dashboard.html to node management in node_dashboard_page.dart
    - Implement node status and configuration
    - Add peer monitoring and management
    - Create validator performance tracking

### 4. Technical Requirements

#### 4.1 Code Standards
- Follow snake_case for files, PascalCase for classes, camelCase for variables/functions
- Implement proper documentation with doc comments for public APIs
- Maintain separation of concerns between UI and business logic

#### 4.2 Cryptographic Implementation
- Implement ECDSA key generation and management
- Add secure storage for private keys using flutter_secure_storage
- Implement transaction signing with proper DER to RS conversion
- Add cryptographic hash functions for data integrity
- Ensure all cryptographic operations are performed client-side for security

#### 4.3 Security Considerations
- Store private keys using flutter_secure_storage
- Sign transactions on the client device
- Use HTTPS for all API communications
- Implement token-based authentication

#### 4.6 Performance Optimization
- Optimize widget rendering and memory management
- Implement efficient network request handling
- Use appropriate caching mechanisms

#### 4.4 Port Selection Functionality
- Implement node port selection as shown in index.html
- Add localStorage persistence for selected port
- Create UI for switching between different node ports (8080, 8081, 8082, 8083)
- Add real-time node status updates based on selected port

#### 4.5 Network Architecture Display
- Implement network architecture information display
- Create cards for node types, P2P protocol, consensus mechanism, network topology, and security features
- Add real-time data fetching for network architecture information
- Implement hover effects and animations as shown in the HTML

#### 4.7 Testing Strategy
- Implement unit tests for business logic
- Create widget tests for UI components
- Develop integration tests for feature flows
- Add end-to-end tests for critical user journeys
- Implement snapshot tests for UI components
- Create performance tests for data-intensive features
- Add security tests for cryptographic functionality
- Implement cross-platform compatibility tests

### 5. Integration Points

#### 5.1 Core Services
- Extend api_client.dart for new API endpoints
- Utilize existing secure_storage.dart for credential management
- Integrate with app_router.dart for navigation

#### 5.2 Routing Enhancements
- Implement proper navigation from dashboard to all feature pages
- Add navigation guards for authentication protection
- Create deep linking for specific features
- Implement proper back navigation and routing history
- Add route parameters for detailed views (e.g., proposal details, contract details)

#### 5.3 Authentication Flow
- Implement proper authentication flow based on HTML navigation
- Add logout functionality from dashboard
- Create session management with automatic timeout
- Implement secure token storage and refresh
- Add guest access restrictions for protected features

#### 5.4 Shared Components
- Use shared/themes for consistent styling
- Leverage shared/widgets for common UI elements
- Implement new shared components as needed

### 6. Validation Criteria

#### 6.1 Feature Completeness
- All 14 feature areas implemented with equivalent functionality
- UI/UX matches or improves upon original HTML implementation
- All navigation paths functional
- All JavaScript functionality converted to Dart
- All API endpoints implemented and functional
- All data models properly implemented
- All custom widgets created with proper styling
- Port selection functionality working
- Network architecture display implemented
- Authentication flow fully functional

#### 6.2 Technical Compliance
- Follows clean architecture principles
- Implements proper state management with BLoC
- Maintains separation of data, domain, and presentation layers
- Implements all cryptographic functionality client-side
- Uses secure storage for sensitive data
- Follows proper error handling patterns
- Implements proper data validation
- Uses responsive design for all screen sizes
- Follows Flutter best practices and coding standards

#### 6.3 Quality Assurance
- Unit test coverage for business logic (minimum 80%)
- Widget test coverage for UI components (minimum 70%)
- Integration test coverage for critical flows (minimum 85%)
- Performance benchmarks met
- Security audit passed for cryptographic implementations
- Cross-platform compatibility verified
- Accessibility standards met
- Code review completed with no critical issues

### 7. Deployment Considerations

#### 7.1 Web Deployment
- Ensure Flutter web configuration is correct
- Verify all assets are properly declared in pubspec.yaml
- Test responsive design across different screen sizes
- Validate all navigation links work correctly
- Test port selection functionality
- Verify all API endpoints are accessible
- Confirm cryptographic functionality works in web environment

#### 7.2 Cross-Platform Compatibility
- Maintain compatibility with mobile platforms (iOS, Android)
- Ensure consistent behavior across web and mobile
- Validate platform-specific functionality
- Test cryptographic operations on all platforms
- Verify secure storage works on all platforms
- Confirm performance meets standards on all platforms
- Validate UI rendering on all supported devices

## Conclusion
This specification provides a comprehensive roadmap for migrating the ATLAS.BC0.0.1 web frontend to the GOFLUTTER Flutter project. By following the feature-first organization and clean architecture principles already established in GOFLUTTER, we can systematically convert each HTML component to its Flutter equivalent while maintaining full functionality and improving the user experience.

## Next Steps: A Phased Approach

This migration will be executed in phases, focusing on delivering complete, testable features incrementally.

### Phase 1: Foundation & Wallet Feature (Our Current Focus)

1. **Immediate Actions (Setup)**:
   - Run `flutter pub get` to ensure dependencies are installed
   - Run `flutter run` to test current implementation
   - Fix any compilation errors that appear

2. **API Client Implementation**:
   - Implement all endpoints listed in section `2.4 API Endpoint Implementation (High Priority)` within the `GOFLUTTER` API client service. Ensure proper error handling.

3. **Cryptographic & Wallet Logic**:
   - Implement ECDSA key generation and secure storage (`flutter_secure_storage`).
   - Implement transaction signing logic client-side.
   - Port wallet generation, import, and management functions from JavaScript to Dart.

4. **Wallet UI & Feature Implementation**:
   - Build out the UI for `features/wallet` and `features/wallet_setup` to match the `wallet.html` and `wallet-setup.html` designs.
   - Connect the UI to the BLoC and underlying services to create a fully functional wallet: view balance, view transaction history, send transactions, create/import wallet.

5. **Testing**:
   - Write unit and widget tests for all new logic and UI components in the Wallet feature.
   - Perform manual end-to-end testing of the complete wallet flow.

### Phase 2: Explorer & Dashboard Features
- Implement the `Explorer` feature to match `explorer.html`.
- Enhance the `Dashboard` to display real-time data from the backend.

### Phase 3 & Beyond: Remaining Features
- Systematically implement the remaining features (DeFi, Governance, etc.) based on priority.
