// Analytics models for ATLAS Wallet monitoring
// Part of Task 8: Operations & Monitoring implementation

/// Core analytics data point
class AnalyticsData {
  final String eventId;
  final String eventName;
  final Map<String, dynamic> properties;
  final DateTime timestamp;
  final String userId;
  final String sessionId;
  final String appVersion;
  final String platform;
  final String deviceId;

  AnalyticsData({
    required this.eventId,
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
      'eventId': eventId,
      'eventName': eventName,
      'properties': properties,
      'timestamp': timestamp.toIso8601String(),
      'userId': userId,
      'sessionId': sessionId,
      'appVersion': appVersion,
      'platform': platform,
      'deviceId': deviceId,
    };
  }

  factory AnalyticsData.fromJson(Map<String, dynamic> json) {
    return AnalyticsData(
      eventId: json['eventId'] ?? '',
      eventName: json['eventName'] ?? '',
      properties: Map<String, dynamic>.from(json['properties'] ?? {}),
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      userId: json['userId'] ?? '',
      sessionId: json['sessionId'] ?? '',
      appVersion: json['appVersion'] ?? '',
      platform: json['platform'] ?? '',
      deviceId: json['deviceId'] ?? '',
    );
  }
}

/// Performance metric model
class PerformanceMetric {
  final String metricName;
  final double value;
  final String unit;
  final String category;
  final DateTime timestamp;
  final Map<String, dynamic> context;

  PerformanceMetric({
    required this.metricName,
    required this.value,
    required this.unit,
    required this.category,
    required this.timestamp,
    this.context = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'metricName': metricName,
      'value': value,
      'unit': unit,
      'category': category,
      'timestamp': timestamp.toIso8601String(),
      'context': context,
    };
  }
}

/// Error/crash report model
class ErrorReport {
  final String errorId;
  final String errorMessage;
  final String errorType;
  final StackTrace? stackTrace;
  final String severity;
  final DateTime timestamp;
  final String userId;
  final String sessionId;
  final Map<String, dynamic> context;
  final Map<String, dynamic> deviceInfo;
  final Map<String, dynamic> appState;

  ErrorReport({
    required this.errorId,
    required this.errorMessage,
    required this.errorType,
    this.stackTrace,
    required this.severity,
    required this.timestamp,
    required this.userId,
    required this.sessionId,
    this.context = const {},
    this.deviceInfo = const {},
    this.appState = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'errorId': errorId,
      'errorMessage': errorMessage,
      'errorType': errorType,
      'stackTrace': stackTrace?.toString(),
      'severity': severity,
      'timestamp': timestamp.toIso8601String(),
      'userId': userId,
      'sessionId': sessionId,
      'context': context,
      'deviceInfo': deviceInfo,
      'appState': appState,
    };
  }
}

/// Session model
class Session {
  final String sessionId;
  final String userId;
  final DateTime startTime;
  DateTime? endTime;
  final String platform;
  final String appVersion;
  final Map<String, dynamic> deviceInfo;
  final List<AnalyticsData> events;

  Duration get duration => endTime?.difference(startTime) ?? Duration.zero;
  bool get isActive => endTime == null;

  Session({
    required this.sessionId,
    required this.userId,
    required this.startTime,
    this.endTime,
    required this.platform,
    required this.appVersion,
    required this.deviceInfo,
    List<AnalyticsData>? events,
  }) : events = events ?? [];

  void addEvent(AnalyticsData event) {
    events.add(event);
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'userId': userId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'platform': platform,
      'appVersion': appVersion,
      'deviceInfo': deviceInfo,
      'durationSeconds': duration.inSeconds,
      'eventCount': events.length,
    };
  }
}

/// User profile analytics
class UserAnalyticsProfile {
  final String userId;
  final DateTime firstSeen;
  final DateTime lastSeen;
  final int totalSessions;
  final Duration totalSessionTime;
  final Map<String, int> featureUsage;
  final Map<String, int> errorCounts;
  final String engagementTier; // 'low', 'medium', 'high', 'power'
  final double retentionScore;
  final Map<String, dynamic> preferences;

  UserAnalyticsProfile({
    required this.userId,
    required this.firstSeen,
    required this.lastSeen,
    required this.totalSessions,
    required this.totalSessionTime,
    required this.featureUsage,
    required this.errorCounts,
    required this.engagementTier,
    required this.retentionScore,
    required this.preferences,
  });

  Duration get averageSessionDuration {
    return totalSessions > 0 ? Duration(seconds: totalSessionTime.inSeconds ~/ totalSessions) : Duration.zero;
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'firstSeen': firstSeen.toIso8601String(),
      'lastSeen': lastSeen.toIso8601String(),
      'totalSessions': totalSessions,
      'totalSessionTimeSeconds': totalSessionTime.inSeconds,
      'averageSessionDurationSeconds': averageSessionDuration.inSeconds,
      'featureUsage': featureUsage,
      'errorCounts': errorCounts,
      'engagementTier': engagementTier,
      'retentionScore': retentionScore,
      'preferences': preferences,
    };
  }

  static String calculateEngagementTier(
    int totalSessions,
    Duration totalSessionTime,
    int daysSinceFirstSeen,
  ) {
    final avgSessionsPerWeek = totalSessions / (daysSinceFirstSeen / 7);
    final avgTimePerWeek = totalSessionTime.inMinutes / (daysSinceFirstSeen / 7);

    if (avgSessionsPerWeek >= 5 && avgTimePerWeek >= 120) { // 2+ hours/day
      return 'power';
    } else if (avgSessionsPerWeek >= 3 && avgTimePerWeek >= 60) {
      return 'high';
    } else if (avgSessionsPerWeek >= 1 && avgTimePerWeek >= 15) {
      return 'medium';
    } else {
      return 'low';
    }
  }
}

