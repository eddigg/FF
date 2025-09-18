# Technical Specification: Flutter Wallet Integration

## 1. Architecture Overview

The Flutter application will follow a clean architecture approach with the following layers:

- **Presentation Layer**: UI components, screens, and widgets
- **Business Logic Layer**: Services, providers, and state management
- **Data Layer**: Repositories, API clients, and local storage
- **Domain Layer**: Models and entities

## 2. Technology Stack

### Core Technologies
- **Flutter**: v3.19+ (latest stable)
- **Dart**: v3.3+ (latest stable)
- **Firebase**: Authentication, Firestore, Analytics

### Key Packages
- **flutter_secure_storage**: For secure storage of wallet private keys
- **provider** or **flutter_bloc**: For state management
- **dio**: For HTTP requests
- **web3dart**: For blockchain interactions and transaction signing
- **get_it**: For dependency injection
- **flutter_test**: For unit and widget testing

## 3. Data Models

### User Model
```dart
class User {
  final String uid;
  final String email;
  final String? displayName;
  final String? walletAddress;
  
  User({
    required this.uid,
    required this.email,
    this.displayName,
    this.walletAddress,
  });
  
  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      uid: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'],
      walletAddress: data['walletAddress'],
    );
  }
  
  Map<String, dynamic> toFirestore() => {
    'email': email,
    'displayName': displayName,
    'walletAddress': walletAddress,
  };
}
```

### Wallet Model
```dart
class Wallet {
  final String address;
  final double balance;
  final int nonce;
  final List<Transaction> recentTransactions;
  
  Wallet({
    required this.address,
    required this.balance,
    required this.nonce,
    required this.recentTransactions,
  });
  
  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      address: json['address'] ?? '',
      balance: (json['balance'] ?? 0).toDouble(),
      nonce: json['nonce'] ?? 0,
      recentTransactions: (json['recentTransactions'] as List?)
          ?.map((tx) => Transaction.fromJson(tx))
          .toList() ?? [],
    );
  }
}
```

### Transaction Model
```dart
class Transaction {
  final String hash;
  final String from;
  final String to;
  final double amount;
  final DateTime timestamp;
  final String status;
  
  Transaction({
    required this.hash,
    required this.from,
    required this.to,
    required this.amount,
    required this.timestamp,
    required this.status,
  });
  
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      hash: json['hash'] ?? '',
      from: json['from'] ?? '',
      to: json['to'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      timestamp: json['timestamp'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['timestamp']) 
          : DateTime.now(),
      status: json['status'] ?? 'pending',
    );
  }
  
  Map<String, dynamic> toJson() => {
    'from': from,
    'to': to,
    'amount': amount,
  };
}
```

## 4. API Client

### ApiClient Class
```dart
class ApiClient {
  final Dio _dio;
  final SecureStorage _secureStorage;
  
  ApiClient(this._dio, this._secureStorage) {
    _dio.options.baseUrl = 'https://api.atlas.bc/v1';
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 3);
    _dio.interceptors.add(LogInterceptor(responseBody: true));
    _dio.interceptors.add(AuthInterceptor(_secureStorage));
  }
  
  // Wallet Creation
  Future<WalletResponse> createWallet() async {
    try {
      final response = await _dio.post('/flutterflow/connect-wallet', data: {
        'action': 'create'
      });
      return WalletResponse.fromJson(response.data['data']);
    } catch (e) {
      throw ApiException('Failed to create wallet', e);
    }
  }
  
  // Import Existing Wallet
  Future<WalletResponse> importWallet(String privateKey) async {
    try {
      final response = await _dio.post('/flutterflow/connect-wallet', data: {
        'action': 'import',
        'privateKey': privateKey
      });
      return WalletResponse.fromJson(response.data['data']);
    } catch (e) {
      throw ApiException('Failed to import wallet', e);
    }
  }
  
  // Get Wallet Information
  Future<Wallet> getWalletInfo(String address) async {
    try {
      final response = await _dio.get('/flutterflow/wallet-info', 
        queryParameters: {'address': address});
      return Wallet.fromJson(response.data['data']);
    } catch (e) {
      throw ApiException('Failed to get wallet info', e);
    }
  }
  
  // Request Test Tokens
  Future<String> requestTestTokens(String address) async {
    try {
      final response = await _dio.post('/faucet', data: {
        'address': address
      });
      return response.data['message'];
    } catch (e) {
      throw ApiException('Failed to request test tokens', e);
    }
  }
  
  // Send Transaction
  Future<String> sendTransaction(Transaction transaction, String signature) async {
    try {
      final response = await _dio.post('/flutterflow/send-transaction', data: {
        'transaction': transaction.toJson(),
        'signature': signature
      });
      return response.data['data']['transactionHash'];
    } catch (e) {
      throw ApiException('Failed to send transaction', e);
    }
  }
}
```

