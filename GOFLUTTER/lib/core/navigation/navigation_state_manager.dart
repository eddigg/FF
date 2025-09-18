import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Navigation state manager for maintaining selected states across app sessions
/// Matches the web implementation patterns for persistent navigation state
class NavigationStateManager extends ChangeNotifier {
  static const String _selectedRouteKey = 'selected_route';
  static const String _navigationHistoryKey = 'navigation_history';
  
  String _currentRoute = '/';
  String _previousRoute = '/';
  final List<String> _navigationHistory = [];
  final int _maxHistorySize = 10; // Limit history to last 10 routes
  
  NavigationStateManager() {
    _loadNavigationState();
  }
  
  /// Get the current route
  String get currentRoute => _currentRoute;
  
  /// Get the previous route
  String get previousRoute => _previousRoute;
  
  /// Get navigation history
  List<String> get navigationHistory => List.unmodifiable(_navigationHistory);
  
  /// Update current route and maintain navigation state
  void updateCurrentRoute(String newRoute) {
    if (newRoute != _currentRoute) {
      // Update previous route
      _previousRoute = _currentRoute;
      
      // Update current route
      _currentRoute = newRoute;
      
      // Add to navigation history
      _addToHistory(newRoute);
      
      // Save state
      _saveNavigationState();
      
      // Notify listeners
      notifyListeners();
    }
  }
  
  /// Navigate back to previous route
  String navigateBack() {
    if (_navigationHistory.length > 1) {
      // Remove current route from history
      _navigationHistory.removeLast();
      
      // Get previous route
      final previous = _navigationHistory.last;
      _currentRoute = previous;
      _previousRoute = _navigationHistory.length > 1 ? _navigationHistory[_navigationHistory.length - 2] : '/';
      
      // Save state
      _saveNavigationState();
      
      // Notify listeners
      notifyListeners();
      
      return previous;
    }
    
    // Default back route
    return '/';
  }
  
  /// Clear navigation history
  void clearHistory() {
    _navigationHistory.clear();
    _currentRoute = '/';
    _previousRoute = '/';
    _saveNavigationState();
    notifyListeners();
  }
  
  /// Add route to navigation history
  void _addToHistory(String route) {
    // Remove if already exists to avoid duplicates
    _navigationHistory.remove(route);
    
    // Add to the end
    _navigationHistory.add(route);
    
    // Limit history size
    if (_navigationHistory.length > _maxHistorySize) {
      _navigationHistory.removeAt(0);
    }
  }
  
  /// Save navigation state to shared preferences
  Future<void> _saveNavigationState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Save current route
      await prefs.setString(_selectedRouteKey, _currentRoute);
      
      // Save navigation history
      await prefs.setStringList(_navigationHistoryKey, _navigationHistory);
    } catch (e) {
      // Log error but don't crash
      debugPrint('Failed to save navigation state: $e');
    }
  }
  
  /// Load navigation state from shared preferences
  Future<void> _loadNavigationState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load current route
      _currentRoute = prefs.getString(_selectedRouteKey) ?? '/';
      
      // Load navigation history
      final history = prefs.getStringList(_navigationHistoryKey) ?? ['/'];
      _navigationHistory.clear();
      _navigationHistory.addAll(history);
      
      // Set previous route if history has more than one item
      if (_navigationHistory.length > 1) {
        _previousRoute = _navigationHistory[_navigationHistory.length - 2];
      }
    } catch (e) {
      // Log error but don't crash
      debugPrint('Failed to load navigation state: $e');
      
      // Reset to defaults
      _currentRoute = '/';
      _previousRoute = '/';
      _navigationHistory.clear();
      _navigationHistory.add('/');
    }
  }
  
  /// Check if a route is the current route
  bool isCurrentRoute(String route) {
    return _currentRoute == route;
  }
  
  /// Check if a route is in the navigation history
  bool isInHistory(String route) {
    return _navigationHistory.contains(route);
  }
}