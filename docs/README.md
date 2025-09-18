# Flutter Wallet Integration Framework

## Overview

This repository contains a comprehensive framework for migrating a Java/HTML application to Flutter with integrated wallet functionality. The implementation follows the specifications outlined in the WALLET_INTEGRATION_PLAN.md document and provides a secure, end-to-end solution for user authentication, wallet creation, and transaction management.

## Project Structure

```
├── MIGRATION_PLAN.md           # Strategic migration plan from Java/HTML to Flutter
├── TECHNICAL_SPECIFICATION.md  # Detailed technical specifications
├── WALLET_INTEGRATION_PLAN.md  # Original wallet integration requirements
├── SAMPLE_IMPLEMENTATION/      # Sample Flutter implementation
│   ├── main.dart               # Application entry point
│   ├── models/                 # Data models
│   │   ├── user.dart           # User model
│   │   ├── wallet.dart         # Wallet model
│   │   └── transaction.dart    # Transaction model
│   ├── services/               # Business logic services
│   │   ├── api_client.dart     # API client for backend communication
│   │   ├── auth_service.dart   # Authentication service
│   │   ├── secure_storage.dart # Secure storage for wallet credentials
│   │   └── wallet_service.dart # Wallet management service
│   └── screens/                # UI components
│       ├── login_screen.dart   # Login screen
│       ├── register_screen.dart # Registration screen
│       ├── home_screen.dart    # Home screen
│       └── wallet_screen.dart  # Wallet management screen
└── README.md                   # This file
```

## Implementation Steps

### 1. Environment Setup

1. Run the setup script to install Flutter SDK and dependencies
   
   **For Windows:**
   ```bash
   .\setup_flutter_environment.bat
   ```

   **For macOS/Linux:**
   ```bash
   chmod +x ./setup_flutter_environment.sh
   ./setup_flutter_environment.sh
   ```

2. Set up Firebase project
   - Create a new Firebase project
   - Enable Authentication and Firestore
   - Download and add the `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) files

3. Configure environment variables
   - Create a `.env` file in the root of your project with the following variables:
   ```
   API_BASE_URL=https://your-atlas-bc-backend-url.com/api
   FAUCET_URL=https://your-faucet-url.com
   ```

### 2. Core Implementation

1. Configure Firebase in your project
   - Update `main.dart` to initialize Firebase
   - Set up Firebase Authentication and Firestore

2. Implement secure storage for wallet credentials
   - Use `flutter_secure_storage` for storing private keys
   - Implement encryption for additional security

3. Create API client for backend communication
   - Implement all required endpoints from ATLAS.BC
   - Add proper error handling and authentication

4. Implement authentication service
   - Connect Firebase authentication with wallet creation
   - Store wallet address in Firestore

5. Implement wallet service
   - Create methods for wallet operations
   - Implement transaction signing and submission

### 3. UI Implementation

1. Create authentication screens
   - Login screen
   - Registration screen with wallet creation

2. Create wallet management screens
   - Wallet dashboard with balance
   - Transaction history
   - Send transaction form
   - Request test tokens button

### 4. Testing

1. Unit tests
   - Test authentication flow
   - Test wallet operations
   - Test API client

2. Integration tests
   - Test end-to-end user flows
   - Test wallet creation and management

3. Security testing
   - Verify secure storage implementation
   - Test transaction signing security

## Security Considerations

1. **Private Key Storage**
   - Private keys must be stored securely using `flutter_secure_storage`
   - Never store private keys in plain text or shared preferences

2. **Transaction Signing**
   - Always sign transactions on the client device
   - Never send private keys to the server

3. **API Communication**
   - Use HTTPS for all API communications
   - Implement token-based authentication

## Best Practices

1. **State Management**
   - Use a consistent state management approach (Provider, Bloc, or Riverpod)
   - Keep business logic separate from UI

2. **Error Handling**
   - Implement proper error handling throughout the application
   - Provide user-friendly error messages

3. **Code Organization**
   - Follow the clean architecture principles
   - Separate concerns into appropriate layers

## Getting Started

1. Clone this repository
   ```bash
   git clone <repository-url>
   ```

2. Install dependencies
   ```bash
   flutter pub get
   ```

3. Configure Firebase
   - Add your Firebase configuration files
   - Update the Firebase project settings

4. Run the application
   ```bash
   flutter run
   ```

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Web3Dart Package](https://pub.dev/packages/web3dart)
- [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage)