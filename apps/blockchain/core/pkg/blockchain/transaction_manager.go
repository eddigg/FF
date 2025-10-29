package blockchain

import (
	"container/heap"
	"errors"
	"fmt"
	"sync"
	"time"
	"atlas-blockchain/core/pkg/transaction"
	"atlas-blockchain/core/pkg/wallet"
	"atlas-blockchain/core/pkg/config"
)

// TransactionPriority represents a transaction with its priority score
type TransactionPriority struct {
	Transaction transaction.Transaction
	Priority    float64  // Changed to float64 for more precise priority calculation
	Timestamp   int64    // Changed to int64 for consistency
	Fee         int64    // Added fee field
	index       int      // for heap implementation
}

// TransactionHeap implements heap.Interface for transaction prioritization
type TransactionHeap []*TransactionPriority

// TransactionManager handles transaction processing and pool management
type TransactionManager struct {
	pool     TransactionHeap
	mu       sync.RWMutex
	byHash   map[string]*TransactionPriority // for quick lookup
	config   *config.BlockchainConfig
	stateManager *StateManager
	senderReputation map[string]float64 // Tracks sender reputation
	transactionComplexity map[string]float64 // Tracks transaction complexity
	historicalSuccessRate map[string]float64 // Tracks historical success rate

	dynamicFeeMultiplier float64 // Dynamic fee multiplier based on congestion
}

// NewTransactionManager creates a new transaction manager
func NewTransactionManager(config *config.BlockchainConfig, stateManager *StateManager) *TransactionManager {
	tm := &TransactionManager{
		pool:   make(TransactionHeap, 0),
		byHash: make(map[string]*TransactionPriority),
		config: config,
		stateManager: stateManager,
		senderReputation: make(map[string]float64),
		transactionComplexity: make(map[string]float64),
		historicalSuccessRate: make(map[string]float64),
		dynamicFeeMultiplier: 1.0,
	}
	heap.Init(&tm.pool)
	return tm
}

// AddTransaction adds a transaction to the pool with priority calculation
func (tm *TransactionManager) AddTransaction(tx transaction.Transaction) error {
	fmt.Printf("[DEBUG] AddTransaction: Attempting to acquire lock...\n")
	tm.mu.Lock()
	fmt.Printf("[DEBUG] AddTransaction: Lock acquired.\n")
	defer func() {
		fmt.Printf("[DEBUG] AddTransaction: Releasing lock.\n")
		tm.mu.Unlock()
	}()

	fmt.Printf("[DEBUG] AddTransaction: Calling UpdateDynamicFeeMultiplier...\n")
	tm.UpdateDynamicFeeMultiplier()
	fmt.Printf("[DEBUG] AddTransaction: UpdateDynamicFeeMultiplier complete.\n")

	// Nonce validation: check that the transaction nonce matches the sender's account nonce
	if tx.Sender != "network" && tm.stateManager != nil {
		expectedNonce := tm.stateManager.GetNonce(tx.Sender)
		fmt.Printf("[DEBUG] AddTransaction: Nonce validation for sender %s: got %d, expected %d\n", tx.Sender, tx.Nonce, expectedNonce)
		if tx.Nonce != expectedNonce {
			fmt.Printf("[DEBUG] AddTransaction: Invalid nonce. Returning error.\n")
			return fmt.Errorf("invalid nonce for sender %s: got %d, expected %d", tx.Sender, tx.Nonce, expectedNonce)
		}
	}

	fmt.Printf("[DEBUG] AddTransaction: Checking pool size (current: %d, max: %d)\n", len(tm.pool), tm.config.MaxTxPoolSize)
	// Check pool size limit
	if len(tm.pool) >= tm.config.MaxTxPoolSize {
		fmt.Printf("[DEBUG] AddTransaction: Pool is full. Checking for replacement...\n")
		// If pool is full, try to replace lowest priority transaction
		if len(tm.pool) > 0 {
			lowestPriority := tm.pool[0]
			newPriority := tm.calculatePriority(tx)
			fmt.Printf("[DEBUG] AddTransaction: New tx priority: %f, lowest in pool: %f\n", newPriority, lowestPriority.Priority)
			if newPriority > lowestPriority.Priority {
				fmt.Printf("[DEBUG] AddTransaction: Replacing lowest priority transaction.\n")
				heap.Pop(&tm.pool)
				delete(tm.byHash, string(wallet.CalculateTxHash(lowestPriority.Transaction)))
			} else {
				fmt.Printf("[DEBUG] AddTransaction: New transaction has lower priority. Returning error.\n")
				return errors.New("transaction pool is full and new transaction has lower priority")
			}
		} else {
			fmt.Printf("[DEBUG] AddTransaction: Pool is full and empty (should not happen). Returning error.\n")
			return errors.New("transaction pool is full")
		}
	}

	// Calculate transaction hash for deduplication
	txHash := string(wallet.CalculateTxHash(tx))
	fmt.Printf("[DEBUG] AddTransaction: Calculated txHash: %s\n", txHash)
	if _, exists := tm.byHash[txHash]; exists {
		fmt.Printf("[DEBUG] AddTransaction: Transaction already exists in pool. Returning error.\n")
		return errors.New("transaction already exists in pool")
	}

	// Calculate priority based on amount, fee, and time
	priority := tm.calculatePriority(tx)
	fmt.Printf("[DEBUG] AddTransaction: Calculated priority: %f\n", priority)
	fmt.Printf("[DEBUG] Before heap.Push (moved)\n")
	// Create priority entry
	tp := &TransactionPriority{
		Transaction: tx,
		Priority:    priority,
		Timestamp:   time.Now().Unix(),
		Fee:         tm.calculateFee(tx),
	}

	fmt.Printf("[DEBUG] AddTransaction: Pushing transaction to heap and map.\n")
	fmt.Printf("[DEBUG] tm.pool type: %T, len: %d\n", tm.pool, len(tm.pool))
	fmt.Printf("[DEBUG] tp type: %T\n", tp)
	heap.Push(&tm.pool, tp)
	fmt.Printf("[DEBUG] After heap.Push\n")
	tm.byHash[txHash] = tp
	fmt.Printf("[DEBUG] AddTransaction: Transaction added successfully.\n")

	return nil
}

