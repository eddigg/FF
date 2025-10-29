package blockchain

import (
	"database/sql"
	"fmt"
	"log"
	"sync"
	"time"
	_ "modernc.org/sqlite"
	"atlas-blockchain/core/pkg/database"
)

// OptimizedDatabase provides enhanced SQLite functionality with WAL mode and connection pooling
type OptimizedDatabase struct {
	connString string
	maxConnections int

	// Connection pool
	pool []*sql.DB
	mutex sync.RWMutex

	// Performance metrics
	queryCount int64
	queryTime  time.Duration
}

// NewOptimizedDatabase creates a new optimized database instance
func NewOptimizedDatabase(dbPath string) (*OptimizedDatabase, error) {
	db := &OptimizedDatabase{
		connString: fmt.Sprintf("file:%s?_journal_mode=WAL&_synchronous=NORMAL&_cache_size=-64000&_foreign_keys=on&_busy_timeout=5000",
			dbPath),
		maxConnections: 10, // Adjust based on load
		pool: make([]*sql.DB, 0, 10),
	}

	// Initialize connection pool
	if err := db.initializeConnectionPool(); err != nil {
		log.Printf("❌ Failed to initialize optimized database: %v", err)
		return nil, err
	}

	// Initialize schema
	if err := db.initializeSchema(); err != nil {
		log.Printf("❌ Failed to initialize database schema: %v", err)
		return nil, err
	}

	log.Printf("✅ Optimized database initialized with WAL mode and connection pooling")
	return db, nil
}

// initializeConnectionPool creates a pool of database connections
func (db *OptimizedDatabase) initializeConnectionPool() error {
	for i := 0; i < db.maxConnections; i++ {
		conn, err := sql.Open("sqlite3", db.connString)
		if err != nil {
			return fmt.Errorf("failed to create connection %d: %w", i, err)
		}

		// Configure connection
		conn.SetMaxOpenConns(1)
		conn.SetMaxIdleConns(1)
		conn.SetConnMaxLifetime(time.Hour)

		// Health check
		if err := conn.Ping(); err != nil {
			conn.Close()
			return fmt.Errorf("failed to ping connection %d: %w", i, err)
		}

		db.pool = append(db.pool, conn)
	}

	log.Printf("✅ Database connection pool initialized (%d connections)", len(db.pool))
	return nil
}

