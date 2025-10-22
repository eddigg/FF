# ATLAS Wallet Portal - Operations & Monitoring (Task 8)

This directory contains the complete operations and monitoring infrastructure for the ATLAS Wallet Portal, implementing Task 8 deliverables.

## Overview

Task 8 establishes production operations and monitoring capabilities across all components of the ATLAS ecosystem:

- **Application Monitoring**: Real-time Flutter app performance and crash reporting
- **User Analytics**: Usage patterns and engagement metrics dashboard
- **Alerting System**: Automated notifications for critical issues
- **Backup & Recovery**: Automated backup procedures with testing
- **Unified Monitoring Dashboard**: Web interface consolidating all metrics

## Architecture

```
operations/monitoring/
├── dashboards/           # Unified monitoring dashboard
│   ├── unified_dashboard.go      # Main dashboard backend (Go)
│   └── templates/
│       └── index.html           # Web dashboard frontend
├── analytics/            # Analytics collection & processing
├── alerts/               # Alert management system
├── metrics/             # Metrics collection & aggregation
├── backup/               # Backup & recovery procedures
│   └── backup_procedures.go     # Comprehensive backup manager
└── config/               # Configuration management
```

## Components

### 1. Unified Monitoring Dashboard

**Location**: `operations/monitoring/dashboards/`

**Features**:
- Real-time metrics from blockchain, Flutter apps, and system
- Interactive web interface with charts and graphs
- Alert management with acknowledgment system
- Historical data visualization
- RESTful API for external integrations

**Tech Stack**:
- Go backend with HTTP server
- HTML/CSS/JavaScript frontend (Bootstrap + Chart.js)
- WebSocket support for real-time updates
- JSON API endpoints

**Key Endpoints**:
```
GET  /api/metrics           # Current system metrics
GET  /api/alerts           # Active alerts
POST /api/alerts/ack/{id}   # Acknowledge alert
GET  /api/analytics        # Analytics data
GET  /api/system/status    # System health status
```

### 2. Flutter Analytics SDK

**Location**: `products/wallets/mobile/lib/services/analytics_service.dart`

**Features**:
- Comprehensive event tracking (screen views, interactions, transactions)
- Performance monitoring (app start time, network requests, battery usage)
- Crash reporting with stack traces
- Session management and user behavior analytics
- Batch event transmission with retry logic
- Privacy-compliant data collection

**Supported Events**:
- `app_launch`: App startup tracking
- `screen_view`: Screen navigation tracking
- `user_interaction`: UI interaction tracking
- `transaction`: Financial transaction logging
- `performance_metric`: Performance measurement
- `error`: Error and crash reporting
- `session_end`: Session analytics

### 3. Alert Management System

**Features**:
- Configurable alert rules with conditions
- Multi-channel notifications (Email, Slack, Webhooks)
- Severity levels (Info, Warning, Error, Critical)
- Cooldown periods to prevent spam
- Alert acknowledgment and resolution tracking
- Automated rule evaluation every 30 seconds

**Sample Alert Rules**:
```json
{
  "id": "high_cpu",
  "name": "High CPU Usage",
  "condition": "cpu_usage > 80",
  "severity": "warning",
  "channels": ["email", "slack"]
}
```

### 4. Backup & Recovery System

**Location**: `operations/monitoring/backup/`

**Features**:
- Automated scheduled backups (daily by default)
- Point-in-time recovery capabilities
- Compression and optional encryption
- Backup integrity verification
- Retention policy management (30 days default)
- Multi-path backup support with priorities
- Test restore validation

**Default Configuration**:
```json
{
  "backup_frequency": "24h",
  "retention_period": "720h", // 30 days
  "max_backup_size": "107374182400", // 100GB
  "encryption_enabled": true,
  "test_restores_enabled": true
}
```

**Supported Paths**:
- Blockchain core data
- Analytics databases
- Monitoring data
- Configuration files

