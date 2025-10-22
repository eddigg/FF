package main

import (
	"encoding/json"
	"fmt"
	"html/template"
	"log"
	"net/http"
	"strconv"
	"strings"
	"time"
)

// Dashboard represents the unified monitoring dashboard
type Dashboard struct {
	server         *http.Server
	blockchainMonitor interface{} // Would be the real Monitor type
	flutterMonitor    interface{}
	alertManager     *AlertManager
	dataStore        *DataStore
	templates        *template.Template
	shutdownCh       chan struct{}
}

// AlertManager handles system alerts and notifications
type AlertManager struct {
	alerts       []*Alert
	rules        []*AlertRule
	notification NotificationService
}

// AlertRule defines when an alert should be triggered
type AlertRule struct {
	ID          string                 `json:"id"`
	Name        string                 `json:"name"`
	Description string                 `json:"description"`
	Condition   string                 `json:"condition"` // e.g., "cpu_usage > 80"
	Severity    string                 `json:"severity"` // "info", "warning", "error", "critical"
	Enabled     bool                   `json:"enabled"`
	CooldownMin int                    `json:"cooldown_min"`
	LastTrigger time.Time              `json:"last_trigger"`
	Channels    []string               `json:"channels"` // "email", "slack", "webhook"
	Metadata    map[string]interface{} `json:"metadata"`
}

// Alert represents a triggered alert
type Alert struct {
	ID        string                 `json:"id"`
	RuleID    string                 `json:"rule_id"`
	Severity  string                 `json:"severity"`
	Message   string                 `json:"message"`
	Value     float64                `json:"value"`
	Threshold float64                `json:"threshold"`
	Status    string                 `json:"status"` // "active", "acked", "resolved"
	Timestamp time.Time              `json:"timestamp"`
	AckedAt   *time.Time             `json:"acked_at,omitempty"`
	AckedBy   string                 `json:"acked_by,omitempty"`
	Source    string                 `json:"source"` // "blockchain", "flutter", "system"
	Details   map[string]interface{} `json:"details"`
}

// NotificationService handles sending notifications
type NotificationService struct {
	emailConfig    *EmailConfig
	slackConfig    *SlackConfig
	webhookConfigs []*WebhookConfig
}

// DashboardMetrics holds all metrics for the dashboard
type DashboardMetrics struct {
	SystemStatus     *SystemStatus     `json:"system_status"`
	BlockchainStatus *BlockchainStatus `json:"blockchain_status"`
	FlutterStatus    *FlutterStatus    `json:"flutter_status"`
	AnalyticsData    *AnalyticsData    `json:"analytics_data"`
	AlertSummary     *AlertSummary     `json:"alert_summary"`
	Timestamp        time.Time         `json:"timestamp"`
}

type SystemStatus struct {
	CPUUsage        float64 `json:"cpu_usage"`
	MemoryUsage     float64 `json:"memory_usage"`
	DiskUsage       float64 `json:"disk_usage"`
	NetworkIO       float64 `json:"network_io"`
	UptimeHours     int     `json:"uptime_hours"`
	TotalProcesses  int     `json:"total_processes"`
	HealthScore     int     `json:"health_score"`
}

type BlockchainStatus struct {
	BlockHeight         int64   `json:"block_height"`
	TPS                 float64 `json:"tps"`
	BlockTime           float64 `json:"block_time"`
	ActivePeers         int     `json:"active_peers"`
	ValidatorCount      int     `json:"validator_count"`
	PendingTransactions int     `json:"pending_transactions"`
	TotalStaked         float64 `json:"total_staked"`
	ContractCount       int     `json:"contract_count"`
	SyncStatus          string  `json:"sync_status"`
}

type FlutterStatus struct {
	TotalUsers          int     `json:"total_users"`
	ActiveUsers         int     `json:"active_users"`
	AppCrashes          int     `json:"app_crashes"`
	AvgSessionDuration  float64 `json:"avg_session_duration"`
	AppPerformanceScore float64 `json:"app_performance_score"`
	VersionDistribution map[string]int `json:"version_distribution"`
	ErrorRate           float64 `json:"error_rate"`
	ResponseTime        float64 `json:"response_time"`
}

type AnalyticsData struct {
	UserEvents           []*UserEvent          `json:"user_events"`
	TransactionMetrics   map[string]int        `json:"transaction_metrics"`
	UsagePatterns        *UsagePatterns        `json:"usage_patterns"`
	RevenueMetrics       map[string]float64    `json:"revenue_metrics"`
	ConversionRates      map[string]float64    `json:"conversion_rates"`
	UserRetention        *RetentionMetrics     `json:"user_retention"`
}

type UserEvent struct {
	UserID    string                 `json:"user_id"`
	EventType string                 `json:"event_type"`
	Timestamp time.Time              `json:"timestamp"`
	Data      map[string]interface{} `json:"data"`
}

type UsagePatterns struct {
	PeakHours       []int            `json:"peak_hours"` // hours of day with highest usage
	TopFeatures     map[string]int   `json:"top_features"`
	DeviceBreakdown map[string]int   `json:"device_breakdown"`
	RegionStats     map[string]int   `json:"region_stats"`
	SessionMetrics  *SessionMetrics  `json:"session_metrics"`
}

type SessionMetrics struct {
	AverageDuration float64 `json:"average_duration"`
	TotalSessions   int     `json:"total_sessions"`
	BounceRate      float64 `json:"bounce_rate"`
	ReturnRate      float64 `json:"return_rate"`
}

type RetentionMetrics struct {
	Day1  float64 `json:"day_1"`
	Day7  float64 `json:"day_7"`
	Day30 float64 `json:"day_30"`
	Day90 float64 `json:"day_90"`
}

type AlertSummary struct {
	Total     int            `json:"total"`
	Active    int            `json:"active"`
	Critical  int            `json:"critical"`
	Warnings  int            `json:"warnings"`
	BySource  map[string]int `json:"by_source"`
	Recent    []*Alert       `json:"recent,omitempty"`
}

// DataStore manages data persistence for dashboard
type DataStore struct {
	alerts         []*Alert
	analyticsData []*AnalyticsData
	metricsHistory []*DashboardMetrics
	maxHistorySize int
}

func NewDashboard() *Dashboard {
	return &Dashboard{
		alertManager: NewAlertManager(),
		dataStore:    NewDataStore(),
		shutdownCh:   make(chan struct{}),
	}
}

func NewAlertManager() *AlertManager {
	return &AlertManager{
		alerts: make([]*Alert, 0),
		rules:  make([]*AlertRule, 0),
		notification: NotificationService{
			emailConfig: &EmailConfig{},
			slackConfig: &SlackConfig{},
		},
	}
}

func NewDataStore() *DataStore {
	return &DataStore{
		alerts:         make([]*Alert, 0),
		analyticsData:  make([]*AnalyticsData, 0),
		metricsHistory: make([]*DashboardMetrics, 0),
		maxHistorySize: 1000,
	}
}

// Add default alert rules
func (am *AlertManager) InitializeDefaultRules() {
	defaultRules := []*AlertRule{
		{
			ID:          "high_cpu",
			Name:        "High CPU Usage",
			Description: "System CPU usage exceeds 80%",
			Condition:   "cpu_usage > 80",
			Severity:    "warning",
			Enabled:     true,
			CooldownMin: 15,
			Channels:    []string{"email", "slack"},
		},
		{
			ID:          "high_memory",
			Name:        "High Memory Usage",
			Description: "System memory usage exceeds 90%",
			Condition:   "memory_usage > 90",
			Severity:    "critical",
			Enabled:     true,
			CooldownMin: 10,
			Channels:    []string{"email", "slack", "webhook"},
		},
		{
			ID:          "low_tps",
			Name:        "Low Transaction Throughput",
			Description: "TPS drops below 5 transactions/second",
			Condition:   "tps < 5",
			Severity:    "error",
			Enabled:     true,
			CooldownMin: 5,
			Channels:    []string{"email"},
		},
		{
			ID:          "network_issues",
			Name:        "Network Latency Issues",
			Description: "Network latency exceeds 200ms",
			Condition:   "network_latency > 200",
			Severity:    "warning",
			Enabled:     true,
			CooldownMin: 10,
			Channels:    []string{"slack"},
		},
		{
			ID:          "app_crashes",
			Name:        "High App Crash Rate",
			Description: "Flutter app crash rate exceeds 5%",
			Condition:   "crash_rate > 5",
			Severity:    "critical",
			Enabled:     true,
			CooldownMin: 15,
			Channels:    []string{"email", "slack"},
		},
	}

	am.rules = defaultRules
}

