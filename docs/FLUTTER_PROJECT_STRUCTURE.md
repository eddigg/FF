# Flutter Project Structure Guide

## Overview

This document outlines the recommended project structure for the Flutter implementation of the wallet integration. Following this structure will ensure a clean, maintainable codebase that aligns with Flutter best practices.

## Directory Structure

```
├── lib/                      # Main source code directory
│   ├── main.dart             # Application entry point
│   ├── di/                   # Dependency injection
│   │   └── service_locator.dart  # Service locator setup
│   ├── models/               # Data models
│   │   ├── user.dart         # User model
│   │   └── wallet.dart       # Wallet and Transaction models
│   ├── services/             # Business logic services
│   │   ├── api_client.dart   # API client for backend communication
│   │   ├── auth_service.dart # Authentication service
│   │   ├── secure_storage.dart # Secure storage for wallet credentials
│   │   └── wallet_service.dart # Wallet management service
│   ├── screens/              # UI screens
│   │   ├── login_screen.dart # Login screen
│   │   ├── register_screen.dart # Registration screen
│   │   ├── home_screen.dart  # Home screen
│   │   └── wallet_screen.dart # Wallet management screen
│   ├── widgets/              # Reusable UI components
│   │   ├── transaction_list_item.dart # Transaction list item
│   │   ├── wallet_card.dart  # Wallet card widget
│   │   └── loading_button.dart # Loading button widget
│   └── utils/                # Utility functions and constants
│       ├── constants.dart    # App constants
│       ├── validators.dart   # Form validators
│       └── formatters.dart   # Text formatters
├── test/                     # Test directory
│   ├── widget_test.dart      # Widget tests
│   ├── auth_service_test.dart # Authentication service tests
│   └── wallet_service_test.dart # Wallet service tests
├── assets/                   # Assets directory
│   ├── images/               # Image assets
│   └── fonts/                # Font assets
├── android/                  # Android-specific code
├── ios/                      # iOS-specific code
├── web/                      # Web-specific code
└── pubspec.yaml              # Package dependencies
```

## Key Components

### 1. Dependency Injection

The `di/service_locator.dart` file sets up dependency injection using the `get_it` package. This ensures a clean separation of concerns and makes testing easier.

```dart
// Example of service_locator.dart
import 'package:get_it/get_it.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Register services
  serviceLocator.registerSingleton<ApiClient>(ApiClient());
  serviceLocator.registerSingleton<AuthService>(AuthService());
  // ... more services
}
```

### 2. Models

The `models/` directory contains data classes that represent the domain entities:

- `user.dart`: User profile information
- `wallet.dart`: Wallet information and transaction data

Models should include serialization/deserialization methods for JSON and Firestore.

### 3. Services

The `services/` directory contains business logic:

- `api_client.dart`: Handles API communication with the backend
- `auth_service.dart`: Manages user authentication
- `secure_storage.dart`: Securely stores sensitive information
- `wallet_service.dart`: Manages wallet operations

### 4. Screens

The `screens/` directory contains full-page UI components:

- `login_screen.dart`: User login
- `register_screen.dart`: User registration
- `home_screen.dart`: Main application screen
- `wallet_screen.dart`: Wallet management

### 5. Widgets

The `widgets/` directory contains reusable UI components:

- `transaction_list_item.dart`: List item for transactions
- `wallet_card.dart`: Card displaying wallet information
- `loading_button.dart`: Button with loading state

### 6. Utils

The `utils/` directory contains utility functions and constants:

- `constants.dart`: Application constants
- `validators.dart`: Form validation functions
- `formatters.dart`: Text formatting utilities

## State Management

This project uses the Provider pattern for state management. The `provider` package is used to propagate state changes throughout the widget tree.

```dart
// Example of state management in main.dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => WalletProvider()),
  ],
  child: MaterialApp(...),
)
```

## Navigation

The application uses named routes for navigation, defined in `main.dart`:

```dart
MaterialApp(
  initialRoute: '/login',
  routes: {
    '/login': (context) => LoginScreen(),
    '/register': (context) => RegisterScreen(),
    '/home': (context) => HomeScreen(),
    '/wallet': (context) => WalletScreen(),
  },
)
```

## Error Handling

Each service has its own exception class:

- `ApiException`: For API communication errors
- `AuthException`: For authentication errors
- `WalletException`: For wallet operation errors

These exceptions should be caught and handled appropriately in the UI.

## Testing

The `test/` directory contains tests for the application:

- Widget tests: Test UI components
- Service tests: Test business logic
- Integration tests: Test end-to-end flows

## Conclusion

Following this project structure will ensure a clean, maintainable codebase that aligns with Flutter best practices. It provides a solid foundation for implementing the wallet integration requirements outlined in the WALLET_INTEGRATION_PLAN.md document.