// GetTransactionsForBlock returns the highest priority transactions for a new block
func (tm *TransactionManager) GetTransactionsForBlock() []transaction.Transaction {
	tm.mu.Lock()
	defer tm.mu.Unlock()

	var transactions []transaction.Transaction
	count := min(len(tm.pool), tm.config.MaxBlockSize)

	for i := 0; i < count; i++ {
		if tp := heap.Pop(&tm.pool).(*TransactionPriority); tp != nil {
			transactions = append(transactions, tp.Transaction)
			delete(tm.byHash, string(wallet.CalculateTxHash(tp.Transaction)))
		}
	}

	return transactions
}

// RemoveExpiredTransactions removes transactions that have expired
func (tm *TransactionManager) RemoveExpiredTransactions() {
	tm.mu.Lock()
	defer tm.mu.Unlock()

	now := time.Now().Unix()
	var valid []*TransactionPriority

	for _, tp := range tm.pool {
		if now - tp.Timestamp <= int64(tm.config.TxExpirationTime.Seconds()) {
			valid = append(valid, tp)
		} else {
			delete(tm.byHash, string(wallet.CalculateTxHash(tp.Transaction)))
		}
	}

	// Rebuild heap with valid transactions
	tm.pool = valid
	heap.Init(&tm.pool)
}

// calculatePriority determines the priority of a transaction
// Higher amount, fee, and newer transactions get higher priority
func (tm *TransactionManager) calculatePriority(tx transaction.Transaction) float64 {
	// Normalize factors
	amountFactor := float64(tx.Amount) / 1000.0 // Example normalization
	feeFactor := float64(tx.Fee) / 100.0        // Example normalization
	timeFactor := float64(time.Now().Unix() - tx.Timestamp) / 3600.0 // Age in hours
	reputationFactor := tm.senderReputation[tx.Sender] // Sender reputation
	complexityFactor := tm.transactionComplexity[string(wallet.CalculateTxHash(tx))] // Transaction complexity
	successRateFactor := tm.historicalSuccessRate[string(wallet.CalculateTxHash(tx))] // Historical success rate

	// Weighted combination
	return 0.3*amountFactor + 0.2*feeFactor + 0.1*timeFactor + 0.1*reputationFactor + 0.15*complexityFactor + 0.15*successRateFactor
}

// Update the dynamic fee multiplier based on mempool congestion
func (tm *TransactionManager) UpdateDynamicFeeMultiplier() {
	poolSize := len(tm.pool)
	maxSize := tm.config.MaxTxPoolSize
	usage := float64(poolSize) / float64(maxSize)
	// Example: multiplier ranges from 1.0 to 5.0 as pool fills up
	tm.dynamicFeeMultiplier = 1.0 + 4.0*usage
}