## Installation & Setup

### Prerequisites

- Go 1.19+ (for dashboard backend)
- Flutter 3.0+ (for mobile analytics)
- Node.js (optional, for additional tooling)

### Dashboard Setup

```bash
# Navigate to dashboard directory
cd operations/monitoring/dashboards

# Build the dashboard
go build -o dashboard unified_dashboard.go

# Run with default configuration
./dashboard

# Or specify port
./dashboard -port 9090

# Or load custom config
./dashboard -config /path/to/dashboard_config.json
```

### Flutter Analytics Integration

Add to your Flutter app:

```dart
import 'services/analytics_service.dart';

// Initialize analytics
final analytics = AnalyticsService(
  apiUrl: 'https://your-analytics-endpoint.com',
  appVersion: '1.0.0',
  appId: 'atlas-wallet',
  deviceId: await getDeviceId(),
  platform: Platform.isAndroid ? 'android' : 'ios',
);

await analytics.initialize();

// Track events
await analytics.trackScreenView('wallet_home');
await analytics.trackTransaction('send', 0.5, assetType: 'BTC');

// Track performance
await analytics.trackPerformance('app_start_time', startTime);
```

### Backup System Setup

```bash
# Build backup manager
cd operations/monitoring/backup
go build -o backup-manager backup_procedures.go

# Create initial backup
./backup-manager backup --full

# Schedule automated backups
./backup-manager schedule

# List available backups
./backup-manager list

# Restore from backup
./backup-manager restore --id backup_1234567890_manual --target /restore/path
```

## Configuration

### Dashboard Configuration

Create a JSON configuration file:

```json
{
  "port": 8080,
  "alert_rules": [
    {
      "id": "high_cpu",
      "name": "High CPU Usage",
      "condition": "cpu_usage > 80",
      "severity": "warning",
      "enabled": true,
      "cooldown_min": 15,
      "channels": ["email", "slack"]
    }
  ],
  "metrics_refresh_interval": 30,
  "max_history_hours": 168
}
```

### Analytics SDK Configuration

```dart
final analyticsConfig = AnalyticsConfig(
  apiUrl: 'https://api.atlas.io/analytics',
  appVersion: '1.0.0',
  appId: 'atlas-wallet',
  batchInterval: Duration(minutes: 5),
  maxBatchSize: 100,
  enableCrashReporting: true,
  enablePerformanceTracking: true,
  privacyLevel: PrivacyLevel.anonymous,
);
```

### Backup Configuration

See `DefaultBackupConfig()` in `backup_procedures.go` for available options.

## Monitoring & Maintenance

### Health Checks

The system provides comprehensive health checks:

```bash
# Check dashboard health
curl http://localhost:8080/api/system/status

# Check analytics connectivity
# (Built into Flutter SDK)

# Check backup status
./backup-manager status
```

### Alert Management

```bash
# Via API
curl -X GET http://localhost:8080/api/alerts
curl -X POST http://localhost:8080/api/alerts/ack/alert_123

# Threshold configuration in dashboard config
```

### Backup Verification

```bash
# Test restore procedure
./backup-manager verify backup_1234567890_manual

# Check backup integrity
./backup-manager integrity backup_1234567890_manual
```

## API Reference

### Dashboard Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/` | GET | Dashboard web interface |
| `/api/metrics` | GET | Current system metrics |
| `/api/alerts` | GET | List all alerts |
| `/api/alerts/ack/{id}` | POST | Acknowledge alert |
| `/api/analytics` | GET | Analytics data summary |
| `/api/system/status` | GET | System health status |
| `/ws` | WS | WebSocket connection for real-time updates |

### Analytics SDK Methods

