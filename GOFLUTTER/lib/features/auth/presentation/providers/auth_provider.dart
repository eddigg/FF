import 'package:flutter/foundation.dart';
import '../../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  User? _currentUser;
  bool _isLoading = false;

  AuthProvider(this._authService) {
    // Listen to auth state changes
    _authService.authStateChanges.listen((user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;

  Future<User> login({required String email, required String password}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = await _authService.login(email: email, password: password);
      _isLoading = false;
      notifyListeners();
      return user;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<User> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = await _authService.register(
        email: email,
        password: password,
        displayName: displayName,
      );
      _isLoading = false;
      notifyListeners();
      return user;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    notifyListeners();
  }

  Future<User?> getCurrentUser() async {
    _currentUser = await _authService.getCurrentUser();
    notifyListeners();
    return _currentUser;
  }
}
