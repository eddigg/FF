import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../models/analytics_model.dart';

/// Analytics service for tracking user behavior, performance, and crashes
class AnalyticsService {
  static const String _version = '1.0.0';
  static const Duration _batchInterval = Duration(minutes: 5);
  static const int _maxBatchSize = 100;

  final String _apiUrl;
  final String _appVersion;
  final String _appId;
  final String _deviceId;
  final String _platform;

  final StreamController<AnalyticsEvent> _eventController = StreamController<AnalyticsEvent>.broadcast();
  final List<AnalyticsEvent> _eventBuffer = [];
  Timer? _batchTimer;

  bool _isInitialized = false;
  bool _isEnabled = true;

  AnalyticsService({
    required String apiUrl,
    required String appVersion,
    required String appId,
    required String deviceId,
    required String platform,
  }) : _apiUrl = apiUrl,
       _appVersion = appVersion,
       _appId = appId,
       _deviceId = deviceId,
       _platform = platform;

  /// Initialize the analytics service
  Future<void> initialize() async {
    if (_isInitialized) return;

    _isInitialized = true;

    // Start periodic batch sending
    _batchTimer = Timer.periodic(_batchInterval, (_) => _flushEvents());

    // Track app launch
    await trackEvent('app_launch', {
      'app_version': _appVersion,
      'platform': _platform,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Dispose the analytics service
  void dispose() {
    _batchTimer?.cancel();
    _eventController.close();
  }

  /// Enable or disable analytics tracking
  void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  /// Track a custom event
  Future<void> trackEvent(String eventName, Map<String, dynamic> properties) async {
    if (!_isEnabled || !_isInitialized) return;

    final event = AnalyticsEvent(
      id: const Uuid().v4(),
      eventName: eventName,
      properties: properties,
      timestamp: DateTime.now(),
      userId: await _getUserId(),
      sessionId: await _getSessionId(),
      appVersion: _appVersion,
      platform: _platform,
      deviceId: _deviceId,
    );

    _eventBuffer.add(event);
    _eventController.add(event);

    // Send immediately if event is critical (crash, error)
    if (_isCriticalEvent(eventName)) {
      await _sendBatch([event]);
    }

    // Flush if buffer is full
    if (_eventBuffer.length >= _maxBatchSize) {
      await _flushEvents();
    }
  }

  /// Track screen view
  Future<void> trackScreenView(String screenName, {Map<String, dynamic>? properties}) async {
    await trackEvent('screen_view', {
      'screen_name': screenName,
      ...?properties,
    });
  }

  /// Track user interaction
  Future<void> trackInteraction(String elementName, String interactionType,
      {Map<String, dynamic>? properties}) async {
    await trackEvent('user_interaction', {
      'element_name': elementName,
      'interaction_type': interactionType,
      ...?properties,
    });
  }

  /// Track transaction
  Future<void> trackTransaction(String transactionType, double amount,
      {String? assetType, Map<String, dynamic>? properties}) async {
    await trackEvent('transaction', {
      'transaction_type': transactionType,
      'amount': amount,
      'asset_type': assetType,
      'currency': 'USD',
      ...?properties,
    });
  }

  /// Track performance metrics
  Future<void> trackPerformance(String metricName, double value,
      {Map<String, dynamic>? properties}) async {
    await trackEvent('performance_metric', {
      'metric_name': metricName,
      'value': value,
      'unit': _getPerformanceUnit(metricName),
      ...?properties,
    });
  }

  /// Track error/crash
  Future<void> trackError(String errorMessage, {StackTrace? stackTrace, Map<String, dynamic>? properties}) async {
    await trackEvent('error', {
      'error_message': errorMessage,
      'stack_trace': stackTrace?.toString(),
      'error_type': 'dart_error',
      ...?properties,
    });
  }

  /// Track session end
  Future<void> trackSessionEnd(int sessionDurationSeconds) async {
    await trackEvent('session_end', {
      'duration_seconds': sessionDurationSeconds,
      'session_quality': _calculateSessionQuality(sessionDurationSeconds),
    });
  }

  /// Get analytics stream for real-time monitoring
  Stream<AnalyticsEvent> get eventStream => _eventController.stream;

  /// Flush pending events immediately
  Future<void> flush() async {
    await _flushEvents();
  }

  /// Get current analytics stats
  Future<AnalyticsStats> getStats() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final todayEvents = _eventBuffer.where((event) =>
      event.timestamp.isAfter(today)
    ).toList();

    final errors = todayEvents.where((event) => event.eventName == 'error').length;
    final sessions = todayEvents.where((event) => event.eventName == 'session_end').length;

    return AnalyticsStats(
      totalEvents: _eventBuffer.length,
      todayEvents: todayEvents.length,
      errorsToday: errors,
      sessionsToday: sessions,
      averageSessionDuration: _calculateAverageSessionDuration(),
      crashRate: sessions > 0 ? (errors / sessions) * 100 : 0,
      lastEventTime: _eventBuffer.isNotEmpty ? _eventBuffer.last.timestamp : null,
    );
  }

  // Internal methods

  Future<String> _getUserId() async {
    // In a real implementation, this would get from secure storage
    return 'user_${_deviceId}';
  }

  Future<String> _getSessionId() async {
    // In a real implementation, this would be stored and retrieved from storage
    return 'session_${DateTime.now().millisecondsSinceEpoch}';
  }

  bool _isCriticalEvent(String eventName) {
    final criticalEvents = ['error', 'crash', 'auth_failure', 'payment_failure'];
    return criticalEvents.contains(eventName);
  }

  String _getPerformanceUnit(String metricName) {
    final unitMap = {
      'app_start_time': 'milliseconds',
      'frame_render_time': 'milliseconds',
      'network_request_time': 'milliseconds',
      'memory_usage': 'MB',
      'cpu_usage': 'percentage',
      'battery_level': 'percentage',
    };
    return unitMap[metricName] ?? 'unknown';
  }

  String _calculateSessionQuality(int durationSeconds) {
    if (durationSeconds < 30) return 'poor';
    if (durationSeconds < 300) return 'fair';
    if (durationSeconds < 1800) return 'good';
    return 'excellent';
  }

  double _calculateAverageSessionDuration() {
    final sessionEvents = _eventBuffer.where((event) => event.eventName == 'session_end');
    if (sessionEvents.isEmpty) return 0;

    final totalDuration = sessionEvents.fold<int>(0, (sum, event) {
      return sum + (event.properties['duration_seconds'] as int? ?? 0);
    });

    return totalDuration / sessionEvents.length;
  }

  Future<void> _flushEvents() async {
    if (_eventBuffer.isEmpty) return;

    final eventsToSend = List<AnalyticsEvent>.from(_eventBuffer);
    _eventBuffer.clear();

    await _sendBatch(eventsToSend);
  }

  Future<void> _sendBatch(List<AnalyticsEvent> events) async {
    if (events.isEmpty) return;

    try {
      final payload = {
        'app_id': _appId,
        'version': _version,
        'platform': _platform,
        'events': events.map((e) => e.toJson()).toList(),
        'timestamp': DateTime.now().toIso8601String(),
      };

      final response = await http.post(
        Uri.parse('$_apiUrl/v1/analytics/events'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await _getAuthToken()}',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success - events sent
      } else {
        // Failed to send - could implement retry logic
        _eventBuffer.insertAll(0, events); // Re-add to buffer for retry
      }
    } catch (e) {
      // Network error - re-add to buffer for retry
      _eventBuffer.insertAll(0, events);
    }
  }

  Future<String> _getAuthToken() async {
    // In a real implementation, this would get from secure storage
    return 'analytics_token_placeholder';
  }
}

/// Analytics event model
class AnalyticsEvent {
  final String id;
  final String eventName;
  final Map<String, dynamic> properties;
  final DateTime timestamp;
  final String userId;
  final String sessionId;
  final String appVersion;
  final String platform;
  final String deviceId;

  AnalyticsEvent({
    required this.id,
    required this.eventName,
    required this.properties,
    required this.timestamp,
    required this.userId,
    required this.sessionId,
    required this.appVersion,
    required this.platform,
    required this.deviceId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_name': eventName,
      'properties': properties,
      'timestamp': timestamp.toIso8601String(),
      'user_id': userId,
      'session_id': sessionId,
      'app_version': appVersion,
      'platform': platform,
      'device_id': deviceId,
    };
  }

  factory AnalyticsEvent.fromJson(Map<String, dynamic> json) {
    return AnalyticsEvent(
      id: json['id'],
      eventName: json['event_name'],
      properties: Map<String, dynamic>.from(json['properties']),
      timestamp: DateTime.parse(json['timestamp']),
      userId: json['user_id'],
      sessionId: json['session_id'],
      appVersion: json['app_version'],
      platform: json['platform'],
      deviceId: json['device_id'],
    );
  }
}

/// Analytics statistics
class AnalyticsStats {
  final int totalEvents;
  final int todayEvents;
  final int errorsToday;
  final int sessionsToday;
  final double averageSessionDuration;
  final double crashRate;
  final DateTime? lastEventTime;

  AnalyticsStats({
    required this.totalEvents,
    required this.todayEvents,
    required this.errorsToday,
    required this.sessionsToday,
    required this.averageSessionDuration,
    required this.crashRate,
    this.lastEventTime,
  });
}

/// Performance monitoring service
class PerformanceMonitoringService {
  final AnalyticsService _analyticsService;
  final Map<String, DateTime> _activeTimers = {};

  PerformanceMonitoringService(this._analyticsService);

  /// Start timing an operation
  void startTimer(String operationName) {
    _activeTimers[operationName] = DateTime.now();
  }

  /// End timing and record duration
  Future<void> endTimer(String operationName, {Map<String, dynamic>? properties}) async {
    final startTime = _activeTimers.remove(operationName);
    if (startTime != null) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      await _analyticsService.trackPerformance(operationName, duration.toDouble(), properties: properties);
    }
  }

  /// Record navigation timing
  Future<void> recordNavigationTiming(RouteTiming timing) async {
    await _analyticsService.trackEvent('navigation_timing', {
      'route_name': timing.routeName,
      'build_time': timing.buildTime,
      'render_time': timing.renderTime,
      'total_time': timing.totalTime,
    });
  }
}

/// Route timing information
class RouteTiming {
  final String routeName;
  final int buildTime; // milliseconds
  final int renderTime; // milliseconds
  final int totalTime; // milliseconds

  RouteTiming({
    required this.routeName,
    required this.buildTime,
    required this.renderTime,
    required this.totalTime,
  });
}
