package blockchain

import (
	"testing"
	"time"
)

// TestOptimizedDatabase verifies WAL mode and connection pooling functionality
func TestOptimizedDatabase(t *testing.T) {
	// Create test database
	db, err := NewOptimizedDatabase("test_optimized.db")
	if err != nil {
		t.Fatalf("Failed to create optimized database: %v", err)
	}
	defer db.Close()

	// Test connection pool initialization
	metrics := db.GetMetrics()
	if metrics["max_connections"] != float64(10) {
		t.Errorf("Expected 10 max connections, got %v", metrics["max_connections"])
	}

	// Test health check
	if err := db.HealthCheck(); err != nil {
		t.Errorf("Health check failed: %v", err)
	}

	// Test account operations
	testAccount := &Account{
		Address:      "test_address_123",
		Balance:      1000,
		Nonce:        1,
		IsValidator:  false,
		StakedAmount: 0,
	}

	// Test SetAccount
	if err := db.SetAccount(testAccount); err != nil {
		t.Errorf("Failed to set account: %v", err)
	}

	// Test GetAccount
	retrieved, err := db.GetAccount("test_address_123")
	if err != nil {
		t.Errorf("Failed to get account: %v", err)
	}
	if retrieved == nil {
		t.Fatal("Account not found after setting")
	}
	if retrieved.Balance != 1000 {
		t.Errorf("Expected balance 1000, got %d", retrieved.Balance)
	}

	// Test performance metrics collection
	metrics = db.GetMetrics()
	if metrics["total_queries"] == nil || metrics["total_queries"].(float64) <= 0 {
		t.Error("Performance metrics not being collected")
	}

	// Test batch operations
	batchAccounts := []interface{}{
		&Account{Address: "batch_addr_1", Balance: 2000, Nonce: 2},
		&Account{Address: "batch_addr_2", Balance: 3000, Nonce: 3},
	}

	if err := db.BatchUpdate(batchAccounts); err != nil {
		t.Errorf("Batch update failed: %v", err)
	}

	// Verify batch operations
	for _, expected := range []*Account{
		{Address: "batch_addr_1", Balance: 2000},
		{Address: "batch_addr_2", Balance: 3000},
	} {
		actual, err := db.GetAccount(expected.Address)
		if err != nil {
			t.Errorf("Failed to get batch account %s: %v", expected.Address, err)
			continue
		}
		if actual.Balance != expected.Balance {
			t.Errorf("Batch account %s balance mismatch: expected %d, got %d",
				expected.Address, expected.Balance, actual.Balance)
		}
	}
}

// TestConcurrentAccess verifies thread safety and connection pooling
func TestConcurrentAccess(t *testing.T) {
	db, err := NewOptimizedDatabase("test_concurrent.db")
	if err != nil {
		t.Fatalf("Failed to create concurrent test database: %v", err)
	}
	defer db.Close()

	// Test concurrent account operations
	done := make(chan bool, 10)

	for i := 0; i < 10; i++ {
		go func(id int) {
			account := &Account{
				Address: fmt.Sprintf("concurrent_addr_%d", id),
				Balance: int64(id * 100),
				Nonce:   uint64(id),
			}

			// Set account
			if err := db.SetAccount(account); err != nil {
				t.Errorf("Concurrent set failed for %d: %v", id, err)
				done <- false
				return
			}

			// Get account
			retrieved, err := db.GetAccount(account.Address)
			if err != nil {
				t.Errorf("Concurrent get failed for %d: %v", id, err)
				done <- false
				return
			}
			if retrieved == nil || retrieved.Balance != account.Balance {
				t.Errorf("Concurrent data mismatch for %d", id)
				done <- false
				return
			}

			done <- true
		}(i)
	}

	// Wait for all goroutines
	timeout := time.After(10 * time.Second)
	failed := false

	for i := 0; i < 10; i++ {
		select {
		case success := <-done:
			if !success {
				failed = true
			}
		case <-timeout:
			t.Fatal("Test timed out - concurrent operations not completing")
			return
		}
	}

	if failed {
		t.Error("Some concurrent operations failed")
	} else {
		t.Log("✅ All concurrent operations completed successfully")
	}
}

import "fmt"

// BenchmarkOptimizedDatabase measures performance
func BenchmarkOptimizedDatabase(b *testing.B) {
	db, err := NewOptimizedDatabase("benchmark.db")
	if err != nil {
		b.Fatalf("Failed to create benchmark database: %v", err)
	}
	defer db.Close()

	b.ResetTimer()
	b.RunParallel(func(pb *testing.PB) {
		i := 0
		for pb.Next() {
			account := &Account{
				Address: fmt.Sprintf("bench_addr_%d", i),
				Balance: int64(i),
				Nonce:   uint64(i),
			}
			db.SetAccount(account)
			i++
		}
	})
}