// Start starts the dashboard server
func (d *Dashboard) Start(port int) error {
	d.initializeTemplates()
	d.setupRoutes()

	d.server = &http.Server{
		Addr:         fmt.Sprintf(":%d", port),
		Handler:      nil, // Will be set by router
		ReadTimeout:  30 * time.Second,
		WriteTimeout: 30 * time.Second,
	}

	log.Printf("🚀 Starting unified monitoring dashboard on port %d", port)

	// Start background monitoring
	go d.startMonitoring()

	return d.server.ListenAndServe()
}

// Stop stops the dashboard server
func (d *Dashboard) Stop() error {
	close(d.shutdownCh)

	if d.server != nil {
		return d.server.Close()
	}
	return nil
}

// setupRoutes sets up HTTP routes
func (d *Dashboard) setupRoutes() {
	mux := http.NewServeMux()

	// Static files
	mux.Handle("/static/", http.StripPrefix("/static/", http.FileServer(http.Dir("static/"))))

	// Dashboard routes
	mux.HandleFunc("/", d.handleIndex)
	mux.HandleFunc("/api/metrics", d.handleMetrics)
	mux.HandleFunc("/api/alerts", d.handleAlerts)
	mux.HandleFunc("/api/alerts/ack/", d.handleAcknowledgeAlert)
	mux.HandleFunc("/api/analytics", d.handleAnalytics)
	mux.HandleFunc("/api/system/status", d.handleSystemStatus)

	// WebSocket for real-time updates
	mux.HandleFunc("/ws", d.handleWebSocket)

	d.server.Handler = mux
}

// initializeTemplates loads HTML templates
func (d *Dashboard) initializeTemplates() {
	d.templates = template.Must(template.ParseGlob("templates/*.html"))
}

// startMonitoring starts background monitoring goroutines
func (d *Dashboard) startMonitoring() {
	// Alert rule evaluation
	go func() {
		ticker := time.NewTicker(30 * time.Second)
		defer ticker.Stop()

		for {
			select {
			case <-ticker.C:
				d.evaluateAlertRules()
			case <-d.shutdownCh:
				return
			}
		}
	}()

	// Data cleanup
	go func() {
		ticker := time.NewTicker(1 * time.Hour)
		defer ticker.Stop()

		for {
			select {
			case <-ticker.C:
				d.cleanupOldData()
			case <-d.shutdownCh:
				return
			}
		}
	}()
}

// evaluateAlertRules evaluates all enabled alert rules
func (d *Dashboard) evaluateAlertRules() {
	metrics := d.getCurrentMetrics()

	for _, rule := range d.alertManager.rules {
		if !rule.Enabled {
			continue
		}

		// Check cooldown period
		if time.Since(rule.LastTrigger) < time.Duration(rule.CooldownMin)*time.Minute {
			continue
		}

		// Evaluate condition
		if d.evaluateCondition(rule.Condition, metrics) {
			alert := &Alert{
				ID:        fmt.Sprintf("%s_%d", rule.ID, time.Now().Unix()),
				RuleID:    rule.ID,
				Severity:  rule.Severity,
				Message:   rule.Description,
				Status:    "active",
				Timestamp: time.Now(),
				Source:    d.determineAlertSource(rule.Condition),
			}

			d.alertManager.alerts = append(d.alertManager.alerts, alert)
			rule.LastTrigger = time.Now()

			// Send notifications
			d.sendNotifications(alert, rule)

			log.Printf("🚨 ALERT: %s - %s", alert.Severity, alert.Message)
		}
	}
}

// evaluateCondition evaluates an alert rule condition
func (d *Dashboard) evaluateCondition(condition string, metrics *DashboardMetrics) bool {
	// Simple condition parser (e.g., "cpu_usage > 80")
	parts := strings.Fields(condition)
	if len(parts) != 3 {
		return false
	}

	metricName := parts[0]
	operator := parts[1]
	thresholdStr := parts[2]

	threshold, err := strconv.ParseFloat(thresholdStr, 64)
	if err != nil {
		return false
	}

	var currentValue float64

	// Get value from metrics based on metricName
	switch metricName {
	case "cpu_usage":
		currentValue = metrics.SystemStatus.CPUUsage
	case "memory_usage":
		currentValue = metrics.SystemStatus.MemoryUsage
	case "tps":
		currentValue = metrics.BlockchainStatus.TPS
	case "network_latency":
		// Would be extracted from blockchain metrics
		currentValue = 150 // Placeholder
	case "crash_rate":
		currentValue = metrics.FlutterStatus.ErrorRate
	default:
		return false
	}

	// Evaluate operator
	switch operator {
	case ">":
		return currentValue > threshold
	case "<":
		return currentValue < threshold
	case ">=":
		return currentValue >= threshold
	case "<=":
		return currentValue <= threshold
	case "==":
		return currentValue == threshold
	case "!=":
		return currentValue != threshold
	}

	return false
}