## 5. Secure Storage Service

```dart
class SecureStorage {
  final FlutterSecureStorage _storage;
  
  SecureStorage(this._storage);
  
  // Store private key
  Future<void> storePrivateKey(String privateKey) async {
    await _storage.write(key: 'wallet_private_key', value: privateKey);
  }
  
  // Retrieve private key
  Future<String?> getPrivateKey() async {
    return await _storage.read(key: 'wallet_private_key');
  }
  
  // Store session token
  Future<void> storeSessionToken(String token) async {
    await _storage.write(key: 'session_token', value: token);
  }
  
  // Retrieve session token
  Future<String?> getSessionToken() async {
    return await _storage.read(key: 'session_token');
  }
  
  // Clear all secure storage
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
```

## 6. Authentication Service

```dart
class AuthService {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final ApiClient _apiClient;
  final SecureStorage _secureStorage;
  
  AuthService(
    this._firebaseAuth,
    this._firestore,
    this._apiClient,
    this._secureStorage,
  );
  
  // Register user
  Future<User> register(String email, String password) async {
    try {
      // Create Firebase user
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Create wallet
      final walletResponse = await _apiClient.createWallet();
      
      // Store private key securely
      await _secureStorage.storePrivateKey(walletResponse.privateKey);
      await _secureStorage.storeSessionToken(walletResponse.sessionToken);
      
      // Create user document in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'walletAddress': walletResponse.address,
        'createdAt': FieldValue.serverTimestamp(),
      });
      
      // Return user model
      return User(
        uid: userCredential.user!.uid,
        email: email,
        walletAddress: walletResponse.address,
      );
    } catch (e) {
      throw AuthException('Registration failed', e);
    }
  }
  
  // Login user
  Future<User> login(String email, String password) async {
    try {
      // Login with Firebase
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Get user document from Firestore
      final userDoc = await _firestore
        .collection('users')
        .doc(userCredential.user!.uid)
        .get();
      
      if (!userDoc.exists) {
        throw AuthException('User data not found', null);
      }
      
      final userData = userDoc.data()!;
      
      // Return user model
      return User(
        uid: userCredential.user!.uid,
        email: email,
        displayName: userData['displayName'],
        walletAddress: userData['walletAddress'],
      );
    } catch (e) {
      throw AuthException('Login failed', e);
    }
  }
  
  // Logout user
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
  
  // Get current user
  User? getCurrentUser() {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) return null;
    
    return User(
      uid: firebaseUser.uid,
      email: firebaseUser.email!,
      displayName: firebaseUser.displayName,
      walletAddress: null, // Need to fetch from Firestore
    );
  }
}
```

## 7. Wallet Service

```dart
class WalletService {
  final ApiClient _apiClient;
  final SecureStorage _secureStorage;
  final Web3Client _web3client;
  
  WalletService(
    this._apiClient,
    this._secureStorage,
    this._web3client,
  );
  
  // Get wallet info
  Future<Wallet> getWalletInfo(String address) async {
    return await _apiClient.getWalletInfo(address);
  }
  
  // Request test tokens
  Future<String> requestTestTokens(String address) async {
    return await _apiClient.requestTestTokens(address);
  }
  
  // Send transaction
  Future<String> sendTransaction(String to, double amount) async {
    try {
      // Get private key
      final privateKey = await _secureStorage.getPrivateKey();
      if (privateKey == null) {
        throw WalletException('Private key not found', null);
      }
      
      // Create credentials
      final credentials = EthPrivateKey.fromHex(privateKey);
      final address = await credentials.extractAddress();
      
      // Create transaction
      final transaction = Transaction(
        hash: '',
        from: address.hex,
        to: to,
        amount: amount,
        timestamp: DateTime.now(),
        status: 'pending',
      );
      
      // Sign transaction
      final txData = jsonEncode(transaction.toJson());
      final signature = await credentials.signPersonalMessage(
        utf8.encode(txData),
      );
      
      // Send transaction
      final txHash = await _apiClient.sendTransaction(
        transaction,
        bytesToHex(signature, include0x: true),
      );
      
      return txHash;
    } catch (e) {
      throw WalletException('Failed to send transaction', e);
    }
  }
}
```