```dart
// Event tracking
Future<void> trackEvent(String name, Map<String, dynamic> properties)
Future<void> trackScreenView(String screenName, {Map<String, dynamic>? properties})
Future<void> trackInteraction(String element, String interaction, {Map<String, dynamic>? properties})
Future<void> trackTransaction(String type, double amount, {String? asset, Map<String, dynamic>? properties})
Future<void> trackPerformance(String metric, double value, {Map<String, dynamic>? properties})
Future<void> trackError(String error, {StackTrace? stackTrace, Map<String, dynamic>? properties})

// Session management
Future<void> trackSessionEnd(int durationSeconds)

// Data management
Future<void> flush() // Force send pending events
Future<AnalyticsStats> getStats() // Get current statistics
Stream<AnalyticsEvent> get eventStream // Real-time event stream
```

### Backup Operations

```bash
# Manual backup
backup-manager backup --full
backup-manager backup --incremental

# Restore operations
backup-manager restore --id <backup_id> --target <path>
backup-manager restore --latest --target <path>

# Management
backup-manager list
backup-manager delete --id <backup_id>
backup-manager cleanup  # Remove expired backups

# Testing
backup-manager verify --id <backup_id>
```

## Security Considerations

### Analytics Data
- All sensitive data is hashed before transmission
- Configurable privacy levels
- GDPR-compliant data handling
- Optional data anonymization

### Backup Security
- AES-256 encryption support
- Key rotation capabilities
- Access control lists for backup files
- Secure deletion of old backups

### Dashboard Security
- Authentication middleware support
- HTTPS enforcement
- CORS configuration
- Rate limiting

## Performance Optimization

### Analytics
- Batch event transmission (configurable intervals)
- Offline event buffering
- Minimal performance impact on app
- Intelligent sampling for high-frequency events

### Dashboard
- Efficient metric aggregation
- Historical data compression
- Lazy loading for large datasets
- WebSocket for real-time updates only

### Backup
- Incremental backups after initial full backup
- Concurrent file processing
- Compression optimization
- Parallel upload/download

## Troubleshooting

### Common Issues

**Dashboard not starting**: Check port conflicts, Go version, and file permissions

**Analytics events not sending**: Verify network connectivity, API endpoints, and authentication tokens

**Backup failures**: Check disk space, file permissions, and storage connectivity

**High memory usage**: Adjust batch sizes, reduce history retention, or add more memory

### Logs and Debugging

```bash
# Dashboard logs
tail -f /var/log/atlas/dashboard.log

# Backup logs
./backup-manager logs --level debug

# Flutter analytics debugging
# Enable debug logging in AnalyticsService constructor
```

## Deployment

### Docker Deployment

```dockerfile
# Dashboard Dockerfile
FROM golang:1.19-alpine AS build
WORKDIR /app
COPY . .
RUN go build -o dashboard .

FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=build /app/dashboard .
COPY --from=build /app/templates ./templates
EXPOSE 8080
CMD ["./dashboard"]
```

### Kubernetes Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: atlas-dashboard
spec:
  replicas: 1
  selector:
    matchLabels:
      app: atlas-dashboard
  template:
    metadata:
      labels:
        app: atlas-dashboard
    spec:
      containers:
      - name: dashboard
        image: atlas/dashboard:latest
        ports:
        - containerPort: 8080
        env:
        - name: PORT
          value: "8080"
```

## Contributing

When contributing to the monitoring system:

1. Maintain backward compatibility for API endpoints
2. Add comprehensive tests for new features
3. Update documentation for configuration changes
4. Follow security best practices
5. Test backup/restore procedures thoroughly

## Support

For issues and support:
- Check logs in `/var/log/atlas/`
- Review configuration files
- Test with minimal reproduction cases
- Contact the operations team

## Version History

- **v1.0.0**: Initial Task 8 implementation
  - Complete dashboard with real-time metrics
  - Flutter analytics SDK
  - Alert management system
  - Automated backup system
  - Full documentation

---

**Task 8 Status**: ✅ **COMPLETED**

All deliverables implemented and integrated into the ATLAS ecosystem.