// Get the current recommended fee multiplier
func (tm *TransactionManager) GetDynamicFeeMultiplier() float64 {
	tm.mu.RLock()
	defer tm.mu.RUnlock()
	return tm.dynamicFeeMultiplier
}

// calculateFee calculates the transaction fee based on amount, size, and dynamic multiplier
func (tm *TransactionManager) calculateFee(tx transaction.Transaction) int64 {
	baseFee := int64(1)
	sizeFee := int64(len(tx.Sender) + len(tx.Recipient)) / 100
	amountFee := int64(float64(tx.Amount) * 0.001)
	fee := float64(baseFee+sizeFee+amountFee) * tm.GetDynamicFeeMultiplier()
	if fee < 1 {
		fee = 1
	}
	return int64(fee)
}

// Heap implementation for TransactionHeap
func (h TransactionHeap) Len() int {
	fmt.Printf("[DEBUG] TransactionHeap.Len called, len: %d\n", len(h))
	return len(h)
}

func (h TransactionHeap) Less(i, j int) bool {
	fmt.Printf("[DEBUG] TransactionHeap.Less called, i: %d, j: %d\n", i, j)
	return h[i].Priority > h[j].Priority
}

func (h TransactionHeap) Swap(i, j int) {
	fmt.Printf("[DEBUG] TransactionHeap.Swap called, i: %d, j: %d\n", i, j)
	h[i], h[j] = h[j], h[i]
	h[i].index = i
	h[j].index = j
}

func (h *TransactionHeap) Push(x interface{}) {
	fmt.Printf("[DEBUG] TransactionHeap.Push called\n")
	n := len(*h)
	item := x.(*TransactionPriority)
	item.index = n
	*h = append(*h, item)
}

func (h *TransactionHeap) Pop() interface{} {
	fmt.Printf("[DEBUG] TransactionHeap.Pop called\n")
	old := *h
	n := len(old)
	item := old[n-1]
	old[n-1] = nil
	item.index = -1
	*h = old[0 : n-1]
	return item
}

// GetPoolSize returns the current number of transactions in the pool
func (tm *TransactionManager) GetPoolSize() int {
	tm.mu.RLock()
	defer tm.mu.RUnlock()
	return len(tm.pool)
}

// GetTransactionByHash retrieves a transaction from the pool by its hash
func (tm *TransactionManager) GetTransactionByHash(hash string) *transaction.Transaction {
	tm.mu.RLock()
	defer tm.mu.RUnlock()
	if tp, exists := tm.byHash[hash]; exists {
		return &tp.Transaction
	}
	return nil
}

// ClearPool removes all transactions from the pool
func (tm *TransactionManager) ClearPool() {
	tm.mu.Lock()
	defer tm.mu.Unlock()
	tm.pool = make(TransactionHeap, 0)
	tm.byHash = make(map[string]*TransactionPriority)
	heap.Init(&tm.pool)
}

// Add a method to get all transactions currently in the pool
func (tm *TransactionManager) GetAllTransactions() []transaction.Transaction {
	tm.mu.RLock()
	defer tm.mu.RUnlock()
	transactions := make([]transaction.Transaction, 0, len(tm.pool))
	for _, tp := range tm.pool {
		transactions = append(transactions, tp.Transaction)
	}
	return transactions
}

// Update sender reputation
func (tm *TransactionManager) updateSenderReputation(sender string, success bool) {
	tm.mu.Lock()
	defer tm.mu.Unlock()
	if success {
		tm.senderReputation[sender] += 0.1 // Increase reputation on success
	} else {
		tm.senderReputation[sender] -= 0.1 // Decrease reputation on failure
	}
}

// Update transaction complexity
func (tm *TransactionManager) updateTransactionComplexity(txHash string, complexity float64) {
	tm.mu.Lock()
	defer tm.mu.Unlock()
	tm.transactionComplexity[txHash] = complexity
}

// Update historical success rate
func (tm *TransactionManager) updateHistoricalSuccessRate(txHash string, success bool) {
	tm.mu.Lock()
	defer tm.mu.Unlock()
	if success {
		tm.historicalSuccessRate[txHash] += 0.1 // Increase success rate on success
	} else {
		tm.historicalSuccessRate[txHash] -= 0.1 // Decrease success rate on failure
	}
} 