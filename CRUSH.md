# CRUSH.md - Development Configuration for ATLAS Blockchain Project

## Build & Commands

### Flutter Mobile (products/wallets/mobile/)
```bash
# Development
flutter run --debug
flutter run --profile --web-port=3002

# Building
flutter build apk --release
flutter build appbundle --release

# Testing & Analysis
flutter analyze --no-fatal-infos
flutter test
flutter drive --target=test_driver/app.dart

# Hot Reload
flutter run --hot
```

### Flutter Web (products/wallets/web/)
```bash
# Development
flutter run --web-port=3002 --debug
flutter run --web-port=3002 --profile

# Building
flutter build web --release --web-renderer canvaskit
flutter build web --release --web-renderer html

# Testing
flutter test
flutter analyze --no-fatal-infos
```

### Blockchain Go Backend (products/blockchain/core/)
```bash
# Development
go run cmd/main.go
go test ./...
go build -o atlasserver cmd/main.go

# Testing
go test -v ./internal/...
go test -v ./pkg/...
```

## Code Style & Architecture

### Import Organization
```dart
// Standard library first
import 'dart:async';
import 'dart:io';

// External packages
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

// Internal imports (relative)
import '../models/user_model.dart';
import '../services/api_service.dart';
import 'bloc/wallet_bloc.dart';
```

### Naming Conventions
- **Classes**: PascalCase (e.g., `UserProfile`, `WalletService`)
- **Methods/Functions**: camelCase (e.g., `getUserProfile`, `validateAddress`)
- **Variables**: camelCase (e.g., `userProfile`, `blockchainState`)
- **Constants**: SCREAMING_SNAKE_CASE (e.g., `API_BASE_URL`, `MAX_RETRIES`)
- **Files**: snake_case (e.g., `user_profile_service.dart`, `wallet_bloc.dart`)

### Error Handling Patterns
```dart
// Use Try-Catch for async operations
try {
  final result = await apiService.fetchData();
  return result;
} catch (e, stackTrace) {
  logger.error('Failed to fetch data: $e', stackTrace: stackTrace);
  throw DataFetchException('Failed to fetch data: $e');
}

// Use Result pattern for API responses
typedef Result<T> = ({T? data, String? error});

Result<T> safeApiCall<T>(Future<T> Function() apiCall) async {
  try {
    final data = await apiCall();
    return (data: data, error: null);
  } catch (e) {
    return (data: null, error: e.toString());
  }
}
```

### BLoC Architecture Patterns
```dart
// Event naming: [Feature]Event
class WalletEvent extends Equatable {
  const WalletEvent();
}

class LoadWallet extends WalletEvent {
  final String walletAddress;
  const LoadWallet(this.walletAddress);
}

// State naming: [Feature]State
abstract class WalletState extends Equatable {
  const WalletState();
}

class WalletInitial extends WalletState {
  const WalletInitial();
}

class WalletLoading extends WalletState {
  const WalletLoading();
}

class WalletLoaded extends WalletState {
  final Wallet wallet;
  const WalletLoaded(this.wallet);
}

// BLoC implementation
class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc() : super(const WalletInitial()) {
    on<LoadWallet>(_onLoadWallet);
  }

  Future<void> _onLoadWallet(
    LoadWallet event,
    Emitter<WalletState> emit,
  ) async {
    emit(WalletLoading());
    try {
      final wallet = await walletService.getWallet(event.walletAddress);
      emit(WalletLoaded(wallet));
    } catch (e) {
      emit(WalletError(e.toString()));
    }
  }
}
```

### Firebase Integration Patterns
```dart
// Use streams for real-time data
Stream<List<UsersRecord>> watchUsers() {
  return FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapshot) => 
          snapshot.docs.map((doc) => UsersRecord.fromSnapshot(doc)).toList());
}

// Use proper error handling for Firebase operations
Future<void> updateUserProfile(String userId, UserProfile profile) async {
  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update(profile.toFirestore());
  } catch (e) {
    throw FirebaseUpdateException('Failed to update profile: ${e.toString()}');
  }
}
```

### Testing Patterns
```dart
// Unit test for services
void main() {
  group('WalletService', () {
    late WalletService walletService;
    late MockApi mockApi;

    setUp(() {
      mockApi = MockApi();
      walletService = WalletService(api: mockApi);
    });

    test('getBalance returns correct balance', () async {
      // Arrange
      when(mockApi.getBalance(any)).thenAnswer((_) async => 1000);
      
      // Act
      final balance = await walletService.getBalance('0x123');
      
      // Assert
      expect(balance, 1000);
    });
  });
}

// Widget test with BLoC
testWidgets('WalletScreen shows loading state', (WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: BlocProvider(
        create: (context) => WalletBloc(),
        child: const WalletScreen(),
      ),
    ),
  );
  
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
});
```

### API Layer Patterns
```dart
// Use dependency injection
class ApiClient {
  final http.Client client;
  final String baseUrl;
  
  ApiClient({required this.client, required this.baseUrl});
  
  // Use proper error handling and logging
  Future<T> request<T>({
    required String endpoint,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        return fromJson(jsonDecode(response.body));
      } else {
        throw ApiException('API Error: ${response.statusCode}');
      }
    } catch (e) {
      logger.error('API request failed: $e');
      rethrow;
    }
  }
}
```

## Environment Configuration
- Use `.env` files for environment-specific configuration
- Use `flutter_dotenv` for Flutter environment variables
- Use Go environment variables for backend configuration

## Development Workflow
1. Run `flutter analyze` before committing
2. Run tests for both Flutter and Go components
3. Use proper logging and error handling
4. Follow BLoC patterns for state management
5. Use Firebase streams for real-time data
6. Implement proper error boundaries