## 8. UI Components

### WalletScreen
```dart
class WalletScreen extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final WalletService _walletService = GetIt.instance<WalletService>();
  final AuthService _authService = GetIt.instance<AuthService>();
  
  late Future<Wallet> _walletFuture;
  
  @override
  void initState() {
    super.initState();
    _loadWalletData();
  }
  
  void _loadWalletData() {
    final user = _authService.getCurrentUser();
    if (user != null && user.walletAddress != null) {
      _walletFuture = _walletService.getWalletInfo(user.walletAddress!);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Wallet')),
      body: FutureBuilder<Wallet>(
        future: _walletFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final wallet = snapshot.data!;
            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWalletCard(wallet),
                  SizedBox(height: 24),
                  _buildActionButtons(wallet),
                  SizedBox(height: 24),
                  Text('Recent Transactions', 
                    style: Theme.of(context).textTheme.headline6),
                  SizedBox(height: 8),
                  _buildTransactionList(wallet.recentTransactions),
                ],
              ),
            );
          } else {
            return Center(child: Text('No wallet data available'));
          }
        },
      ),
    );
  }
  
  Widget _buildWalletCard(Wallet wallet) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Wallet Address', 
              style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(wallet.address, style: TextStyle(fontSize: 12)),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Balance', 
                  style: TextStyle(fontWeight: FontWeight.bold)),
                Text('${wallet.balance} TOKENS', 
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildActionButtons(Wallet wallet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          icon: Icon(Icons.send),
          label: Text('Send'),
          onPressed: () => _showSendDialog(context),
        ),
        ElevatedButton.icon(
          icon: Icon(Icons.water_drop),
          label: Text('Request Tokens'),
          onPressed: () => _requestTestTokens(wallet.address),
        ),
      ],
    );
  }
  
  Widget _buildTransactionList(List<Transaction> transactions) {
    if (transactions.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: Text('No transactions yet')),
      );
    }
    
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final tx = transactions[index];
        return ListTile(
          title: Text(tx.hash.substring(0, 10) + '...'),
          subtitle: Text('${tx.amount} TOKENS'),
          trailing: Text(tx.status),
          leading: Icon(
            tx.from == wallet.address ? Icons.arrow_upward : Icons.arrow_downward,
            color: tx.from == wallet.address ? Colors.red : Colors.green,
          ),
        );
      },
    );
  }
  
  void _showSendDialog(BuildContext context) {
    final addressController = TextEditingController();
    final amountController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Send Tokens'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: addressController,
              decoration: InputDecoration(labelText: 'Recipient Address'),
            ),
            TextField(
              controller: amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: Text('Send'),
            onPressed: () {
              Navigator.of(context).pop();
              _sendTransaction(
                addressController.text,
                double.tryParse(amountController.text) ?? 0,
              );
            },
          ),
        ],
      ),
    );
  }
  
  Future<void> _requestTestTokens(String address) async {
    try {
      final result = await _walletService.requestTestTokens(address);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
      // Refresh wallet data
      setState(() {
        _loadWalletData();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
  
  Future<void> _sendTransaction(String to, double amount) async {
    try {
      final txHash = await _walletService.sendTransaction(to, amount);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transaction sent: $txHash')),
      );
      // Refresh wallet data
      setState(() {
        _loadWalletData();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
```

## 9. Dependency Injection Setup

```dart
void setupDependencies() {
  final getIt = GetIt.instance;
  
  // External dependencies
  getIt.registerSingleton<FlutterSecureStorage>(FlutterSecureStorage());
  getIt.registerSingleton<Dio>(Dio());
  getIt.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  getIt.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
  getIt.registerSingleton<Web3Client>(Web3Client('https://rpc.atlas.bc', Client()));
  
  // Services
  getIt.registerSingleton<SecureStorage>(
    SecureStorage(getIt<FlutterSecureStorage>()),
  );
  
  getIt.registerSingleton<ApiClient>(
    ApiClient(getIt<Dio>(), getIt<SecureStorage>()),
  );
  
  getIt.registerSingleton<AuthService>(
    AuthService(
      getIt<FirebaseAuth>(),
      getIt<FirebaseFirestore>(),
      getIt<ApiClient>(),
      getIt<SecureStorage>(),
    ),
  );
  
  getIt.registerSingleton<WalletService>(
    WalletService(
      getIt<ApiClient>(),
      getIt<SecureStorage>(),
      getIt<Web3Client>(),
    ),
  );
}
```