// initializeSchema creates all necessary tables and indexes
func (db *OptimizedDatabase) initializeSchema() error {
	conn := db.getConnection()
	if conn == nil {
		return fmt.Errorf("no available connections")
	}
	defer db.releaseConnection(conn)

	schema := `
		-- Optimized schema with proper indexing
		CREATE TABLE IF NOT EXISTS accounts (
			address TEXT PRIMARY KEY,
			balance INTEGER NOT NULL DEFAULT 0,
			nonce INTEGER NOT NULL DEFAULT 0,
			is_validator BOOLEAN NOT NULL DEFAULT FALSE,
			staked_amount INTEGER NOT NULL DEFAULT 0,
			created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
			updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
		);

		CREATE TABLE IF NOT EXISTS transactions (
			hash TEXT PRIMARY KEY,
			block_hash TEXT NOT NULL,
			from_addr TEXT NOT NULL,
			to_addr TEXT NOT NULL,
			amount INTEGER NOT NULL,
			fee INTEGER NOT NULL DEFAULT 0,
			tx_type TEXT NOT NULL,
			data TEXT,
			nonce INTEGER NOT NULL,
			status TEXT NOT NULL DEFAULT 'pending',
			created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
			INDEX idx_transactions_from_addr (from_addr),
			INDEX idx_transactions_to_addr (to_addr),
			INDEX idx_transactions_block_hash (block_hash),
			INDEX idx_transactions_status (status)
		);

		CREATE TABLE IF NOT EXISTS blocks (
			hash TEXT PRIMARY KEY,
			height INTEGER UNIQUE NOT NULL,
			prev_hash TEXT,
			merkle_root TEXT NOT NULL,
			validator TEXT,
			reward INTEGER NOT NULL DEFAULT 0,
			timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
			nonce INTEGER NOT NULL DEFAULT 0,
			difficulty INTEGER NOT NULL DEFAULT 1,
			status TEXT NOT NULL DEFAULT 'proposed',
			INDEX idx_blocks_height (height),
			INDEX idx_blocks_validator (validator),
			INDEX idx_blocks_timestamp (timestamp)
		);

		CREATE TABLE IF NOT EXISTS contracts (
			address TEXT PRIMARY KEY,
			name TEXT NOT NULL,
			owner TEXT NOT NULL,
			code TEXT NOT NULL,
			storage TEXT, -- JSON storage data
			upgradable BOOLEAN NOT NULL DEFAULT FALSE,
			created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
			updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
			INDEX idx_contracts_owner (owner)
		);

		CREATE TABLE IF NOT EXISTS proposals (
			id TEXT PRIMARY KEY,
			proposer TEXT NOT NULL,
			description TEXT NOT NULL,
			actions TEXT,
			state TEXT NOT NULL DEFAULT 'pending',
			votes_for INTEGER NOT NULL DEFAULT 0,
			votes_against INTEGER NOT NULL DEFAULT 0,
			start_block INTEGER NOT NULL,
			end_block INTEGER NOT NULL,
			created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
			INDEX idx_proposals_proposer (proposer),
			INDEX idx_proposals_state (state),
			INDEX idx_proposals_end_block (end_block)
		);

		CREATE TABLE IF NOT EXISTS votes (
			id INTEGER PRIMARY KEY AUTOINCREMENT,
			proposal_id TEXT NOT NULL,
			voter TEXT NOT NULL,
			choice TEXT NOT NULL,
			weight INTEGER NOT NULL,
			voted_at DATETIME DEFAULT CURRENT_TIMESTAMP,
			UNIQUE(proposal_id, voter),
			FOREIGN KEY (proposal_id) REFERENCES proposals(id),
			INDEX idx_votes_proposal_id (proposal_id),
			INDEX idx_votes_voter (voter)
		);

		CREATE TABLE IF NOT EXISTS oracle_data (
			key TEXT PRIMARY KEY,
			value TEXT NOT NULL,
			source TEXT NOT NULL,
			timestamp INTEGER NOT NULL,
			updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
			INDEX idx_oracle_data_timestamp (timestamp),
			INDEX idx_oracle_data_source (source)
		);

		-- Performance optimizations
		PRAGMA journal_mode = WAL;
		PRAGMA synchronous = NORMAL;
		PRAGMA cache_size = -64000;
		PRAGMA foreign_keys = ON;
		PRAGMA busy_timeout = 5000;
		PRAGMA temp_store = MEMORY;
		PRAGMA mmap_size = 268435456;
	`

	_, err := conn.Exec(schema)
	if err != nil {
		return fmt.Errorf("failed to execute schema: %w", err)
	}

	log.Printf("✅ Database schema initialized with optimized indexes and WAL mode")
	return nil
}

// getConnection retrieves an available connection from the pool
func (db *OptimizedDatabase) getConnection() *sql.DB {
	db.mutex.Lock()
	defer db.mutex.Unlock()

	if len(db.pool) == 0 {
		log.Printf("⚠️  No available database connections")
		return nil
	}

	conn := db.pool[0]
	db.pool = db.pool[1:] // Remove from pool
	return conn
}

// releaseConnection returns a connection to the pool
func (db *OptimizedDatabase) releaseConnection(conn *sql.DB) {
	if conn == nil {
		return
	}

	db.mutex.Lock()
	defer db.mutex.Unlock()

	db.pool = append(db.pool, conn)
}

// executeWithRetry executes a query with automatic retry on busy errors
func (db *OptimizedDatabase) executeWithRetry(query string, args ...interface{}) (sql.Result, error) {
	startTime := time.Now()
	defer func() {
		db.mutex.Lock()
		db.queryCount++
		db.queryTime += time.Since(startTime)
		db.mutex.Unlock()
	}()

	conn := db.getConnection()
	if conn == nil {
		return nil, fmt.Errorf("no available connections")
	}
	defer db.releaseConnection(conn)

	maxRetries := 3
	for attempt := 0; attempt < maxRetries; attempt++ {
		result, err := conn.Exec(query, args...)
		if err == nil {
			return result, nil
		}

		// Check if it's a busy error
		if err.Error() == "database is locked" || err.Error() == "database table is locked" {
			log.Printf("⚠️  Database busy, retrying (attempt %d/%d)...", attempt+1, maxRetries)
			time.Sleep(time.Duration(attempt+1) * time.Millisecond * 100)
			continue
		}

		return nil, err
	}

	return nil, fmt.Errorf("max retries exceeded")
}

