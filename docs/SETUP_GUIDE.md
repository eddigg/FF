# ATLAS Blockchain Wallet - Setup Guide

## Prerequisites

Before setting up the project, ensure you have the following installed:

### Backend (ATLAS.BC0.0.1)
- Go 1.19 or higher
- Git

### Frontend (GOFLUTTER and cercaend)
- Flutter SDK (latest stable)
- Dart SDK (bundled with Flutter)
- Git
- Android Studio / VS Code with Flutter plugins (for mobile development)

## Project Setup

### 1. Backend Setup (ATLAS.BC0.0.1)

1. Navigate to the backend directory:
   ```bash
   cd ATLAS.BC0.0.1
   ```

2. Install Go dependencies:
   ```bash
   go mod tidy
   ```

3. Start the blockchain node:
   ```bash
   go run main.go
   ```

4. The backend should now be running on the configured port (typically 8080).

### 2. Web Frontend Setup (GOFLUTTER)

1. Navigate to the web frontend directory:
   ```bash
   cd GOFLUTTER
   ```

2. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```

3. Run the web application:
   ```bash
   flutter run -d chrome
   ```

4. Note: If you encounter compilation errors, see the troubleshooting section below.

### 3. Mobile App Setup (cercaend)

1. Navigate to the mobile app directory:
   ```bash
   cd cercaend
   ```

2. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```

3. Run the mobile application:
   ```bash
   flutter run
   ```

## Troubleshooting

### Common GOFLUTTER Compilation Issues

The GOFLUTTER application currently has several compilation errors due to missing imports and undefined components. Here's how to address them:

1. Missing theme imports:
   - File: `lib/features/governance/presentation/pages/governance_page.dart`
   - Add: `import '../../../../shared/themes/web_parity_theme.dart';`
   - Add: `import '../../../../shared/widgets/web_scaffold.dart';`
   - Add: `import '../../../../shared/themes/app_colors.dart';`
   - Add: `import '../../../../shared/widgets/glass_card.dart' as glass_card;`
   - Add: `import '../../../../shared/widgets/common_widgets.dart';`

2. Missing typography imports:
   - Add: `import '../../../../shared/themes/web_typography.dart';`
   - Add: `import '../../../../shared/themes/web_colors.dart';`
   - Add: `import '../../../../shared/themes/web_gradients.dart';`
   - Add: `import '../../../../shared/themes/web_shadows.dart';`

3. Missing custom widget imports:
   - Add: `import '../../../../shared/widgets/custom_widgets.dart';`
   - Add: `import '../../../../shared/widgets/web_button.dart';`
   - Add: `import '../../../../shared/widgets/status_indicator.dart';`

4. Similar import fixes needed for other pages in the project.

### Development Workflow

1. Start the backend service (ATLAS.BC0.0.1) first
2. Verify the backend is accessible
3. Run either the web frontend (GOFLUTTER) or mobile app (cercaend)
4. Make sure to run `flutter pub get` after adding any new dependencies

## API Integration

The frontend applications communicate with the ATLAS blockchain backend through REST APIs. The main endpoints needed are:

- GET `/wallet-info?address=<address>` - Get balance for an address
- POST `/transactions` - Submit a new, signed transaction
- GET `/transactions?address=<address>&page=1&limit=20` - Get transaction history
- POST `/faucet` (for testnet/development) - Request test tokens

## Security Considerations

- Private keys and recovery phrases are generated and stored exclusively on the user's device
- Never send or store private keys on backend servers
- Use flutter_secure_storage for secure storage of wallet data on mobile devices

## Architecture Overview

The system follows a three-tier architecture:

1. **Frontend Layer** (GOFLUTTER/cercaend):
   - User Interface
   - User Authentication (via Firebase)
   - Wallet Security (local key management)
   - API Client (for blockchain communication)

2. **Backend Layer** (ATLAS.BC0.0.1):
   - Blockchain ledger
   - Transaction processing
   - Public gateway REST API

3. **Identity Layer** (Firebase):
   - User accounts
   - Profile data