import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:cloud_firestore/cloud_firestore.dart';

import 'api_client_implementation.dart';
import 'secure_storage_implementation.dart';

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
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
  
  Map<String, dynamic> toMap() => {
    'uid': uid,
    'email': email,
    'displayName': displayName,
    'walletAddress': walletAddress,
    'createdAt': createdAt,
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
  final firebase.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final ApiClient _apiClient;
  final SecureStorage _secureStorage;
  
  User? _currentUser;
  
  AuthService(
    this._apiClient,
    this._secureStorage,
  ) : _firebaseAuth = firebase.FirebaseAuth.instance,
      _firestore = FirebaseFirestore.instance;
  
  /// Stream of authentication state changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges().asyncMap(
    (firebaseUser) async {
      if (firebaseUser == null) {
        _currentUser = null;
        return null;
      }
      
      try {
        final userDoc = await _firestore
            .collection('users')
            .doc(firebaseUser.uid)
            .get();
        
        if (userDoc.exists) {
          _currentUser = User.fromMap({
            'uid': firebaseUser.uid,
            ...userDoc.data()!,
          });
          return _currentUser;
        } else {
          // User exists in Firebase Auth but not in Firestore
          final newUser = User(
            uid: firebaseUser.uid,
            email: firebaseUser.email!,
            displayName: firebaseUser.displayName,
          );
          
          await _firestore
              .collection('users')
              .doc(firebaseUser.uid)
              .set(newUser.toMap());
          
          _currentUser = newUser;
          return newUser;
        }
      } catch (e) {
        throw AuthException('Failed to get user data: $e');
      }
    },
  );
  
  /// Registers a new user
  Future<User> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      // Create user with Firebase Auth
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw AuthException('Failed to create user');
      }
      
      // Update display name
      await firebaseUser.updateDisplayName(displayName);
      
      // Create user document in Firestore
      final user = User(
        uid: firebaseUser.uid,
        email: email,
        displayName: displayName,
      );
      
      await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .set(user.toMap());
      
      // Create wallet for the user
      try {
        final walletResponse = await _apiClient.createWallet();
        
        // Store wallet address in Firestore
        await _firestore
            .collection('users')
            .doc(firebaseUser.uid)
            .update({'walletAddress': walletResponse['data']['address']});
        
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
        await _apiClient.createIdentity(firebaseUser.uid);
        
        // Update user object with wallet address
        user = user.copyWith(walletAddress: walletResponse['data']['address']);
      } catch (e) {
        // Log error but don't fail registration
        print('Failed to create wallet: $e');
      }
      
      _currentUser = user;
      return user;
    } on firebase.FirebaseAuthException catch (e) {
      throw AuthException(_getFirebaseErrorMessage(e.code));
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
      // Sign in with Firebase Auth
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw AuthException('Failed to sign in');
      }
      
      // Get user data from Firestore
      final userDoc = await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();
      
      if (!userDoc.exists) {
        throw AuthException('User data not found');
      }
      
      final user = User.fromMap({
        'uid': firebaseUser.uid,
        ...userDoc.data()!,
      });
      
      // If user has a wallet address, retrieve wallet credentials
      if (user.walletAddress != null) {
        try {
          // Get wallet info from API
          final walletInfo = await _apiClient.getWalletInfo(user.walletAddress!);
          
          // Store wallet address in secure storage
          await _secureStorage.write(
            key: SecureStorage.keyWalletAddress,
            value: user.walletAddress!,
          );
        } catch (e) {
          // Log error but don't fail login
          print('Failed to get wallet info: $e');
        }
      }
      
      _currentUser = user;
      return user;
    } on firebase.FirebaseAuthException catch (e) {
      throw AuthException(_getFirebaseErrorMessage(e.code));
    } catch (e) {
      throw AuthException('Login failed: $e');
    }
  }
  
  /// Gets the current user
  Future<User?> getCurrentUser() async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) {
      return null;
    }
    
    if (_currentUser != null) {
      return _currentUser;
    }
    
    try {
      final userDoc = await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();
      
      if (!userDoc.exists) {
        return null;
      }
      
      _currentUser = User.fromMap({
        'uid': firebaseUser.uid,
        ...userDoc.data()!,
      });
      
      return _currentUser;
    } catch (e) {
      throw AuthException('Failed to get current user: $e');
    }
  }
  
  /// Logs out the current user
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
      await _secureStorage.clearStorage();
      _currentUser = null;
    } catch (e) {
      throw AuthException('Failed to log out: $e');
    }
  }
  
  /// Gets a user-friendly error message from Firebase error code
  String _getFirebaseErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Wrong password';
      case 'email-already-in-use':
        return 'Email is already in use';
      case 'weak-password':
        return 'Password is too weak';
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'operation-not-allowed':
        return 'Operation not allowed';
      case 'too-many-requests':
        return 'Too many requests. Try again later';
      default:
        return 'Authentication failed: $code';
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