## 10. Error Handling

```dart
// Base Exception
class AppException implements Exception {
  final String message;
  final dynamic cause;
  
  AppException(this.message, this.cause);
  
  @override
  String toString() => '$message${cause != null ? ': $cause' : ''}';
}

// API Exception
class ApiException extends AppException {
  ApiException(String message, dynamic cause) : super(message, cause);
}

// Auth Exception
class AuthException extends AppException {
  AuthException(String message, dynamic cause) : super(message, cause);
}

// Wallet Exception
class WalletException extends AppException {
  WalletException(String message, dynamic cause) : super(message, cause);
}
```

## 11. Testing Strategy

### Unit Tests

```dart
void main() {
  group('WalletService Tests', () {
    late WalletService walletService;
    late MockApiClient mockApiClient;
    late MockSecureStorage mockSecureStorage;
    late MockWeb3Client mockWeb3Client;
    
    setUp(() {
      mockApiClient = MockApiClient();
      mockSecureStorage = MockSecureStorage();
      mockWeb3Client = MockWeb3Client();
      walletService = WalletService(
        mockApiClient,
        mockSecureStorage,
        mockWeb3Client,
      );
    });
    
    test('getWalletInfo returns wallet data', () async {
      // Arrange
      final address = '0xABC123';
      final wallet = Wallet(
        address: address,
        balance: 1000,
        nonce: 1,
        recentTransactions: [],
      );
      
      when(mockApiClient.getWalletInfo(address))
        .thenAnswer((_) async => wallet);
      
      // Act
      final result = await walletService.getWalletInfo(address);
      
      // Assert
      expect(result, equals(wallet));
      verify(mockApiClient.getWalletInfo(address)).called(1);
    });
    
    test('sendTransaction signs and sends transaction', () async {
      // Arrange
      final privateKey = '0x123';
      final address = '0xABC';
      final to = '0xDEF';
      final amount = 100.0;
      final txHash = '0xTX123';
      
      when(mockSecureStorage.getPrivateKey())
        .thenAnswer((_) async => privateKey);
      
      // Mock credentials and signing
      final mockCredentials = MockCredentials();
      when(mockCredentials.extractAddress())
        .thenAnswer((_) async => EthereumAddress.fromHex(address));
      when(mockCredentials.signPersonalMessage(any))
        .thenAnswer((_) async => Uint8List(65));
      
      // Mock transaction sending
      when(mockApiClient.sendTransaction(any, any))
        .thenAnswer((_) async => txHash);
      
      // Act
      final result = await walletService.sendTransaction(to, amount);
      
      // Assert
      expect(result, equals(txHash));
      verify(mockSecureStorage.getPrivateKey()).called(1);
      verify(mockApiClient.sendTransaction(any, any)).called(1);
    });
  });
}
```

## 12. Security Considerations

1. **Private Key Storage**
   - Use `flutter_secure_storage` for storing private keys
   - Never store private keys in plain text or shared preferences
   - Consider additional encryption layer for private keys

2. **API Communication**
   - Use HTTPS for all API communications
   - Implement certificate pinning for added security
   - Add request/response encryption for sensitive data

3. **Authentication**
   - Implement token expiration and refresh mechanisms
   - Use biometric authentication for wallet operations
   - Implement session timeout for inactive users

4. **Transaction Signing**
   - Always sign transactions on the client device
   - Never send private keys to the server
   - Implement transaction confirmation screens with clear details

5. **Code Security**
   - Obfuscate release builds
   - Implement root/jailbreak detection
   - Add runtime integrity checks

## 13. Performance Optimization

1. **Lazy Loading**
   - Implement pagination for transaction history
   - Use lazy loading for wallet data

2. **Caching**
   - Cache wallet information locally
   - Implement intelligent refresh strategies

3. **UI Optimization**
   - Use const constructors where possible
   - Implement efficient list rendering with ListView.builder
   - Minimize rebuilds with proper state management

## 14. Conclusion

This technical specification provides a comprehensive blueprint for implementing the wallet integration in Flutter. By following this specification, developers can ensure a secure, performant, and user-friendly wallet experience that seamlessly integrates with the ATLAS.BC backend.

The implementation should prioritize security at every step, especially regarding the handling of private keys and transaction signing. Regular security audits and testing should be conducted throughout the development process to identify and address any potential vulnerabilities.