// determineAlertSource determines which component triggered the alert
func (d *Dashboard) determineAlertSource(condition string) string {
	if strings.Contains(condition, "cpu_usage") || strings.Contains(condition, "memory_usage") {
		return "system"
	}
	if strings.Contains(condition, "tps") || strings.Contains(condition, "block_time") {
		return "blockchain"
	}
	if strings.Contains(condition, "crash_rate") || strings.Contains(condition, "response_time") {
		return "flutter"
	}
	return "unknown"
}

// sendNotifications sends alert notifications via configured channels
func (d *Dashboard) sendNotifications(alert *Alert, rule *AlertRule) {
	// Implementation would send to email, slack, webhooks, etc.
	for _, channel := range rule.Channels {
		switch channel {
		case "email":
			d.sendEmailNotification(alert, rule)
		case "slack":
			d.sendSlackNotification(alert, rule)
		case "webhook":
			d.sendWebhookNotification(alert, rule)
		}
	}
}

// HTTP handlers

func (d *Dashboard) handleIndex(w http.ResponseWriter, r *http.Request) {
	data := struct {
		Title   string
		Version string
	}{
		Title:   "ATLAS Wallet Portal - Unified Monitoring Dashboard",
		Version: "1.0.0",
	}

	if err := d.templates.ExecuteTemplate(w, "index.html", data); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

func (d *Dashboard) handleMetrics(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Access-Control-Allow-Origin", "*")

	metrics := d.getCurrentMetrics()
	json.NewEncoder(w).Encode(metrics)
}

func (d *Dashboard) handleAlerts(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	alerts := struct {
		Alerts      []*Alert       `json:"alerts"`
		Summary     *AlertSummary  `json:"summary"`
		ActiveCount int            `json:"active_count"`
	}{
		Alerts:      d.alertManager.alerts,
		Summary:     d.getAlertSummary(),
		ActiveCount: d.getActiveAlertCount(),
	}

	json.NewEncoder(w).Encode(alerts)
}

func (d *Dashboard) handleAcknowledgeAlert(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	alertID := strings.TrimPrefix(r.URL.Path, "/api/alerts/ack/")
	if alertID == "" {
		http.Error(w, "Alert ID required", http.StatusBadRequest)
		return
	}

	if err := d.acknowledgeAlert(alertID, "web_user"); err != nil {
		http.Error(w, err.Error(), http.StatusNotFound)
		return
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]string{"status": "acknowledged"})
}

func (d *Dashboard) handleAnalytics(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	// Return analytics data
	analytics := d.getCurrentAnalytics()
	json.NewEncoder(w).Encode(analytics)
}

func (d *Dashboard) handleSystemStatus(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	status := d.getCurrentMetrics()
	json.NewEncoder(w).Encode(status.SystemStatus)
}

// Helper methods

func (d *Dashboard) getCurrentMetrics() *DashboardMetrics {
	return &DashboardMetrics{
		SystemStatus: &SystemStatus{
			CPUUsage:       45.2,
			MemoryUsage:    67.8,
			DiskUsage:      23.1,
			NetworkIO:      12.5,
			UptimeHours:    168,
			TotalProcesses: 456,
			HealthScore:    85,
		},
		BlockchainStatus: &BlockchainStatus{
			BlockHeight:         1250432,
			TPS:                 15.7,
			BlockTime:           8.5,
			ActivePeers:         24,
			ValidatorCount:      64,
			PendingTransactions: 89,
			TotalStaked:         1234567.89,
			ContractCount:       345,
			SyncStatus:          "synced",
		},
		FlutterStatus: &FlutterStatus{
			TotalUsers:         15430,
			ActiveUsers:        2350,
			AppCrashes:         23,
			AvgSessionDuration: 12.3,
			AppPerformanceScore: 94.5,
			VersionDistribution: map[string]int{
				"1.2.0": 8920,
				"1.1.5": 4560,
				"1.1.0": 1050,
			},
			ErrorRate:    0.8,
			ResponseTime: 245.0,
		},
		AlertSummary: d.getAlertSummary(),
		Timestamp:    time.Now(),
	}
}