/// Feature usage analytics
class FeatureUsage {
  final String featureName;
  final String category;
  final int totalUsage;
  final Map<String, int> usageByUserType;
  final Map<String, int> hourlyUsage;
  final Map<String, int> dailyUsage;
  final double averageUsageTime;
  final double conversionRate;
  final Map<String, dynamic> additionalMetrics;

  FeatureUsage({
    required this.featureName,
    required this.category,
    required this.totalUsage,
    required this.usageByUserType,
    required this.hourlyUsage,
    required this.dailyUsage,
    required this.averageUsageTime,
    required this.conversionRate,
    required this.additionalMetrics,
  });

  Map<String, dynamic> toJson() {
    return {
      'featureName': featureName,
      'category': category,
      'totalUsage': totalUsage,
      'usageByUserType': usageByUserType,
      'hourlyUsage': hourlyUsage,
      'dailyUsage': dailyUsage,
      'averageUsageTime': averageUsageTime,
      'conversionRate': conversionRate,
      'additionalMetrics': additionalMetrics,
    };
  }
}

/// Analytics dashboard summary
class AnalyticsDashboardSummary {
  final int totalUsers;
  final int activeUsersToday;
  final int activeUsersThisWeek;
  final int totalSessionsToday;
  final double averageSessionDuration;
  final int totalEventsToday;
  final int errorCountToday;
  final double crashRate;
  final double appPerformanceScore;
  final Map<String, int> topFeatures;
  final Map<String, int> errorsByType;
  final Map<String, double> userRetentionRates;
  final DateTime lastUpdated;

  AnalyticsDashboardSummary({
    required this.totalUsers,
    required this.activeUsersToday,
    required this.activeUsersThisWeek,
    required this.totalSessionsToday,
    required this.averageSessionDuration,
    required this.totalEventsToday,
    required this.errorCountToday,
    required this.crashRate,
    required this.appPerformanceScore,
    required this.topFeatures,
    required this.errorsByType,
    required this.userRetentionRates,
    required this.lastUpdated,
  });

  Map<String, dynamic> toJson() {
    return {
      'totalUsers': totalUsers,
      'activeUsersToday': activeUsersToday,
      'activeUsersThisWeek': activeUsersThisWeek,
      'totalSessionsToday': totalSessionsToday,
      'averageSessionDuration': averageSessionDuration,
      'totalEventsToday': totalEventsToday,
      'errorCountToday': errorCountToday,
      'crashRate': crashRate,
      'appPerformanceScore': appPerformanceScore,
      'topFeatures': topFeatures,
      'errorsByType': errorsByType,
      'userRetentionRates': userRetentionRates,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}

/// Device information model
class DeviceInfo {
  final String platform;
  final String osVersion;
  final String deviceModel;
  final String deviceId;
  final String screenResolution;
  final int memoryMB;
  final String cpuArchitecture;
  final String appVersion;
  final String buildNumber;
  final Map<String, dynamic> additionalInfo;

  DeviceInfo({
    required this.platform,
    required this.osVersion,
    required this.deviceModel,
    required this.deviceId,
    required this.screenResolution,
    required this.memoryMB,
    required this.cpuArchitecture,
    required this.appVersion,
    required this.buildNumber,
    this.additionalInfo = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'platform': platform,
      'osVersion': osVersion,
      'deviceModel': deviceModel,
      'deviceId': deviceId,
      'screenResolution': screenResolution,
      'memoryMB': memoryMB,
      'cpuArchitecture': cpuArchitecture,
      'appVersion': appVersion,
      'buildNumber': buildNumber,
      'additionalInfo': additionalInfo,
    };
  }
}

/// Conversion funnel analysis
class ConversionFunnel {
  final String funnelName;
  final List<FunnelStep> steps;
  final DateTime analysisPeriodStart;
  final DateTime analysisPeriodEnd;
  final double overallConversionRate;

  ConversionFunnel({
    required this.funnelName,
    required this.steps,
    required this.analysisPeriodStart,
    required this.analysisPeriodEnd,
    required this.overallConversionRate,
  });

  Map<String, dynamic> toJson() {
    return {
      'funnelName': funnelName,
      'steps': steps.map((step) => step.toJson()).toList(),
      'analysisPeriodStart': analysisPeriodStart.toIso8601String(),
      'analysisPeriodEnd': analysisPeriodEnd.toIso8601String(),
      'overallConversionRate': overallConversionRate,
    };
  }
}

/// Funnel step model
class FunnelStep {
  final String stepName;
  final String eventName;
  final int userCount;
  final double conversionRateFromPrevious;
  final double conversionRateFromStart;
  final Duration averageTimeToConvert;

  FunnelStep({
    required this.stepName,
    required this.eventName,
    required this.userCount,
    required this.conversionRateFromPrevious,
    required this.conversionRateFromStart,
    required this.averageTimeToConvert,
  });

  Map<String, dynamic> toJson() {
    return {
      'stepName': stepName,
      'eventName': eventName,
      'userCount': userCount,
      'conversionRateFromPrevious': conversionRateFromPrevious,
      'conversionRateFromStart': conversionRateFromStart,
      'averageTimeToConvertSeconds': averageTimeToConvert.inSeconds,
    };
  }
}