// queryWithRetry executes a query with automatic retry
func (db *OptimizedDatabase) queryWithRetry(query string, args ...interface{}) (*sql.Rows, error) {
	startTime := time.Now()
	defer func() {
		db.mutex.Lock()
		db.queryCount++
		db.queryTime += time.Since(startTime)
		db.mutex.Unlock()
	}()

	conn := db.getConnection()
	if conn == nil {
		return nil, fmt.Errorf("no available connections")
	}
	defer db.releaseConnection(conn)

	maxRetries := 3
	for attempt := 0; attempt < maxRetries; attempt++ {
		rows, err := conn.Query(query, args...)
		if err == nil {
			return rows, nil
		}

		// Check if it's a busy error
		if err.Error() == "database is locked" || err.Error() == "database table is locked" {
			log.Printf("⚠️  Database busy, retrying (attempt %d/%d)...", attempt+1, maxRetries)
			time.Sleep(time.Duration(attempt+1) * time.Millisecond * 100)
			rows.Close()
			continue
		}

		return nil, err
	}

	return nil, fmt.Errorf("max retries exceeded")
}

// GetMetrics returns performance metrics
func (db *OptimizedDatabase) GetMetrics() map[string]interface{} {
	db.mutex.RLock()
	defer db.mutex.RUnlock()

	avgQueryTime := time.Duration(0)
	if db.queryCount > 0 {
		avgQueryTime = db.queryTime / time.Duration(db.queryCount)
	}

	return map[string]interface{}{
		"active_connections": len(db.pool),
		"max_connections": db.maxConnections,
		"total_queries": db.queryCount,
		"average_query_time_ms": avgQueryTime.Milliseconds(),
		"total_query_time_ms": db.queryTime.Milliseconds(),
	}
}

// Close properly closes all connections in the pool
func (db *OptimizedDatabase) Close() error {
	db.mutex.Lock()
	defer db.mutex.Unlock()

	var lastErr error
	for _, conn := range db.pool {
		if err := conn.Close(); err != nil {
			lastErr = err
			log.Printf("⚠️  Error closing database connection: %v", err)
		}
	}

	db.pool = nil
	log.Printf("✅ Optimized database closed successfully")
	return lastErr
}

// HealthCheck performs a health check on the database
func (db *OptimizedDatabase) HealthCheck() error {
	conn := db.getConnection()
	if conn == nil {
		return fmt.Errorf("no available connections")
	}
	defer db.releaseConnection(conn)

	return conn.Ping()
}

// GetAccount retrieves an account with optimized query
func (db *OptimizedDatabase) GetAccount(address string) (*database.Account, error) {
	rows, err := db.queryWithRetry(`
		SELECT address, balance, nonce, is_validator, staked_amount
		FROM accounts WHERE address = ?`, address)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	if rows.Next() {
		var acct database.Account
		err := rows.Scan(&acct.Address, &acct.Balance, &acct.Nonce,
			&acct.IsValidator, &acct.StakedAmount)
		if err != nil {
			return nil, err
		}
		return &acct, nil
	}

	return nil, nil // Account not found
}

// SetAccount stores an account with optimized upsert
func (db *OptimizedDatabase) SetAccount(acct *database.Account) error {
	_, err := db.executeWithRetry(`
		INSERT OR REPLACE INTO accounts (address, balance, nonce, is_validator, staked_amount, updated_at)
		VALUES (?, ?, ?, ?, ?, CURRENT_TIMESTAMP)`,
		acct.Address, acct.Balance, acct.Nonce, acct.IsValidator, acct.StakedAmount)

	return err
}

// BatchUpdate performs multiple updates in a single transaction for optimal performance
func (db *OptimizedDatabase) BatchUpdate(updates []interface{}) error {
	conn := db.getConnection()
	if conn == nil {
		return fmt.Errorf("no available connections")
	}
	defer db.releaseConnection(conn)

	tx, err := conn.Begin()
	if err != nil {
		return err
	}
	defer tx.Rollback()

	startTime := time.Now()
	defer func() {
		db.mutex.Lock()
		db.queryCount += int64(len(updates))
		db.queryTime += time.Since(startTime)
		db.mutex.Unlock()
	}()

	for _, update := range updates {
		switch u := update.(type) {
		case *database.Account:
			_, err = tx.Exec(`
				INSERT OR REPLACE INTO accounts (address, balance, nonce, is_validator, staked_amount, updated_at)
				VALUES (?, ?, ?, ?, ?, CURRENT_TIMESTAMP)`,
				u.Address, u.Balance, u.Nonce, u.IsValidator, u.StakedAmount)
		// Add other update types as needed
		}

		if err != nil {
			return err
		}
	}

	return tx.Commit()
}
