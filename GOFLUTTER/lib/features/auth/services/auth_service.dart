import 'dart:async';
import 'api_client_implementation.dart';
import 'secure_storage_implementation.dart';
import '../../../core/utils/logger.dart';

/// User model
class User {
  final String uid;
  final String email;
  final String? displayName;
  final String? walletAddress;
  final DateTime createdAt;
  
  User({
    required this.uid,
    required this.email,
    this.displayName,
    this.walletAddress,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
  
  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      uid: data['uid'] as String,
      email: data['email'] as String,
      displayName: data['displayName'] as String?,
      walletAddress: data['walletAddress'] as String?,
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'] as String)
          : DateTime.now(),
    );
  }
  
  Map<String, dynamic> toMap() => {
    'uid': uid,
    'email': email,
    'displayName': displayName,
    'walletAddress': walletAddress,
    'createdAt': createdAt.toIso8601String(),
  };
  
  User copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? walletAddress,
    DateTime? createdAt,
  }) {
    return User(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      walletAddress: walletAddress ?? this.walletAddress,
      createdAt: createdAt ?? this.createdAt,
    );
  }
  
  @override
  String toString() => 'User(uid: $uid, email: $email, displayName: $displayName, walletAddress: $walletAddress)';
}

/// Service for user authentication
class AuthService {
  final ApiClient _apiClient;
  final SecureStorage _secureStorage;
  
  User? _currentUser;
  final StreamController<User?> _authStateController = StreamController<User?>.broadcast();
  
  AuthService(
    this._apiClient,
    this._secureStorage,
  );
  
  /// Stream of authentication state changes
  Stream<User?> get authStateChanges => _authStateController.stream;
  
  /// Registers a new user
  Future<User> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      // In a real implementation, you would call an API to register the user
      // For now, we'll just create a local user
      
      final user = User(
        uid: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        displayName: displayName,
      );
      
      // Create wallet for the user
      try {
        final walletResponse = await _apiClient.createWallet();
        
        // Store wallet credentials securely
        await _secureStorage.write(
          key: SecureStorage.keyPrivateKey,
          value: walletResponse['data']['privateKey'],
        );
        
        await _secureStorage.write(
          key: SecureStorage.keyWalletAddress,
          value: walletResponse['data']['address'],
        );
        
        await _secureStorage.write(
          key: SecureStorage.keySessionToken,
          value: walletResponse['data']['sessionToken'],
        );
        
        // Create identity in ATLAS.BC
        await _apiClient.createIdentity(user.uid);
        
        // Update user object with wallet address
        final updatedUser = user.copyWith(walletAddress: walletResponse['data']['address']);
        _currentUser = updatedUser;
        _authStateController.add(updatedUser);
        return updatedUser;
      } catch (e) {
        // Log error but don't fail registration
        AppLogger.logError('Failed to create wallet', e);
        _currentUser = user;
        _authStateController.add(user);
        return user;
      }
    } catch (e) {
      throw AuthException('Registration failed: $e');
    }
  }
  
  /// Logs in a user
  Future<User> login({
    required String email,
    required String password,
  }) async {
    try {
      // In a real implementation, you would call an API to authenticate the user
      // For now, we'll just create a local user
      
      final user = User(
        uid: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        displayName: email.split('@')[0],
      );
      
      _currentUser = user;
      _authStateController.add(user);
      return user;
    } catch (e) {
      throw AuthException('Login failed: $e');
    }
  }
  
  /// Gets the current user
  Future<User?> getCurrentUser() async {
    return _currentUser;
  }
  
  /// Logs out the current user
  Future<void> logout() async {
    try {
      await _secureStorage.clearStorage();
      _currentUser = null;
      _authStateController.add(null);
    } catch (e) {
      throw AuthException('Failed to log out: $e');
    }
  }
}

/// Exception thrown when authentication operations fail
class AuthException implements Exception {
  final String message;
  
  const AuthException(this.message);
  
  @override
  String toString() => 'AuthException: $message';
}