func (d *Dashboard) getCurrentAnalytics() *AnalyticsData {
	return &AnalyticsData{
		TransactionMetrics: map[string]int{
			"send":    45230,
			"receive": 38760,
			"stake":   12450,
			"swap":    8760,
		},
		UsagePatterns: &UsagePatterns{
			PeakHours: []int{9, 10, 14, 15, 19, 20},
			TopFeatures: map[string]int{
				"send_money":     23450,
				"check_balance":  18930,
				"transaction_history": 15670,
				"stake_tokens":   8940,
			},
			DeviceBreakdown: map[string]int{
				"android":  8920,
				"ios":      6780,
				"web":      1850,
				"desktop":  560,
			},
			SessionMetrics: &SessionMetrics{
				AverageDuration: 12.3,
				TotalSessions:   34560,
				BounceRate:      23.4,
				ReturnRate:      68.9,
			},
		},
		UserRetention: &RetentionMetrics{
			Day1:  92.3,
			Day7:  78.6,
			Day30: 65.4,
			Day90: 54.2,
		},
	}
}

func (d *Dashboard) getAlertSummary() *AlertSummary {
	total := len(d.alertManager.alerts)
	active := 0
	critical := 0
	warnings := 0
	bySource := make(map[string]int)

	for _, alert := range d.alertManager.alerts {
		if alert.Status == "active" {
			active++
		}
		if alert.Severity == "critical" {
			critical++
		}
		if alert.Severity == "warning" {
			warnings++
		}
		bySource[alert.Source]++
	}

	return &AlertSummary{
		Total:    total,
		Active:   active,
		Critical: critical,
		Warnings: warnings,
		BySource: bySource,
	}
}

func (d *Dashboard) getActiveAlertCount() int {
	count := 0
	for _, alert := range d.alertManager.alerts {
		if alert.Status == "active" {
			count++
		}
	}
	return count
}

func (d *Dashboard) acknowledgeAlert(alertID, user string) error {
	for _, alert := range d.alertManager.alerts {
		if alert.ID == alertID {
			now := time.Now()
			alert.Status = "acked"
			alert.AckedAt = &now
			alert.AckedBy = user
			return nil
		}
	}
	return fmt.Errorf("alert not found")
}

func (d *Dashboard) cleanupOldData() {
	// Remove old alerts (older than 30 days)
	cutoff := time.Now().AddDate(0, 0, -30)
	var filteredAlerts []*Alert

	for _, alert := range d.alertManager.alerts {
		if alert.Timestamp.After(cutoff) {
			filteredAlerts = append(filteredAlerts, alert)
		}
	}

	d.alertManager.alerts = filteredAlerts

	// Remove old metrics history
	if len(d.dataStore.metricsHistory) > d.dataStore.maxHistorySize {
		d.dataStore.metricsHistory = d.dataStore.metricsHistory[d.dataStore.maxHistorySize/2:]
	}
}

// WebSocket handler for real-time updates (simplified)
func (d *Dashboard) handleWebSocket(w http.ResponseWriter, r *http.Request) {
	// Implementation would upgrade to WebSocket connection
	// and send real-time metric updates
	w.WriteHeader(http.StatusNotImplemented)
}

// Notification methods (simplified stubs)
func (d *Dashboard) sendEmailNotification(alert *Alert, rule *AlertRule) {
	// Implement email sending
	log.Printf("📧 Email notification: %s - %s", alert.Severity, alert.Message)
}

func (d *Dashboard) sendSlackNotification(alert *Alert, rule *AlertRule) {
	// Implement Slack webhook
	log.Printf("💬 Slack notification: %s - %s", alert.Severity, alert.Message)
}

func (d *Dashboard) sendWebhookNotification(alert *Alert, rule *AlertRule) {
	// Implement webhook notification
	log.Printf("🔗 Webhook notification: %s - %s", alert.Severity, alert.Message)
}

// Configuration types
type EmailConfig struct {
	SMTPHost     string
	SMTPPort     int
	SMTPUser     string
	SMTPPassword string
	FromAddress  string
	ToAddresses  []string
}

type SlackConfig struct {
	WebhookURL string
	Channel    string
	Username   string
}

type WebhookConfig struct {
	URL         string
	Method      string
	Headers     map[string]string
	RetryCount  int
	RetryDelay  time.Duration
}

// Main function for testing
func main() {
	dashboard := NewDashboard()
	dashboard.alertManager.InitializeDefaultRules()

	log.Println("Starting ATLAS Unified Monitoring Dashboard...")
	if err := dashboard.Start(8080); err != nil && err != http.ErrServerClosed {
		log.Fatal(err)
	}
}
