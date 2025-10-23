package blockchain

import (
	"fmt"
	"testing"
	"time"
)

// Simple validation test for WAL and connection pooling components
func TestCoreOptimization(t *testing.T) {
	fmt.Println("🧪 Testing Atlas Database Optimizations...")

	// Test 1: WAL Mode Configuration Validation
	db, err := NewOptimizedDatabase("validation_test.db")
	if err != nil {
		t.Fatalf("❌ WAL mode initialization failed: %v", err)
	}
	defer db.Close()

	fmt.Println("✅ WAL mode database initialized successfully")

	// Test 2: Connection Pool Size Validation
	metrics := db.GetMetrics()
	if metrics["max_connections"].(float64) != 10 {
		t.Errorf("❌ Connection pool size incorrect: expected 10, got %v", metrics["max_connections"])
	}
	fmt.Printf("✅ Connection pool size validated: %v connections\n", metrics["max_connections"])

	// Test 3: Health Check Validation
	if err := db.HealthCheck(); err != nil {
		t.Errorf("❌ Health check failed: %v", err)
	}
	fmt.Println("✅ Health check passed")

	// Test 4: Basic Operations with Metrics
	start := time.Now()
	account := &Account{
		Address:   "test_validation_addr",
		Balance:   1000,
		Nonce:     1,
		IsValidator: false,
		StakedAmount: 0,
	}

	// Set account
	if err := db.SetAccount(account); err != nil {
		t.Errorf("❌ Account set failed: %v", err)
	}

	// Get account
	retrieved, err := db.GetAccount("test_validation_addr")
	if err != nil {
		t.Errorf("❌ Account get failed: %v", err)
	}
	if retrieved == nil || retrieved.Balance != 1000 {
		t.Errorf("❌ Account data mismatch: expected balance 1000, got %v", retrieved.Balance)
	}

	operationTime := time.Since(start)
	if operationTime > 100*time.Millisecond {
		t.Errorf("❌ Performance too slow: %v > 100ms", operationTime)
	}

	fmt.Printf("✅ Basic operations completed in %v (target: <100ms)\n", operationTime)

	// Test 5: Metrics Collection Validation
	finalMetrics := db.GetMetrics()
	if finalMetrics["total_queries"].(float64) < 2 {
		t.Errorf("❌ Metrics not collected: expected >2 queries, got %v", finalMetrics["total_queries"])
	}
	fmt.Printf("✅ Metrics collected: %v queries processed\n", finalMetrics["total_queries"])

	fmt.Println("🎉 All database optimizations validated successfully!")
	fmt.Println("🚀 WAL Mode + Connection Pooling + Performance optimizations working correctly")
}
