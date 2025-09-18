# Flutter Project Template

This document provides a template for the Flutter project structure to be used in the migration from Java/HTML to Flutter.

## Directory Structure

```
FLUTTER_IMPLEMENTATION/
├── android/                 # Android-specific files
├── ios/                     # iOS-specific files
├── lib/                     # Dart source code
│   ├── main.dart            # Application entry point
│   ├── app.dart             # App widget and initialization
│   ├── config/              # Configuration files
│   │   ├── routes.dart      # Route definitions
│   │   ├── themes.dart      # Theme configuration
│   │   └── constants.dart   # Application constants
│   ├── di/                  # Dependency injection
│   │   └── service_locator.dart # GetIt service locator setup
│   ├── models/              # Data models
│   │   ├── user.dart        # User model
│   │   ├── wallet.dart      # Wallet model
│   │   └── transaction.dart # Transaction model
│   ├── services/            # Business logic services
│   │   ├── api/             # API-related services
│   │   │   ├── api_client.dart     # Base API client
│   │   │   ├── api_endpoints.dart  # API endpoint definitions
│   │   │   └── api_exception.dart  # API exception handling
│   │   ├── auth/            # Authentication services
│   │   │   ├── auth_service.dart   # Authentication service
│   │   │   └── auth_exception.dart # Authentication exception handling
│   │   ├── storage/         # Storage services
│   │   │   └── secure_storage.dart # Secure storage service
│   │   └── wallet/          # Wallet services
│   │       ├── wallet_service.dart  # Wallet management service
│   │       └── wallet_exception.dart # Wallet exception handling
│   ├── screens/             # UI screens
│   │   ├── auth/            # Authentication screens
│   │   │   ├── login_screen.dart    # Login screen
│   │   │   └── register_screen.dart # Registration screen
│   │   ├── home/            # Home screens
│   │   │   └── home_screen.dart     # Home screen
│   │   └── wallet/          # Wallet screens
│   │       ├── wallet_screen.dart   # Wallet dashboard
│   │       ├── send_screen.dart     # Send transaction screen
│   │       └── history_screen.dart  # Transaction history screen
│   ├── widgets/             # Reusable widgets
│   │   ├── common/          # Common widgets
│   │   │   ├── app_bar.dart        # Custom app bar
│   │   │   ├── loading_indicator.dart # Loading indicator
│   │   │   └── error_dialog.dart   # Error dialog
│   │   └── wallet/          # Wallet-specific widgets
│   │       ├── balance_card.dart   # Balance display card
│   │       ├── transaction_item.dart # Transaction list item
│   │       └── wallet_card.dart    # Wallet information card
│   └── utils/               # Utility functions
│       ├── validators.dart  # Input validation
│       ├── formatters.dart  # Data formatting
│       └── extensions.dart  # Dart extensions
├── test/                    # Test files
│   ├── unit/                # Unit tests
│   │   ├── services/        # Service tests
│   │   └── models/          # Model tests
│   ├── widget/              # Widget tests
│   └── integration/         # Integration tests
├── assets/                  # Static assets
│   ├── images/              # Image files
│   ├── fonts/               # Font files
│   └── icons/               # Icon files
├── .env                     # Environment variables
├── pubspec.yaml             # Package dependencies
└── README.md               # Project documentation
```

## Implementation Guidelines

### 1. Dependency Injection

Use GetIt for dependency injection to manage service instances:

```dart
// lib/di/service_locator.dart
import 'package:get_it/get_it.dart';
import '../services/api/api_client.dart';
import '../services/auth/auth_service.dart';
import '../services/storage/secure_storage.dart';
import '../services/wallet/wallet_service.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  // External services
  getIt.registerLazySingleton(() => SecureStorage());
  
  // API services
  getIt.registerLazySingleton(() => ApiClient());
  
  // App services
  getIt.registerLazySingleton(() => AuthService(
    getIt<ApiClient>(),
  ));
  
  getIt.registerLazySingleton(() => WalletService(
    getIt<ApiClient>(),
    getIt<SecureStorage>(),
  ));
}
```

### 2. State Management

Use Provider for state management:

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'di/service_locator.dart';
import 'services/auth/auth_service.dart';
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => getIt<AuthService>(),
        ),
        // Add other providers as needed
      ],
      child: MyApp(),
    ),
  );
}
```

### 3. Navigation

Use named routes for navigation:

```dart
// lib/config/routes.dart
import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/wallet/wallet_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String wallet = '/wallet';
  
  static Map<String, WidgetBuilder> routes = {
    login: (context) => LoginScreen(),
    register: (context) => RegisterScreen(),
    home: (context) => HomeScreen(),
    wallet: (context) => WalletScreen(),
  };
}
```

### 4. Error Handling

Implement service-specific exceptions:

```dart
// lib/services/wallet/wallet_exception.dart
class WalletException implements Exception {
  final String message;
  final dynamic cause;
  
  WalletException(this.message, [this.cause]);
  
  @override
  String toString() => 'WalletException: $message${cause != null ? ' ($cause)' : ''}';
}
```

### 5. API Client

Implement a robust API client with interceptors:

```dart
// lib/services/api/api_client.dart
import 'package:dio/dio.dart';
import '../storage/secure_storage.dart';
import 'api_exception.dart';

class ApiClient {
  final Dio _dio = Dio();
  final SecureStorage _secureStorage;
  
  ApiClient(this._secureStorage) {
    _dio.options.baseUrl = 'https://api.atlas.bc/api';
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 3);
    
    _dio.interceptors.add(AuthInterceptor(_secureStorage));
  }
  
  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<dynamic> post(String path, dynamic data) async {
    try {
      final response = await _dio.post(path, data: data);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  ApiException _handleError(DioException error) {
    return ApiException(
      message: error.message ?? 'Unknown error occurred',
      statusCode: error.response?.statusCode,
      data: error.response?.data,
    );
  }
}

class AuthInterceptor extends Interceptor {
  final SecureStorage _secureStorage;
  
  AuthInterceptor(this._secureStorage);
  
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorage.read(key: 'auth_token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }
}
```

This template provides a solid foundation for implementing the Flutter Wallet Integration Framework according to the specifications in the MIGRATION_PLAN.md and TECHNICAL_SPECIFICATION.md documents.