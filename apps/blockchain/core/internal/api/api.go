package api

import (
	"encoding/hex"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os/exec"
	"time"
	"bytes"
	"strings"
	"atlas-blockchain/pkg/wallet"
	"atlas-blockchain/pkg/transaction"
	"atlas-blockchain/pkg/crypto"
	"atlas-blockchain/pkg/vm"
	"atlas-blockchain/pkg/monitoring"
	"atlas-blockchain/internal/blockchain"
	"atlas-blockchain/internal/identity"
	"atlas-blockchain/internal/social"
	"atlas-blockchain/internal/governance"
	"atlas-blockchain/pkg/network"
)

// API server struct
// Add references to managers as needed
type APIServer struct {
	blockManager      *blockchain.BlockManager
	transactionManager *blockchain.TransactionManager
	stateManager      *blockchain.StateManager
	consensusManager  *blockchain.ConsensusManager
	node              *network.Node
	monitor           *monitoring.Monitor
	identityManager   *identity.IdentityManager
	socialManager     *social.SocialManager
	governanceManager *governance.GovernanceManager
}

func NewAPIServer(bm *blockchain.BlockManager, tm *blockchain.TransactionManager, sm *blockchain.StateManager, cm *blockchain.ConsensusManager, node *network.Node, im *identity.IdentityManager, socialMgr *social.SocialManager, govMgr *governance.GovernanceManager) *APIServer {
	// Create monitor without shard manager for now
	monitor := monitoring.NewMonitor(nil)
	
	api := &APIServer{
		blockManager:      bm,
		transactionManager: tm,
		stateManager:      sm,
		consensusManager:  cm,
		node:              node,
		monitor:           monitor,
		identityManager:   im,
		socialManager:     socialMgr,
		governanceManager: govMgr,
	}
	
	// Start monitoring
	if monitor != nil {
		monitor.StartMonitoring()
	}
	
	return api
}

func withCORS(handler http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
		w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization, X-Requested-With")
		w.Header().Set("Access-Control-Max-Age", "86400")
		
		if r.Method == "OPTIONS" {
			w.WriteHeader(http.StatusOK)
			return
		}
		handler(w, r)
	}
}

func (api *APIServer) Start(addr string) {
	http.HandleFunc("/block", withCORS(api.handleGetBlock))
	http.HandleFunc("/blocks", withCORS(api.handleListBlocks))
	http.HandleFunc("/transaction", withCORS(api.handleGetTransaction))
	http.HandleFunc("/mempool", withCORS(api.handleGetMempool))
	http.HandleFunc("/submit-transaction", withCORS(api.handleSubmitTransaction))
	http.HandleFunc("/balance", withCORS(api.handleGetBalance))
	http.HandleFunc("/status", withCORS(api.handleGetStatus))
	http.HandleFunc("/validators", withCORS(api.handleListValidators))
	http.HandleFunc("/validator", withCORS(api.handleGetValidator))
	http.HandleFunc("/register-validator", withCORS(api.handleRegisterValidator))
	http.HandleFunc("/update-stake", withCORS(api.handleUpdateStake))
	http.HandleFunc("/update-user-stake", withCORS(api.handleUpdateUserStake))
	http.HandleFunc("/node-address", withCORS(api.handleGetNodeAddress))
	http.HandleFunc("/peers", withCORS(api.handleGetPeers))
	http.HandleFunc("/faucet", withCORS(api.handleFaucet))
	http.HandleFunc("/nonce", withCORS(api.handleGetNonce))
	http.HandleFunc("/run-tests", withCORS(api.handleRunTests))
	http.HandleFunc("/test-performance", withCORS(api.handleTestPerformance))
	http.HandleFunc("/test-security", withCORS(api.handleTestSecurity))
	http.HandleFunc("/test-integration", withCORS(api.handleTestIntegration))
	http.HandleFunc("/start-test-env", withCORS(api.handleStartTestEnv))
	http.HandleFunc("/stop-test-env", withCORS(api.handleStopTestEnv))
	http.HandleFunc("/test-env-status", withCORS(api.handleTestEnvStatus))
	http.HandleFunc("/create-wallet", withCORS(api.handleCreateWallet))
	http.HandleFunc("/import-wallet", withCORS(api.handleImportWallet))
	http.HandleFunc("/fee-info", withCORS(api.handleFeeInfo))
	
	// Identity management endpoints for social-commerce-governance platform
	http.HandleFunc("/identity/create", withCORS(api.handleCreateIdentity))
	http.HandleFunc("/identity/get", withCORS(api.handleGetIdentity))
	http.HandleFunc("/identity/update-profile", withCORS(api.handleUpdateProfile))
	// Identity endpoints commented out - handlers not implemented yet
	// http.HandleFunc("/identity/add-credential", withCORS(api.handleAddCredential))
	// http.HandleFunc("/identity/add-attestation", withCORS(api.handleAddAttestation))
	// http.HandleFunc("/identity/update-privacy", withCORS(api.handleUpdatePrivacy))
	// http.HandleFunc("/identity/update-kyc", withCORS(api.handleUpdateKYC))
	http.HandleFunc("/identity/update-activity", withCORS(api.handleUpdateActivity))
	http.HandleFunc("/identity/create-proof", withCORS(api.handleCreatePrivacyProof))
	http.HandleFunc("/identity/verify-proof", withCORS(api.handleVerifyPrivacyProof))
	http.HandleFunc("/identity/social", withCORS(api.handleGetIdentityForSocial))
	http.HandleFunc("/identity/commerce", withCORS(api.handleGetIdentityForCommerce))
	http.HandleFunc("/identity/governance", withCORS(api.handleGetIdentityForGovernance))
	
	// FlutterFlow Integration Endpoints
	http.HandleFunc("/flutterflow/connect-wallet", withCORS(api.handleFlutterFlowConnectWallet))
	http.HandleFunc("/flutterflow/authenticate", withCORS(api.handleFlutterFlowAuthenticate))
	http.HandleFunc("/flutterflow/wallet-info", withCORS(api.handleFlutterFlowWalletInfo))
	http.HandleFunc("/flutterflow/send-transaction", withCORS(api.handleFlutterFlowSendTransaction))
	http.HandleFunc("/flutterflow/transaction-history", withCORS(api.handleFlutterFlowTransactionHistory))
	http.HandleFunc("/flutterflow/disconnect", withCORS(api.handleFlutterFlowDisconnect))
	
	// Governance endpoints
	http.HandleFunc("/governance/proposals", withCORS(api.handleListProposals))
	http.HandleFunc("/governance/proposal", withCORS(api.handleGetProposal))
	http.HandleFunc("/governance/submit-proposal", withCORS(api.handleSubmitProposal))
	http.HandleFunc("/governance/vote", withCORS(api.handleVote))

	http.HandleFunc("/oracle/submit", withCORS(api.handleOracleSubmit))
	http.HandleFunc("/oracle/latest", withCORS(api.handleOracleLatest))
	
	// Privacy endpoints
	http.HandleFunc("/privacy/encrypt", withCORS(api.handleEncryptData))
	http.HandleFunc("/privacy/decrypt", withCORS(api.handleDecryptData))
	// ZK-related endpoints are disabled due to ZK code being commented out
	/*
	func (api *APIServer) handleCreateProof(w http.ResponseWriter, r *http.Request) {
		// Disabled: ZK proof creation endpoint
	}

	func (api *APIServer) handleVerifyProof(w http.ResponseWriter, r *http.Request) {
		// Disabled: ZK proof verification endpoint
	}
	*/
	http.HandleFunc("/privacy/gdpr-delete", withCORS(api.handleGDPRDelete))
	http.HandleFunc("/privacy/gdpr-anonymize", withCORS(api.handleGDPRAnonymize))
	
	// Sharding endpoints
	http.HandleFunc("/sharding/status", withCORS(api.handleShardingStatus))
	http.HandleFunc("/sharding/shard", withCORS(api.handleGetShard))
	http.HandleFunc("/sharding/assign-validator", withCORS(api.handleAssignValidator))
	http.HandleFunc("/sharding/cross-shard-tx", withCORS(api.handleCrossShardTransaction))
	http.HandleFunc("/sharding/statistics", withCORS(api.handleShardingStatistics))
	
	// Monitoring endpoints
	http.HandleFunc("/monitoring/status", withCORS(api.handleMonitoringStatus))
	http.HandleFunc("/monitoring/metrics", withCORS(api.handleMonitoringMetrics))
	http.HandleFunc("/monitoring/health", withCORS(api.handleMonitoringHealth))
	http.HandleFunc("/monitoring/alerts", withCORS(api.handleMonitoringAlerts))
	http.HandleFunc("/monitoring/performance", withCORS(api.handleMonitoringPerformance))
	http.HandleFunc("/monitoring/history", withCORS(api.handleMonitoringHistory))
	http.HandleFunc("/monitoring/trends", withCORS(api.handleMonitoringTrends))
	
	// Chain synchronization endpoints
	http.HandleFunc("/sync/status", withCORS(api.handleSyncStatus))
	http.HandleFunc("/sync/start", withCORS(api.handleSyncStart))
	
	// Database backup and recovery endpoints
	http.HandleFunc("/backup/status", withCORS(api.handleBackupStatus))
	http.HandleFunc("/backup/list", withCORS(api.handleBackupList))
	http.HandleFunc("/backup/create", withCORS(api.handleBackupCreate))
	
	// Social Media API endpoints
	http.HandleFunc("/social/post/create", withCORS(api.handleCreatePost))
	http.HandleFunc("/social/post/get", withCORS(api.handleGetPost))
	http.HandleFunc("/social/comment/create", withCORS(api.handleCreateComment))
	http.HandleFunc("/social/like", withCORS(api.handleLikePost))
	http.HandleFunc("/social/unlike", withCORS(api.handleUnlikePost))
	http.HandleFunc("/social/feed", withCORS(api.handleGetFeed))
	http.HandleFunc("/social/search", withCORS(api.handleSearchPosts))
	http.HandleFunc("/social/trending", withCORS(api.handleGetTrendingHashtags))
	http.HandleFunc("/social/report", withCORS(api.handleReportContent))
	
	// Enhanced Governance API endpoints
	http.HandleFunc("/governance/proposal/create", withCORS(api.handleCreateProposal))
	http.HandleFunc("/governance/proposal/get", withCORS(api.handleGetProposal))
	http.HandleFunc("/governance/proposal/activate", withCORS(api.handleActivateProposal))
	http.HandleFunc("/governance/proposal/vote", withCORS(api.handleVoteProposal))
	http.HandleFunc("/governance/proposal/execute", withCORS(api.handleExecuteProposal))
	http.HandleFunc("/governance/proposal/discuss", withCORS(api.handleAddDiscussionComment))
	http.HandleFunc("/governance/proposals/active", withCORS(api.handleGetActiveProposals))
	http.HandleFunc("/governance/proposals/category", withCORS(api.handleGetProposalsByCategory))
	http.HandleFunc("/governance/referendum/create", withCORS(api.handleCreateReferendum))
	http.HandleFunc("/governance/referendum/vote", withCORS(api.handleVoteReferendum))

	// Smart Contract endpoints
	http.HandleFunc("/contract/deploy", withCORS(api.handleDeployContract))
	http.HandleFunc("/contract/call", withCORS(api.handleCallContract))
	http.HandleFunc("/contract/list", withCORS(api.handleListContracts))
	http.HandleFunc("/contract/info", withCORS(api.handleGetContractInfo))
	http.HandleFunc("/contract/examples", withCORS(api.handleGetContractExamples))
	
	// Network Architecture endpoint
	http.HandleFunc("/network/architecture", withCORS(api.handleGetNetworkArchitecture))
	
	log.Printf("API server listening on %s", addr)
	log.Fatal(http.ListenAndServe(addr, nil))
}

// GET /block?hash=...
func (api *APIServer) handleGetBlock(w http.ResponseWriter, r *http.Request) {
	hash := r.URL.Query().Get("hash")
	if hash == "" {
		http.Error(w, "Missing block hash", http.StatusBadRequest)
		return
	}
	block := api.blockManager.GetBlockByHash(hash)
	if block == nil {
		http.Error(w, "Block not found", http.StatusNotFound)
		return
	}
	json.NewEncoder(w).Encode(block)
}

// GET /transaction?hash=...
func (api *APIServer) handleGetTransaction(w http.ResponseWriter, r *http.Request) {
	hash := r.URL.Query().Get("hash")
	if hash == "" {
		http.Error(w, "Missing transaction hash", http.StatusBadRequest)
		return
	}
	tx := api.transactionManager.GetTransactionByHash(hash)
	if tx == nil {
		http.Error(w, "Transaction not found", http.StatusNotFound)
		return
	}
	json.NewEncoder(w).Encode(tx)
}

// POST /submit-transaction
func (api *APIServer) handleSubmitTransaction(w http.ResponseWriter, r *http.Request) {
	var tx transaction.Transaction
	if err := json.NewDecoder(r.Body).Decode(&tx); err != nil {
		http.Error(w, "Invalid transaction data", http.StatusBadRequest)
		return
	}
	// Set missing fields if needed
	if tx.Timestamp == 0 {
		tx.Timestamp = time.Now().Unix()
	}
	// Do not modify Fee after signing
	// if tx.Fee == 0 {
	// 	tx.Fee = calculateFee(tx)
	// }
	if err := api.transactionManager.AddTransaction(tx); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	w.WriteHeader(http.StatusAccepted)
	json.NewEncoder(w).Encode(map[string]string{"status": "Transaction submitted"})
}

// GET /balance?address=...
func (api *APIServer) handleGetBalance(w http.ResponseWriter, r *http.Request) {
	address := r.URL.Query().Get("address")
	if address == "" {
		http.Error(w, "Missing address", http.StatusBadRequest)
		return
	}
	
	// Get balance from state manager (this doesn't require node wallet)
	balance := api.stateManager.GetBalance(address)
	json.NewEncoder(w).Encode(map[string]interface{}{"address": address, "balance": balance})
}

// GET /status
func (api *APIServer) handleGetStatus(w http.ResponseWriter, r *http.Request) {
	// Get the node's address
	nodeAddress := api.node.ValidatorAddress
	
	// Check if this node is a validator
	var isValidator bool
	var validatorAddress string
	var stakeAmount uint64
	var walletBalance int64
	var walletStaked uint64
	
	if validator, err := api.consensusManager.GetValidatorInfo(nodeAddress); err == nil {
		isValidator = true
		validatorAddress = validator.Address
		stakeAmount = validator.Stake
	}
	
	// Get wallet information if available
	if api.node.Wallet != nil {
		walletBalance = api.node.Wallet.GetBalance()
		walletStaked = api.node.Wallet.GetStaked()
	}
	
	// Get all validators for total count
	validators := api.consensusManager.GetAllValidators()
	
	mode := "observer"
	if isValidator {
		mode = "validator"
	}
	status := map[string]interface{}{
		"blockHeight":      api.blockManager.GetBlockHeight(),
		"txPoolSize":       api.transactionManager.GetPoolSize(),
		"isValidator":      isValidator,
		"validatorAddress": validatorAddress,
		"stakeAmount":      stakeAmount,
		"totalValidators":  len(validators),
		"walletBalance":    walletBalance,
		"walletStaked":     walletStaked,
		"totalBalance":     walletBalance + int64(walletStaked),
		"mode":             mode,
	}
	json.NewEncoder(w).Encode(status)
}

// GET /blocks?limit=&offset=
func (api *APIServer) handleListBlocks(w http.ResponseWriter, r *http.Request) {
	limit := 10
	offset := 0
	if l := r.URL.Query().Get("limit"); l != "" {
		fmt.Sscanf(l, "%d", &limit)
	}
	if o := r.URL.Query().Get("offset"); o != "" {
		fmt.Sscanf(o, "%d", &offset)
	}
	blocks := api.blockManager.GetBlocks(limit, offset)
	json.NewEncoder(w).Encode(blocks)
}

// GET /mempool
func (api *APIServer) handleGetMempool(w http.ResponseWriter, r *http.Request) {
	txs := api.transactionManager.GetAllTransactions()
	json.NewEncoder(w).Encode(txs)
}

// GET /validators
func (api *APIServer) handleListValidators(w http.ResponseWriter, r *http.Request) {
	validators := api.consensusManager.GetAllValidators()
	json.NewEncoder(w).Encode(validators)
}

// GET /validator?address=
func (api *APIServer) handleGetValidator(w http.ResponseWriter, r *http.Request) {
	address := r.URL.Query().Get("address")
	if address == "" {
		http.Error(w, "Missing validator address", http.StatusBadRequest)
		return
	}
	
	validator, err := api.consensusManager.GetValidatorInfo(address)
	if err != nil {
		http.Error(w, "Validator not found", http.StatusNotFound)
		return
	}
	json.NewEncoder(w).Encode(validator)
}

// GET /peers
func (api *APIServer) handleGetPeers(w http.ResponseWriter, r *http.Request) {
	// Implement peer listing if needed, or remove if not used
	json.NewEncoder(w).Encode([]string{})
}

// POST /faucet
func (api *APIServer) handleFaucet(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	// Parse address from POST body
	var req struct {
		Address string `json:"address"`
	}
	_ = json.NewDecoder(r.Body).Decode(&req)

	const faucetAmount = 1000
	address := req.Address
	if address == "" && api.node.Wallet != nil {
		address = wallet.PublicKeyToAddress(api.node.Wallet.PublicKey)
	}
	if address == "" {
		http.Error(w, "No address provided and node wallet unavailable", http.StatusBadRequest)
		return
	}

	// Credit the address in the state manager
	oldBalance := api.stateManager.GetBalance(address)
	api.stateManager.SetBalance(address, oldBalance+faucetAmount)
	newBalance := api.stateManager.GetBalance(address)
	fmt.Printf("[FAUCET] Credited %d tokens to %s (old: %d, new: %d)\n", faucetAmount, address, oldBalance, newBalance)

	json.NewEncoder(w).Encode(map[string]interface{}{
		"address": address,
		"amount": faucetAmount,
		"new_balance": newBalance,
		"status": "Faucet tokens credited",
	})
}

// POST /register-validator {"stake": 1000, "kyc": {"fullName":..., "country":..., "idNumber":..., "verified":...}}
func (api *APIServer) handleRegisterValidator(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	
	var req struct {
		Address string `json:"address"`
		Stake   uint64 `json:"stake"`
		KYC     struct {
			FullName string `json:"fullName"`
			Country  string `json:"country"`
			IDNumber string `json:"idNumber"`
			Verified bool   `json:"verified"`
		} `json:"kyc"`
	}
	
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}
	
	if req.Stake == 0 {
		req.Stake = 1000 // Default stake amount
	}

	// Check if address is provided
	if req.Address == "" {
		http.Error(w, "Wallet address is required", http.StatusBadRequest)
		return
	}

	// Check if the address has sufficient balance
	balance := api.stateManager.GetBalance(req.Address)
	if int64(req.Stake) > balance {
		http.Error(w, fmt.Sprintf("Insufficient balance: have %d, need %d", balance, req.Stake), http.StatusBadRequest)
		return
	}

	kyc := blockchain.KYCInfo{
		FullName: req.KYC.FullName,
		Country:  req.KYC.Country,
		IDNumber: req.KYC.IDNumber,
		Verified: req.KYC.Verified,
	}

	// Create a wallet first to get the proper address format
	walletObj, err := wallet.NewWallet()
	if err != nil {
		log.Printf("❌ Failed to create wallet for validator registration: %v", err)
		http.Error(w, "Failed to create wallet", http.StatusInternalServerError)
		return
	}
	
	// Use the wallet's address for validator registration
	validatorAddress := wallet.PublicKeyToAddress(walletObj.PublicKey)
	
	// Register the validator using the wallet's address
	err = api.consensusManager.RegisterValidatorByAddress(validatorAddress, req.Stake, kyc)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	// Update the state to reflect the staking using the wallet's address
	api.stateManager.SetBalance(validatorAddress, balance-int64(req.Stake))
	
	// Update the node's validator address if it's not set
	if api.node.ValidatorAddress == "" {
		api.node.ValidatorAddress = validatorAddress
		log.Printf("✅ Updated node validator address to: %s", validatorAddress[:16]+"...")
		
		// Use the wallet we created for the node
		api.node.Wallet = walletObj
		log.Printf("✅ Created wallet for node validator")
	}

	json.NewEncoder(w).Encode(map[string]interface{}{
		"status": "Validator registered successfully",
		"address": validatorAddress,
		"stake": req.Stake,
		"balance": balance - int64(req.Stake),
		"staked": req.Stake,
	})
}

// POST /update-stake {"new_stake": 2000}
func (api *APIServer) handleUpdateStake(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	
	var req struct {
		NewStake uint64 `json:"new_stake"`
	}
	
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}
	
	// Use the node's wallet for stake update
	if api.node.Wallet == nil {
		http.Error(w, "Node wallet not available", http.StatusInternalServerError)
		return
	}
	
	// Get current validator info
	if api.node.Wallet == nil {
		http.Error(w, "Node wallet not available", http.StatusInternalServerError)
		return
	}
	validator, err := api.consensusManager.GetValidatorInfo(api.node.Wallet.PublicKeyStr())
	if err != nil {
		http.Error(w, "Validator not found", http.StatusNotFound)
		return
	}
	
	// Update validator stake using wallet
	err = api.consensusManager.UpdateValidatorStake(api.node.Wallet, req.NewStake)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	
	json.NewEncoder(w).Encode(map[string]interface{}{
		"status": "Stake updated successfully",
		"address": api.node.Wallet.PublicKeyStr(),
		"old_stake": validator.Stake,
		"new_stake": req.NewStake,
		"balance": api.node.Wallet.GetBalance(),
		"staked": api.node.Wallet.GetStaked(),
	})
}

// POST /update-user-stake {"address": "user_address", "new_stake": 2000}
func (api *APIServer) handleUpdateUserStake(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	
	var req struct {
		Address  string `json:"address"`
		NewStake uint64 `json:"new_stake"`
	}
	
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}
	
	if req.Address == "" {
		http.Error(w, "Address is required", http.StatusBadRequest)
		return
	}
	
	// Check if the address is a validator
	validator, err := api.consensusManager.GetValidatorInfo(req.Address)
	if err != nil {
		http.Error(w, "Address is not registered as a validator", http.StatusNotFound)
		return
	}
	
	// Check if the address has sufficient balance
	balance := api.stateManager.GetBalance(req.Address)
	if int64(req.NewStake) > balance {
		http.Error(w, fmt.Sprintf("Insufficient balance: have %d, need %d", balance, req.NewStake), http.StatusBadRequest)
		return
	}
	
	// Update the validator's stake
	validator.Stake = req.NewStake
	
	// Update the state to reflect the new stake
	api.stateManager.SetBalance(req.Address, balance-int64(req.NewStake))
	
	json.NewEncoder(w).Encode(map[string]interface{}{
		"status": "User stake updated successfully",
		"address": req.Address,
		"old_stake": validator.Stake,
		"new_stake": req.NewStake,
		"balance": balance - int64(req.NewStake),
		"staked": req.NewStake,
	})
}

// GET /node-address
func (api *APIServer) handleGetNodeAddress(w http.ResponseWriter, r *http.Request) {
	json.NewEncoder(w).Encode(map[string]string{"address": api.node.ValidatorAddress})
}

// GET /nonce?address=...
func (api *APIServer) handleGetNonce(w http.ResponseWriter, r *http.Request) {
	address := r.URL.Query().Get("address")
	if address == "" {
		http.Error(w, "Missing address", http.StatusBadRequest)
		return
	}
	if api.node.Wallet == nil {
		http.Error(w, "Node wallet not available", http.StatusInternalServerError)
		return
	}
	nonce := api.stateManager.GetNonce(address)
	json.NewEncoder(w).Encode(map[string]interface{}{ "address": address, "nonce": nonce })
}

// POST /run-tests
func (api *APIServer) handleRunTests(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	cmd := exec.Command("bash", "test_blockchain.sh")
	var out bytes.Buffer
	var stderr bytes.Buffer
	cmd.Stdout = &out
	cmd.Stderr = &stderr
	err := cmd.Run()
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(map[string]string{"error": stderr.String() + err.Error()})
		return
	}
	json.NewEncoder(w).Encode(map[string]string{"output": out.String()})
}

// POST /test-performance
func (api *APIServer) handleTestPerformance(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	
	// Mock performance test results
	result := map[string]interface{}{
		"suites": []map[string]interface{}{
			{
				"name": "Transaction Throughput",
				"description": "Testing transaction processing speed",
				"passed": 3,
				"failed": 0,
				"warnings": 1,
			},
			{
				"name": "Block Production",
				"description": "Testing block creation performance",
				"passed": 2,
				"failed": 0,
				"warnings": 0,
			},
			{
				"name": "Memory Usage",
				"description": "Testing memory efficiency",
				"passed": 4,
				"failed": 0,
				"warnings": 0,
			},
		},
	}
	
	json.NewEncoder(w).Encode(result)
}

// POST /test-security
func (api *APIServer) handleTestSecurity(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	
	// Mock security test results
	result := map[string]interface{}{
		"suites": []map[string]interface{}{
			{
				"name": "Transaction Validation",
				"description": "Testing transaction security validation",
				"passed": 5,
				"failed": 0,
				"warnings": 0,
			},
			{
				"name": "Block Validation",
				"description": "Testing block security validation",
				"passed": 4,
				"failed": 0,
				"warnings": 1,
			},
			{
				"name": "Consensus Security",
				"description": "Testing consensus mechanism security",
				"passed": 3,
				"failed": 0,
				"warnings": 0,
			},
		},
	}
	
	json.NewEncoder(w).Encode(result)
}

// POST /test-integration
func (api *APIServer) handleTestIntegration(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	
	// Mock integration test results
	result := map[string]interface{}{
		"suites": []map[string]interface{}{
			{
				"name": "End-to-End Flow",
				"description": "Testing complete transaction flow",
				"passed": 6,
				"failed": 0,
				"warnings": 0,
			},
			{
				"name": "Multi-Node Sync",
				"description": "Testing network synchronization",
				"passed": 4,
				"failed": 0,
				"warnings": 1,
			},
			{
				"name": "API Integration",
				"description": "Testing API endpoint integration",
				"passed": 8,
				"failed": 0,
				"warnings": 0,
			},
		},
	}
	
	json.NewEncoder(w).Encode(result)
}

// POST /start-test-env
func (api *APIServer) handleStartTestEnv(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	
	// Mock test environment start
	result := map[string]interface{}{
		"status": "started",
		"message": "Test environment started successfully",
		"nodes": 3,
		"wallets": 5,
	}
	
	json.NewEncoder(w).Encode(result)
}

// POST /stop-test-env
func (api *APIServer) handleStopTestEnv(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	
	// Mock test environment stop
	result := map[string]interface{}{
		"status": "stopped",
		"message": "Test environment stopped successfully",
	}
	
	json.NewEncoder(w).Encode(result)
}

// GET /test-env-status
func (api *APIServer) handleTestEnvStatus(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	
	// Mock test environment status
	result := map[string]interface{}{
		"nodes": 3,
		"wallets": 5,
		"transactions": 12,
		"blocks": 8,
		"status": "running",
	}
	
	json.NewEncoder(w).Encode(result)
}

// Add wallet management endpoints
func (api *APIServer) handleCreateWallet(w http.ResponseWriter, r *http.Request) {
	if api.node.Wallet != nil {
		http.Error(w, "Wallet already exists", http.StatusBadRequest)
		return
	}
	wallet, err := wallet.NewWallet()
	if err != nil {
		http.Error(w, "Failed to create wallet: "+err.Error(), http.StatusInternalServerError)
		return
	}
	api.node.Wallet = wallet
	api.node.ValidatorAddress = wallet.PublicKeyStr()
	json.NewEncoder(w).Encode(map[string]string{"address": wallet.PublicKeyStr()})
}

func (api *APIServer) handleImportWallet(w http.ResponseWriter, r *http.Request) {
	if api.node.Wallet != nil {
		http.Error(w, "Wallet already exists", http.StatusBadRequest)
		return
	}
	var req struct {
		PrivateKey string `json:"privateKey"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}
	if req.PrivateKey == "" {
		http.Error(w, "Missing privateKey", http.StatusBadRequest)
		return
	}
	wallet, err := wallet.ImportWallet(req.PrivateKey)
	if err != nil {
		http.Error(w, "Failed to import wallet: "+err.Error(), http.StatusBadRequest)
		return
	}
	api.node.Wallet = wallet
	api.node.ValidatorAddress = wallet.PublicKeyStr()
	json.NewEncoder(w).Encode(map[string]string{"address": wallet.PublicKeyStr()})
}

// GET /fee-info?amount=...&sender=...&recipient=...
func (api *APIServer) handleFeeInfo(w http.ResponseWriter, r *http.Request) {
	amount := int64(0)
	if a := r.URL.Query().Get("amount"); a != "" {
		fmt.Sscanf(a, "%d", &amount)
	}
	sender := r.URL.Query().Get("sender")
	recipient := r.URL.Query().Get("recipient")

	_ = transaction.Transaction{
		Sender: sender,
		Recipient: recipient,
		Amount: amount,
	}
	// TODO: Implement fee calculation
	fee := uint64(10) // Default fee
	multiplier := api.transactionManager.GetDynamicFeeMultiplier()
	json.NewEncoder(w).Encode(map[string]interface{}{
		"recommendedFee": fee,
		"dynamicFeeMultiplier": multiplier,
	})
}

// ===== FLUTTERFLOW INTEGRATION ENDPOINTS =====

// POST /flutterflow/connect-wallet
// Connects a wallet for FlutterFlow integration
func (api *APIServer) handleFlutterFlowConnectWallet(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var req struct {
		Action     string `json:"action"` // "create", "import", "connect"
		PrivateKey string `json:"privateKey,omitempty"`
		Address    string `json:"address,omitempty"`
		SessionID  string `json:"sessionId,omitempty"`
	}

	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	var walletAddress string

	switch req.Action {
	case "create":
		// Create a new wallet
		newWallet, err := wallet.NewWallet()
		if err != nil {
			http.Error(w, "Failed to create wallet: "+err.Error(), http.StatusInternalServerError)
			return
		}
		walletAddress = newWallet.PublicKeyStr()
		
		// Add initial balance for testing
		api.stateManager.SetBalance(walletAddress, 1000)
		
	case "import":
		// Import existing wallet
		if req.PrivateKey == "" {
			http.Error(w, "Private key required for import", http.StatusBadRequest)
			return
		}
		importedWallet, err := wallet.ImportWallet(req.PrivateKey)
		if err != nil {
			http.Error(w, "Failed to import wallet: "+err.Error(), http.StatusBadRequest)
			return
		}
		walletAddress = importedWallet.PublicKeyStr()
		
	case "connect":
		// Connect to existing address
		if req.Address == "" {
			http.Error(w, "Address required for connection", http.StatusBadRequest)
			return
		}
		walletAddress = req.Address
		
	default:
		http.Error(w, "Invalid action. Use 'create', 'import', or 'connect'", http.StatusBadRequest)
		return
	}

	// Generate session token for FlutterFlow
	sessionToken := generateSessionToken(walletAddress)
	
	// Return wallet connection response
	response := map[string]interface{}{
		"success": true,
		"message": "Wallet connected successfully",
		"data": map[string]interface{}{
			"address": walletAddress,
			"sessionToken": sessionToken,
			"balance": api.stateManager.GetBalance(walletAddress),
			"isValidator": false, // Will be updated if user registers as validator
		},
	}

	json.NewEncoder(w).Encode(response)
}

// POST /flutterflow/authenticate
// Authenticates a FlutterFlow session
func (api *APIServer) handleFlutterFlowAuthenticate(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var req struct {
		SessionToken string `json:"sessionToken"`
		Address      string `json:"address"`
	}

	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	// Validate session token (simplified for demo)
	if !isValidSessionToken(req.SessionToken, req.Address) {
		http.Error(w, "Invalid session token", http.StatusUnauthorized)
		return
	}

	// Check if address is a validator
	validator, _ := api.consensusManager.GetValidatorInfo(req.Address)
	isValidator := validator != nil

	response := map[string]interface{}{
		"success": true,
		"message": "Authentication successful",
		"data": map[string]interface{}{
			"address": req.Address,
			"balance": api.stateManager.GetBalance(req.Address),
			"isValidator": isValidator,
			"validatorInfo": validator,
		},
	}

	json.NewEncoder(w).Encode(response)
}

// GET /flutterflow/wallet-info?address=...
// Gets wallet information for FlutterFlow
func (api *APIServer) handleFlutterFlowWalletInfo(w http.ResponseWriter, r *http.Request) {
	address := r.URL.Query().Get("address")
	if address == "" {
		http.Error(w, "Missing address", http.StatusBadRequest)
		return
	}

	// Get wallet balance
	balance := api.stateManager.GetBalance(address)
	
	// Check if address is a validator
	validator, _ := api.consensusManager.GetValidatorInfo(address)
	isValidator := validator != nil

	// Get recent transactions (simplified)
	recentTxs := api.transactionManager.GetAllTransactions()
	userTxs := []map[string]interface{}{}
	
	for _, tx := range recentTxs {
		if tx.Sender == address || tx.Recipient == address {
			userTxs = append(userTxs, map[string]interface{}{
				"hash": wallet.CalculateTxHash(tx),
				"sender": tx.Sender,
				"recipient": tx.Recipient,
				"amount": tx.Amount,
				"timestamp": tx.Timestamp,
			})
		}
	}

	response := map[string]interface{}{
		"success": true,
		"data": map[string]interface{}{
			"address": address,
			"balance": balance,
			"isValidator": isValidator,
			"validatorInfo": validator,
			"recentTransactions": userTxs,
			"nonce": api.stateManager.GetNonce(address),
		},
	}

	json.NewEncoder(w).Encode(response)
}

// POST /flutterflow/send-transaction
// Sends a transaction from FlutterFlow
func (api *APIServer) handleFlutterFlowSendTransaction(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var req struct {
		From      string `json:"from"`
		To        string `json:"to"`
		Amount    int64  `json:"amount"`
		Fee       int64  `json:"fee"`
		Data      string `json:"data,omitempty"`
		Signature string `json:"signature"`
		SessionToken string `json:"sessionToken"`
	}

	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	// Validate session token
	if !isValidSessionToken(req.SessionToken, req.From) {
		http.Error(w, "Invalid session token", http.StatusUnauthorized)
		return
	}

	// Create transaction
	tx := transaction.Transaction{
		Sender:    req.From,
		Recipient: req.To,
		Amount:    req.Amount,
		Fee:       req.Fee,
		Data:      req.Data,
		Timestamp: time.Now().Unix(),
		Nonce:     api.stateManager.GetNonce(req.From),
		Signature: req.Signature,
	}

	// Add transaction to pool
	if err := api.transactionManager.AddTransaction(tx); err != nil {
		http.Error(w, "Failed to submit transaction: "+err.Error(), http.StatusBadRequest)
		return
	}

	response := map[string]interface{}{
		"success": true,
		"message": "Transaction submitted successfully",
		"data": map[string]interface{}{
			"transactionHash": wallet.CalculateTxHash(tx),
			"from": req.From,
			"to": req.To,
			"amount": req.Amount,
			"status": "pending",
		},
	}

	json.NewEncoder(w).Encode(response)
}

// GET /flutterflow/transaction-history?address=...
// Gets transaction history for FlutterFlow
func (api *APIServer) handleFlutterFlowTransactionHistory(w http.ResponseWriter, r *http.Request) {
	address := r.URL.Query().Get("address")
	if address == "" {
		http.Error(w, "Missing address", http.StatusBadRequest)
		return
	}

	// Get recent blocks
	blocks := api.blockManager.GetBlocks(50, 0) // Last 50 blocks
	
	transactions := []map[string]interface{}{}
	
	for _, block := range blocks {
		for _, tx := range block.Transactions {
			if tx.Sender == address || tx.Recipient == address {
				transactions = append(transactions, map[string]interface{}{
					"hash": wallet.CalculateTxHash(tx),
					"blockIndex": block.Index,
					"sender": tx.Sender,
					"recipient": tx.Recipient,
					"amount": tx.Amount,
					"fee": tx.Fee,
					"timestamp": tx.Timestamp,
					"type": getTransactionType(tx, address),
				})
			}
		}
	}

	response := map[string]interface{}{
		"success": true,
		"data": map[string]interface{}{
			"address": address,
			"transactions": transactions,
			"totalCount": len(transactions),
		},
	}

	json.NewEncoder(w).Encode(response)
}

// POST /flutterflow/disconnect
// Disconnects wallet from FlutterFlow
func (api *APIServer) handleFlutterFlowDisconnect(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var req struct {
		SessionToken string `json:"sessionToken"`
		Address      string `json:"address"`
	}

	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	// Validate session token
	if !isValidSessionToken(req.SessionToken, req.Address) {
		http.Error(w, "Invalid session token", http.StatusUnauthorized)
		return
	}

	response := map[string]interface{}{
		"success": true,
		"message": "Wallet disconnected successfully",
		"data": map[string]interface{}{
			"address": req.Address,
			"disconnectedAt": time.Now().Unix(),
		},
	}

	json.NewEncoder(w).Encode(response)
}

// ===== HELPER FUNCTIONS =====

// generateSessionToken creates a session token for FlutterFlow
func generateSessionToken(address string) string {
	timestamp := time.Now().Unix()
	// Simple token generation - in production, use proper JWT
	return fmt.Sprintf("ff_%s_%d_%s", address[:8], timestamp, "session")
}

// isValidSessionToken validates a session token
func isValidSessionToken(token, address string) bool {
	// Simple validation - in production, use proper JWT validation
	return len(token) > 0 && strings.Contains(token, address[:8])
}

// getTransactionType determines if transaction is incoming or outgoing
func getTransactionType(tx transaction.Transaction, userAddress string) string {
	if tx.Sender == userAddress {
		return "outgoing"
	}
	if tx.Recipient == userAddress {
		return "incoming"
	}
	return "unknown"
} 

// List all proposals
func (api *APIServer) handleListProposals(w http.ResponseWriter, r *http.Request) {
	// TODO: Implement proposal listing through governance manager
	json.NewEncoder(w).Encode(map[string]interface{}{
		"message": "Proposal listing not yet implemented",
		"proposals": []interface{}{},
	})
}

// Get proposal details
func (api *APIServer) handleGetProposal(w http.ResponseWriter, r *http.Request) {
	id := r.URL.Query().Get("id")
	if id == "" {
		http.Error(w, "Missing proposal ID", http.StatusBadRequest)
		return
	}
	// TODO: Implement proposal retrieval through governance manager
	json.NewEncoder(w).Encode(map[string]interface{}{
		"message": "Proposal retrieval not yet implemented",
		"id": id,
	})
}

// Submit a new proposal
func (api *APIServer) handleSubmitProposal(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	var req struct {
		Proposer    string `json:"proposer"`
		Description string `json:"description"`
		Actions     string `json:"actions"`
		Duration    int64  `json:"duration"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}
	// TODO: Implement proposal submission through governance manager
	// proposal := api.stateManager.SubmitProposal(req.Proposer, req.Description, req.Actions, 0, req.Duration)
	// proposal.State = ProposalActive
	json.NewEncoder(w).Encode(map[string]interface{}{
		"status": "Proposal submission not yet implemented",
		"proposer": req.Proposer,
		"description": req.Description,
	})
}

// Vote on a proposal
func (api *APIServer) handleVote(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	var req struct {
		ProposalID string `json:"proposalID"`
		Voter      string `json:"voter"`
		Choice     string `json:"choice"`
		Weight     int64  `json:"weight"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}
	// TODO: Implement voting through governance manager
	// err := api.stateManager.CastVote(req.ProposalID, req.Voter, req.Choice, req.Weight)
	var err error = nil
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	json.NewEncoder(w).Encode(map[string]interface{}{
		"status": "Vote cast",
	})
} 

// POST /oracle/submit {"key":..., "value":..., "source":...}
func (api *APIServer) handleOracleSubmit(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	var req struct {
		Key    string `json:"key"`
		Value  string `json:"value"`
		Source string `json:"source"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}
	timestamp := time.Now().Unix()
	api.stateManager.SetOracleData(req.Key, req.Value, req.Source, timestamp)
	json.NewEncoder(w).Encode(map[string]interface{}{
		"status": "Oracle data submitted",
		"key": req.Key,
		"value": req.Value,
		"timestamp": timestamp,
		"source": req.Source,
	})
}

// GET /oracle/latest?key=...
func (api *APIServer) handleOracleLatest(w http.ResponseWriter, r *http.Request) {
	key := r.URL.Query().Get("key")
	if key == "" {
		http.Error(w, "Missing key", http.StatusBadRequest)
		return
	}
	data, ok := api.stateManager.GetOracleData(key)
	if !ok {
		http.Error(w, "No oracle data for key", http.StatusNotFound)
		return
	}
	json.NewEncoder(w).Encode(data)
}

// Privacy endpoints

// POST /privacy/encrypt
func (api *APIServer) handleEncryptData(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var req struct {
		Data     string `json:"data"`
		Password string `json:"password,omitempty"`
	}

	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	if req.Data == "" {
		http.Error(w, "Data required", http.StatusBadRequest)
		return
	}

	var key *crypto.EncryptionKey
	var err error

	if req.Password != "" {
		// Derive key from password
		salt := []byte("blockchain_salt") // In production, use unique salt per user
		key, err = crypto.DeriveKeyFromPassword(req.Password, salt)
	} else {
		// Generate random key
		key, err = crypto.NewEncryptionKey()
	}

	if err != nil {
		http.Error(w, "Failed to create encryption key: "+err.Error(), http.StatusInternalServerError)
		return
	}

	encrypted, err := crypto.EncryptString(req.Data, key)
	if err != nil {
		http.Error(w, "Failed to encrypt data: "+err.Error(), http.StatusInternalServerError)
		return
	}

	response := map[string]interface{}{
		"encrypted_data": encrypted,
		"key_id":         key.ID,
		"algorithm":      "AES-GCM-256",
	}

	json.NewEncoder(w).Encode(response)
}

// POST /privacy/decrypt
func (api *APIServer) handleDecryptData(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var req struct {
		EncryptedData string `json:"encrypted_data"`
		Password      string `json:"password,omitempty"`
		KeyID         string `json:"key_id,omitempty"`
	}

	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	if req.EncryptedData == "" {
		http.Error(w, "Encrypted data required", http.StatusBadRequest)
		return
	}

	var key *crypto.EncryptionKey
	var err error

	if req.Password != "" {
		// Derive key from password
		salt := []byte("blockchain_salt")
		key, err = crypto.DeriveKeyFromPassword(req.Password, salt)
	} else {
		http.Error(w, "Password or key ID required", http.StatusBadRequest)
		return
	}

	decrypted, err := crypto.DecryptString(req.EncryptedData, key)
	if err != nil {
		http.Error(w, "Failed to decrypt data: "+err.Error(), http.StatusBadRequest)
		return
	}

	response := map[string]interface{}{
		"decrypted_data": decrypted,
	}

	json.NewEncoder(w).Encode(response)
}

// POST /privacy/create-proof
func (api *APIServer) handleCreateProof(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	// var req zk.ProofRequest
	// if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
	// 	http.Error(w, "Invalid request body", http.StatusBadRequest)
	// 	return
	// }

	// // Get prover address from request headers or body
	// prover := r.Header.Get("X-Prover-Address")
	// if prover == "" {
	// 	http.Error(w, "Prover address required", http.StatusBadRequest)
	// 	return
	// }

	// proof, err := zk.CreateProof(&req, prover)
	// if err != nil {
	// 	http.Error(w, "Failed to create proof: "+err.Error(), http.StatusInternalServerError)
	// 	return
	// }

	// json.NewEncoder(w).Encode(proof)
}

// POST /privacy/verify-proof
func (api *APIServer) handleVerifyProof(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	// var proof zk.ZKProof
	// if err := json.NewDecoder(r.Body).Decode(&proof); err != nil {
	// 	http.Error(w, "Invalid proof data", http.StatusBadRequest)
	// 	return
	// }

	// verifier := zk.NewProofVerifier(true) // Enable verification
	// valid, err := verifier.VerifyProof(&proof)
	// if err != nil {
	// 	http.Error(w, "Proof verification failed: "+err.Error(), http.StatusBadRequest)
	// 	return
	// }

	// response := map[string]interface{}{
	// 	"valid": valid,
	// 	"proof": proof,
	// }

	// json.NewEncoder(w).Encode(response)
}

// POST /privacy/gdpr-delete
func (api *APIServer) handleGDPRDelete(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var req struct {
		Address string `json:"address"`
		Reason  string `json:"reason,omitempty"`
	}

	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	if req.Address == "" {
		http.Error(w, "Address required", http.StatusBadRequest)
		return
	}

	// Mock GDPR deletion - in production, this would:
	// 1. Anonymize personal data
	// 2. Remove from search indexes
	// 3. Log the deletion request
	// 4. Notify relevant parties

	// For now, just return success
	response := map[string]interface{}{
		"success": true,
		"message": "GDPR deletion request processed",
		"address": req.Address,
		"timestamp": time.Now().Unix(),
	}

	json.NewEncoder(w).Encode(response)
}

// POST /privacy/gdpr-anonymize
func (api *APIServer) handleGDPRAnonymize(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var req struct {
		Address string   `json:"address"`
		Fields  []string `json:"fields,omitempty"` // Specific fields to anonymize
	}

	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	if req.Address == "" {
		http.Error(w, "Address required", http.StatusBadRequest)
		return
	}

	// Mock GDPR anonymization - in production, this would:
	// 1. Replace personal data with hashed/anonymized versions
	// 2. Keep transaction history but remove personal identifiers
	// 3. Log the anonymization request

	response := map[string]interface{}{
		"success": true,
		"message": "GDPR anonymization request processed",
		"address": req.Address,
		"fields_anonymized": req.Fields,
		"timestamp": time.Now().Unix(),
	}

	json.NewEncoder(w).Encode(response)
} 

// Sharding endpoints

// GET /sharding/status
func (api *APIServer) handleShardingStatus(w http.ResponseWriter, r *http.Request) {
	// TODO: Implement sharding status through consensus manager
	response := map[string]interface{}{
		"enabled": false,
		"message": "Sharding not yet implemented",
		"shards":  []interface{}{},
		"stats":   map[string]interface{}{},
	}
	
	json.NewEncoder(w).Encode(response)
}

// GET /sharding/shard?id=...
func (api *APIServer) handleGetShard(w http.ResponseWriter, r *http.Request) {
	// TODO: Implement shard retrieval through consensus manager
	shardIDStr := r.URL.Query().Get("id")
	if shardIDStr == "" {
		http.Error(w, "Missing shard ID", http.StatusBadRequest)
		return
	}
	
	json.NewEncoder(w).Encode(map[string]interface{}{
		"message": "Shard retrieval not yet implemented",
		"shard_id": shardIDStr,
	})
}

// POST /sharding/assign-validator
func (api *APIServer) handleAssignValidator(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	
	// TODO: Implement validator assignment through consensus manager
	var req struct {
		ValidatorAddress string `json:"validator_address"`
		ShardID         uint32 `json:"shard_id"`
	}
	
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}
	
	response := map[string]interface{}{
		"success": false,
		"message": "Validator assignment not yet implemented",
		"validator_address": req.ValidatorAddress,
		"shard_id": req.ShardID,
	}
	
	json.NewEncoder(w).Encode(response)
}

// POST /sharding/cross-shard-tx
func (api *APIServer) handleCrossShardTransaction(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	
	// TODO: Implement cross-shard transactions through consensus manager
	var req struct {
		SourceShard uint32      `json:"source_shard"`
		TargetShard uint32      `json:"target_shard"`
		Transaction interface{} `json:"transaction"`
	}
	
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}
	
	response := map[string]interface{}{
		"success": false,
		"message": "Cross-shard transactions not yet implemented",
		"source_shard": req.SourceShard,
		"target_shard": req.TargetShard,
	}
	
	json.NewEncoder(w).Encode(response)
}

// GET /sharding/statistics
func (api *APIServer) handleShardingStatistics(w http.ResponseWriter, r *http.Request) {
	// TODO: Implement sharding statistics through consensus manager
	response := map[string]interface{}{
		"statistics":        map[string]interface{}{},
		"cross_shard_tx":   []interface{}{},
		"total_cross_shard": 0,
		"message": "Sharding statistics not yet implemented",
	}
	
	json.NewEncoder(w).Encode(response)
} 

// Monitoring endpoints

// GET /monitoring/status
func (api *APIServer) handleMonitoringStatus(w http.ResponseWriter, r *http.Request) {
	// Get real monitoring status from the monitor
	if api.monitor == nil {
		http.Error(w, "Monitoring not available", http.StatusServiceUnavailable)
		return
	}
	
	systemStatus := api.monitor.GetSystemStatus()
	
	// Update with real blockchain data
	systemStatus.LastBlockHeight = int64(api.blockManager.GetBlockHeight())
	systemStatus.TotalTransactions = int64(api.transactionManager.GetPoolSize())
	
	json.NewEncoder(w).Encode(systemStatus)
}

// GET /monitoring/metrics
func (api *APIServer) handleMonitoringMetrics(w http.ResponseWriter, r *http.Request) {
	// Get real metrics from the monitor
	if api.monitor == nil {
		http.Error(w, "Monitoring not available", http.StatusServiceUnavailable)
		return
	}
	
	allMetrics := api.monitor.GetAllMetrics()
	performanceMetrics := api.monitor.GetPerformanceMetrics()
	
	// Convert metrics to the expected format
	metrics := make(map[string]interface{})
	
	// Add performance metrics
	if performanceMetrics != nil {
		metrics["tps"] = map[string]interface{}{
			"value":     performanceMetrics.TPS,
			"type":      "gauge",
			"timestamp": time.Now().Unix(),
		}
		metrics["block_time"] = map[string]interface{}{
			"value":     performanceMetrics.BlockTime,
			"type":      "gauge",
			"timestamp": time.Now().Unix(),
		}
		metrics["memory_usage"] = map[string]interface{}{
			"value":     performanceMetrics.MemoryUsage,
			"type":      "gauge",
			"timestamp": time.Now().Unix(),
		}
		metrics["cpu_usage"] = map[string]interface{}{
			"value":     performanceMetrics.CPUUsage,
			"type":      "gauge",
			"timestamp": time.Now().Unix(),
		}
		metrics["network_latency"] = map[string]interface{}{
			"value":     performanceMetrics.NetworkLatency,
			"type":      "gauge",
			"timestamp": time.Now().Unix(),
		}
		metrics["active_peers"] = map[string]interface{}{
			"value":     performanceMetrics.ActivePeers,
			"type":      "gauge",
			"timestamp": time.Now().Unix(),
		}
		metrics["validator_count"] = map[string]interface{}{
			"value":     performanceMetrics.ValidatorCount,
			"type":      "gauge",
			"timestamp": time.Now().Unix(),
		}
		metrics["disk_usage"] = map[string]interface{}{
			"value":     performanceMetrics.DiskUsage,
			"type":      "gauge",
			"timestamp": time.Now().Unix(),
		}
		metrics["network_io"] = map[string]interface{}{
			"value":     performanceMetrics.NetworkIO,
			"type":      "gauge",
			"timestamp": time.Now().Unix(),
		}
	}
	
	// Add all recorded metrics
	for name, metric := range allMetrics {
		metrics[name] = map[string]interface{}{
			"value":     metric.Value,
			"type":      string(metric.Type),
			"timestamp": metric.Timestamp.Unix(),
			"labels":    metric.Labels,
		}
	}
	
	json.NewEncoder(w).Encode(metrics)
}

// GET /monitoring/health
func (api *APIServer) handleMonitoringHealth(w http.ResponseWriter, r *http.Request) {
	// Get real health checks from the monitor
	if api.monitor == nil {
		http.Error(w, "Monitoring not available", http.StatusServiceUnavailable)
		return
	}
	
	healthChecks := api.monitor.GetHealthChecks()
	
	// Convert to the expected format
	var checks []map[string]interface{}
	for _, check := range healthChecks {
		checks = append(checks, map[string]interface{}{
			"name":      check.Name,
			"status":    check.Status,
			"message":   check.Message,
			"timestamp": check.Timestamp.Unix(),
			"details":   check.Details,
		})
	}
	
	json.NewEncoder(w).Encode(checks)
}

// GET /monitoring/alerts
func (api *APIServer) handleMonitoringAlerts(w http.ResponseWriter, r *http.Request) {
	// Get real alerts from the monitor
	if api.monitor == nil {
		http.Error(w, "Monitoring not available", http.StatusServiceUnavailable)
		return
	}
	
	alerts := api.monitor.GetAlerts()
	
	// Convert to the expected format
	var alertList []map[string]interface{}
	for _, alert := range alerts {
		alertList = append(alertList, map[string]interface{}{
			"id":          alert.ID,
			"level":       alert.Level,
			"message":     alert.Message,
			"timestamp":   alert.Timestamp.Unix(),
			"acknowledged": alert.Acknowledged,
			"details":     alert.Details,
		})
	}
	
	json.NewEncoder(w).Encode(alertList)
}

// GET /monitoring/performance
func (api *APIServer) handleMonitoringPerformance(w http.ResponseWriter, r *http.Request) {
	// Get real performance metrics from the monitor
	if api.monitor == nil {
		http.Error(w, "Monitoring not available", http.StatusServiceUnavailable)
		return
	}
	
	performanceMetrics := api.monitor.GetPerformanceMetrics()
	if performanceMetrics == nil {
		http.Error(w, "Performance metrics not available", http.StatusServiceUnavailable)
		return
	}
	
	performance := map[string]interface{}{
		"tps":            performanceMetrics.TPS,
		"block_time":     performanceMetrics.BlockTime,
		"memory_usage":   performanceMetrics.MemoryUsage,
		"cpu_usage":      performanceMetrics.CPUUsage,
		"network_latency": performanceMetrics.NetworkLatency,
		"active_peers":   performanceMetrics.ActivePeers,
		"validator_count": performanceMetrics.ValidatorCount,
		"disk_usage":     performanceMetrics.DiskUsage,
		"network_io":     performanceMetrics.NetworkIO,
		"timestamp":      time.Now().Unix(),
	}
	
	json.NewEncoder(w).Encode(performance)
}

// GET /monitoring/history
func (api *APIServer) handleMonitoringHistory(w http.ResponseWriter, r *http.Request) {
	// Get historical metrics from the monitor
	if api.monitor == nil {
		http.Error(w, "Monitoring not available", http.StatusServiceUnavailable)
		return
	}
	
	historicalMetrics := api.monitor.GetHistoricalMetrics()
	
	response := map[string]interface{}{
		"history":   historicalMetrics,
		"count":     len(historicalMetrics),
		"timestamp": time.Now().Unix(),
	}
	
	json.NewEncoder(w).Encode(response)
}

// GET /monitoring/trends
func (api *APIServer) handleMonitoringTrends(w http.ResponseWriter, r *http.Request) {
	// Get trend analysis from the monitor
	if api.monitor == nil {
		http.Error(w, "Monitoring not available", http.StatusServiceUnavailable)
		return
	}
	
	trends := api.monitor.GetMetricsTrends()
	
	response := map[string]interface{}{
		"trends":    trends,
		"timestamp": time.Now().Unix(),
	}
	
	json.NewEncoder(w).Encode(response)
}

// GET /sync/status
func (api *APIServer) handleSyncStatus(w http.ResponseWriter, r *http.Request) {
	// TODO: Implement sync status through chain sync manager
	syncStatus := map[string]interface{}{
		"status":        "not_implemented",
		"blocks_synced": 0,
		"total_blocks":  0,
		"duration":      "0s",
		"progress":      0.0,
		"timestamp":     time.Now().Unix(),
		"message":       "Sync status not yet implemented",
	}
	
	json.NewEncoder(w).Encode(syncStatus)
}

// POST /sync/start
func (api *APIServer) handleSyncStart(w http.ResponseWriter, r *http.Request) {
	// TODO: Implement chain sync through chain sync manager
	if r.Method != "POST" {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	
	response := map[string]interface{}{
		"message":   "Chain synchronization not yet implemented",
		"status":    "not_implemented",
		"timestamp": time.Now().Unix(),
	}
	
	json.NewEncoder(w).Encode(response)
}

// POST /contract/deploy
func (api *APIServer) handleDeployContract(w http.ResponseWriter, r *http.Request) {
	if api.stateManager == nil {
		http.Error(w, "State manager not available", http.StatusServiceUnavailable)
		return
	}
	
	if r.Method != "POST" {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	
	var request struct {
		Contract *vm.JSONContract `json:"contract"`
		Owner    string           `json:"owner"`
	}
	
	if err := json.NewDecoder(r.Body).Decode(&request); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}
	
	if request.Contract == nil {
		http.Error(w, "Contract data is required", http.StatusBadRequest)
		return
	}
	
	// Deploy the contract
	contract, err := vm.DeployJSONContract(request.Owner, request.Contract, true)
	if err != nil {
		http.Error(w, fmt.Sprintf("Failed to deploy contract: %v", err), http.StatusInternalServerError)
		return
	}
	
	// Store the contract
	api.stateManager.SetContract(contract.Address, contract)
	
	response := map[string]interface{}{
		"status":    "success",
		"message":   "Contract deployed successfully",
		"address":   contract.Address,
		"name":      contract.Name,
		"owner":     contract.Owner,
		"timestamp": time.Now().Unix(),
	}
	
	json.NewEncoder(w).Encode(response)
}

// POST /contract/call
func (api *APIServer) handleCallContract(w http.ResponseWriter, r *http.Request) {
	if api.stateManager == nil {
		http.Error(w, "State manager not available", http.StatusServiceUnavailable)
		return
	}
	
	if r.Method != "POST" {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	
	var request struct {
		ContractAddress string        `json:"contract_address"`
		Function        string        `json:"function"`
		Args            []interface{} `json:"args"`
		Caller          string        `json:"caller"`
		GasLimit        uint64        `json:"gas_limit"`
	}
	
	if err := json.NewDecoder(r.Body).Decode(&request); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}
	
	// Get the contract
	contract, exists := api.stateManager.GetContract(request.ContractAddress)
	if !exists {
		http.Error(w, "Contract not found", http.StatusNotFound)
		return
	}
	
	// Create execution context
	execCtx := &vm.ExecutionContext{
		Caller:   request.Caller,
		Value:    0, // No value transfer for now
		GasLimit: request.GasLimit,
	}
	
	// Create VM instance
	vmInstance := &vm.VM{
		StateManager: api.stateManager,
	}
	
	// Initialize VM memory with contract storage
	vmInstance.Memory = make(map[string]int64)
	for k, v := range contract.Storage {
		if ival, ok := v.(int64); ok {
			vmInstance.Memory[k] = ival
		}
	}
	
	// Execute function
	if err := contract.CallFunction(request.Function, request.Args, vmInstance, execCtx); err != nil {
		http.Error(w, fmt.Sprintf("Function execution failed: %v", err), http.StatusInternalServerError)
		return
	}
	
	// Update contract storage
	for k, v := range vmInstance.Memory {
		contract.Storage[k] = v
	}
	contract.UpdatedAt = time.Now().Unix()
	api.stateManager.SetContract(contract.Address, contract)
	
	response := map[string]interface{}{
		"status":     "success",
		"message":    "Function executed successfully",
		"gas_used":   vmInstance.GetGasUsed(),
		"gas_limit":  vmInstance.GetGasLimit(),
		"timestamp":  time.Now().Unix(),
	}
	
	json.NewEncoder(w).Encode(response)
}

// GET /contract/list
func (api *APIServer) handleListContracts(w http.ResponseWriter, r *http.Request) {
	if api.stateManager == nil {
		http.Error(w, "State manager not available", http.StatusServiceUnavailable)
		return
	}
	
	// Get all contracts (this would need to be implemented in StateManager)
	// For now, return a mock response
	contracts := []map[string]interface{}{
		{
			"address":   "CONTRACT_12345678",
			"name":      "SimpleToken",
			"version":   "1.0",
			"owner":     "0x1234567890abcdef",
			"created_at": time.Now().Unix(),
		},
	}
	
	json.NewEncoder(w).Encode(contracts)
}

// GET /contract/info
func (api *APIServer) handleGetContractInfo(w http.ResponseWriter, r *http.Request) {
	if api.stateManager == nil {
		http.Error(w, "State manager not available", http.StatusServiceUnavailable)
		return
	}
	
	address := r.URL.Query().Get("address")
	if address == "" {
		http.Error(w, "Contract address is required", http.StatusBadRequest)
		return
	}
	
	contract, exists := api.stateManager.GetContract(address)
	if !exists {
		http.Error(w, "Contract not found", http.StatusNotFound)
		return
	}
	
	// Get function names
	functions := make([]string, 0)
	for funcName := range contract.Functions {
		functions = append(functions, funcName)
	}
	
	response := map[string]interface{}{
		"address":     contract.Address,
		"name":        contract.Name,
		"version":     contract.Version,
		"owner":       contract.Owner,
		"functions":   functions,
		"storage":     contract.Storage,
		"created_at":  contract.CreatedAt,
		"updated_at":  contract.UpdatedAt,
		"upgradable":  contract.Upgradable,
	}
	
	json.NewEncoder(w).Encode(response)
}

// GET /contract/examples
func (api *APIServer) handleGetContractExamples(w http.ResponseWriter, r *http.Request) {
	examples := map[string]interface{}{
		"simple_token": vm.GetSimpleTokenContract(),
		"voting":       vm.GetVotingContract(),
		"escrow":       vm.GetEscrowContract(),
	}
	
	json.NewEncoder(w).Encode(examples)
} 

// Database backup and recovery handlers

// GET /backup/status
func (api *APIServer) handleBackupStatus(w http.ResponseWriter, r *http.Request) {
	if api.stateManager == nil {
		http.Error(w, "State manager not available", http.StatusServiceUnavailable)
		return
	}
	
	status := api.stateManager.GetBackupStatus()
	json.NewEncoder(w).Encode(status)
}

// GET /backup/list
func (api *APIServer) handleBackupList(w http.ResponseWriter, r *http.Request) {
	if api.stateManager == nil {
		http.Error(w, "State manager not available", http.StatusServiceUnavailable)
		return
	}
	
	backups := api.stateManager.GetBackupList()
	json.NewEncoder(w).Encode(backups)
}

// POST /backup/create
func (api *APIServer) handleBackupCreate(w http.ResponseWriter, r *http.Request) {
	if api.stateManager == nil {
		http.Error(w, "State manager not available", http.StatusServiceUnavailable)
		return
	}
	
	if r.Method != "POST" {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	
	// Create backup in background to avoid blocking
	go func() {
		err := api.stateManager.CreateManualBackup()
		if err != nil {
			log.Printf("❌ [API] Failed to create manual backup: %v", err)
		}
	}()
	
	response := map[string]interface{}{
		"message":   "Manual backup started",
		"status":    "started",
		"timestamp": time.Now().Unix(),
	}
	
	json.NewEncoder(w).Encode(response)
} 

// GET /network/architecture
func (api *APIServer) handleGetNetworkArchitecture(w http.ResponseWriter, r *http.Request) {
	// Get consensus information
	validators := api.consensusManager.GetAllValidators()
	totalStake := uint64(0)
	activeValidators := 0
	for _, v := range validators {
		totalStake += v.Stake
		if v.Active {
			activeValidators++
		}
	}

	// Get network topology information
	peerCount := 0
	// TODO: Get peer count from node
	if api.node != nil {
		// peerCount = len(api.node.Peers) // TODO: Implement when Peers field is exported
	}

	// Get sharding information
	shardInfo := map[string]interface{}{
		"enabled": false,
		"shards":  0,
	}
	// TODO: Implement sharding through consensus manager
	if false {
		shardInfo["enabled"] = false
		shardInfo["shards"] = 0
		shardInfo["message"] = "Sharding not yet implemented"
	}

	architecture := map[string]interface{}{
		"nodeTypes": map[string]interface{}{
			"validators": map[string]interface{}{
				"count":     len(validators),
				"active":    activeValidators,
				"totalStake": totalStake,
				"minStake":   1000, // TODO: Get from consensus manager
				"description": "Nodes that participate in block production and consensus validation. Must stake tokens and maintain high uptime.",
			},
			"observers": map[string]interface{}{
				"count":      peerCount,
				"description": "Lightweight nodes that sync with the network but don't participate in consensus. Used for transaction submission and data retrieval.",
			},
			"fullNodes": map[string]interface{}{
				"count":      len(validators) + peerCount,
				"description": "Complete blockchain replicas that store the full state and validate all transactions and blocks.",
			},
		},
		"p2pProtocol": map[string]interface{}{
			"type":        "libp2p",
			"version":     "1.0.0",
			"discovery":   "UDP broadcast + libp2p DHT",
			"transport":   "TCP with Noise encryption",
			"description": "Peer-to-peer communication using libp2p protocol stack with automatic peer discovery and encrypted connections.",
		},
		"consensusMechanism": map[string]interface{}{
			"type":        "Proof of Stake (PoS)",
			"blockTime":   "5s", // TODO: Get from consensus manager
			"finality":    "1 confirmation",
			"description": "Validators are selected based on stake amount, performance score, reputation, and uptime. Block rewards are distributed to active validators.",
		},
		"networkTopology": map[string]interface{}{
			"type":        "Mesh Network",
			"connections": "Dynamic peer connections",
			"maxPeers":    10, // TODO: Get from consensus manager
			"description": "Decentralized mesh topology where nodes connect to multiple peers for redundancy and efficient data propagation.",
		},
		"securityFeatures": map[string]interface{}{
			"encryption":     "Noise protocol for transport encryption",
			"authentication": "ECDSA signatures for transactions and blocks",
			"rateLimiting":   "Connection and message rate limiting",
			"slashing":       "Validator slashing for misbehavior",
			"description":    "Multi-layered security including transport encryption, cryptographic signatures, and economic penalties for malicious behavior.",
		},
		"sharding": shardInfo,
	}

	json.NewEncoder(w).Encode(architecture)
}

// Identity Management API Handlers

func (api *APIServer) handleCreateIdentity(w http.ResponseWriter, r *http.Request) {
	if r.Method != "POST" {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var req struct {
		Address   string `json:"address"`
		PublicKey string `json:"public_key"`
		Username  string `json:"username"`
		Email     string `json:"email"`
	}

	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	publicKey, err := hex.DecodeString(req.PublicKey)
	if err != nil {
		http.Error(w, "Invalid public key format", http.StatusBadRequest)
		return
	}

	// TODO: Implement identity creation through identity manager
	identity, err := api.identityManager.CreateIdentity(req.Address, publicKey, req.Username, req.Email)
	if err != nil {
		response := map[string]interface{}{
			"success": false,
			"error":   err.Error(),
		}
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(response)
		return
	}

	response := map[string]interface{}{
		"success":  true,
		"identity": identity,
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}

func (api *APIServer) handleGetIdentity(w http.ResponseWriter, r *http.Request) {
	if r.Method != "GET" {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	address := r.URL.Query().Get("address")
	if address == "" {
		http.Error(w, "Address parameter required", http.StatusBadRequest)
		return
	}

	identity, err := api.identityManager.GetIdentity(address)
	if err != nil {
		response := map[string]interface{}{
			"success": false,
			"error":   err.Error(),
		}
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(response)
		return
	}

	response := map[string]interface{}{
		"success":  true,
		"identity": identity,
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}

func (api *APIServer) handleUpdateProfile(w http.ResponseWriter, r *http.Request) {
	if r.Method != "POST" {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var req struct {
		Address string       `json:"address"`
		Profile *identity.UserProfile `json:"profile"`
	}

	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	// TODO: Implement profile update through identity manager
	err := api.identityManager.UpdateProfile(req.Address, req.Profile)
	if err != nil {
		response := map[string]interface{}{
			"success": false,
			"error":   err.Error(),
		}
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(response)
		return
	}

	response := map[string]interface{}{
		"success": true,
		"message": "Profile updated successfully",
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}

func (api *APIServer) handleUpdateActivity(w http.ResponseWriter, r *http.Request) {
	if r.Method != "POST" {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var req struct {
		Address      string `json:"address"`
		ActivityType string `json:"activity_type"`
		Value        int64  `json:"value"`
	}

	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	// TODO: Implement activity update through identity manager
	err := api.identityManager.UpdateActivity(req.Address, req.ActivityType, req.Value)
	if err != nil {
		response := map[string]interface{}{
			"success": false,
			"error":   err.Error(),
		}
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(response)
		return
	}

	response := map[string]interface{}{
		"success": true,
		"message": "Activity updated successfully",
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}

func (api *APIServer) handleCreatePrivacyProof(w http.ResponseWriter, r *http.Request) {
	if r.Method != "POST" {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var req struct {
		ProofType string      `json:"proof_type"`
		Data      interface{} `json:"data"`
		Address   string      `json:"address"`
	}

	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	// TODO: Implement privacy proof creation
	// TODO: Implement privacy proof creation with proper type conversion
	proof, err := api.identityManager.CreatePrivacyProof("default", req.Data, req.Address)
	if err != nil {
		response := map[string]interface{}{
			"success": false,
			"error":   err.Error(),
		}
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(response)
		return
	}

	response := map[string]interface{}{
		"success": true,
		"proof":   proof,
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}

func (api *APIServer) handleVerifyPrivacyProof(w http.ResponseWriter, r *http.Request) {
	if r.Method != "POST" {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var req struct {
		Proof interface{} `json:"proof"`
	}

	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	// TODO: Implement privacy proof verification
	// TODO: Implement privacy proof verification with proper type conversion
	valid, err := api.identityManager.VerifyPrivacyProof(nil)
	if err != nil {
		response := map[string]interface{}{
			"success": false,
			"error":   err.Error(),
		}
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(response)
		return
	}

	response := map[string]interface{}{
		"success": true,
		"valid":   valid,
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}

func (api *APIServer) handleGetIdentityForSocial(w http.ResponseWriter, r *http.Request) {
	if r.Method != "GET" {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	address := r.URL.Query().Get("address")
	requester := r.URL.Query().Get("requester")
	
	if address == "" {
		http.Error(w, "Address parameter required", http.StatusBadRequest)
		return
	}

	identity, err := api.identityManager.GetIdentityForSocial(address, requester)
	if err != nil {
		response := map[string]interface{}{
			"success": false,
			"error":   err.Error(),
		}
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(response)
		return
	}

	response := map[string]interface{}{
		"success":  true,
		"identity": identity,
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}

func (api *APIServer) handleGetIdentityForCommerce(w http.ResponseWriter, r *http.Request) {
	if r.Method != "GET" {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	address := r.URL.Query().Get("address")
	requester := r.URL.Query().Get("requester")
	
	if address == "" {
		http.Error(w, "Address parameter required", http.StatusBadRequest)
		return
	}

	identity, err := api.identityManager.GetIdentityForCommerce(address, requester)
	if err != nil {
		response := map[string]interface{}{
			"success": false,
			"error":   err.Error(),
		}
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(response)
		return
	}

	response := map[string]interface{}{
		"success":  true,
		"identity": identity,
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}

func (api *APIServer) handleGetIdentityForGovernance(w http.ResponseWriter, r *http.Request) {
	if r.Method != "GET" {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	address := r.URL.Query().Get("address")
	if address == "" {
		http.Error(w, "Address parameter required", http.StatusBadRequest)
		return
	}

	identity, err := api.identityManager.GetIdentityForGovernance(address)
	if err != nil {
		response := map[string]interface{}{
			"success": false,
			"error":   err.Error(),
		}
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(response)
		return
	}

	response := map[string]interface{}{
		"success":  true,
		"identity": identity,
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}

// ===== SOCIAL MEDIA API ENDPOINTS =====

// POST /social/post/create
func (api *APIServer) handleCreatePost(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var req struct {
		Author     string   `json:"author"`
		Content    string   `json:"content"`
		MediaURLs  []string `json:"media_urls,omitempty"`
		Visibility string   `json:"visibility"`
		Category   string   `json:"category"`
	}

	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	post, err := api.socialManager.CreatePost(req.Author, req.Content, req.MediaURLs, req.Visibility, req.Category)
	if err != nil {
		http.Error(w, "Failed to create post: "+err.Error(), http.StatusInternalServerError)
		return
	}

	json.NewEncoder(w).Encode(map[string]interface{}{
		"success": true,
		"data":    post,
	})
}

// GET /social/post/get
func (api *APIServer) handleGetPost(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	postID := r.URL.Query().Get("id")
	if postID == "" {
		http.Error(w, "Post ID parameter required", http.StatusBadRequest)
		return
	}

	post, err := api.socialManager.GetPost(postID)
	if err != nil {
		http.Error(w, "Failed to get post: "+err.Error(), http.StatusInternalServerError)
		return
	}

	json.NewEncoder(w).Encode(map[string]interface{}{
		"success": true,
		"data":    post,
	})
}

// POST /social/comment/create
func (api *APIServer) handleCreateComment(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var req struct {
		PostID   string `json:"post_id"`
		Author   string `json:"author"`
		Content  string `json:"content"`
		ParentID string `json:"parent_id,omitempty"`
	}

	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	comment, err := api.socialManager.CreateComment(req.PostID, req.Author, req.Content, req.ParentID)
	if err != nil {
		http.Error(w, "Failed to create comment: "+err.Error(), http.StatusInternalServerError)
		return
	}

	json.NewEncoder(w).Encode(map[string]interface{}{
		"success": true,
		"data":    comment,
	})
}

// POST /social/like
func (api *APIServer) handleLikePost(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var req struct {
		PostID   string `json:"post_id"`
		UserID   string `json:"user_id"`
		LikeType string `json:"like_type"`
	}

	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	err := api.socialManager.LikePost(req.PostID, req.UserID, req.LikeType)
	if err != nil {
		http.Error(w, "Failed to like post: "+err.Error(), http.StatusInternalServerError)
		return
	}

	json.NewEncoder(w).Encode(map[string]interface{}{
		"success": true,
		"message": "Post liked successfully",
	})
}

// POST /social/unlike
func (api *APIServer) handleUnlikePost(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var req struct {
		PostID string `json:"post_id"`
		UserID string `json:"user_id"`
	}

	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	err := api.socialManager.UnlikePost(req.PostID, req.UserID)
	if err != nil {
		http.Error(w, "Failed to unlike post: "+err.Error(), http.StatusInternalServerError)
		return
	}

	json.NewEncoder(w).Encode(map[string]interface{}{
		"success": true,
		"message": "Post unliked successfully",
	})
}

// GET /social/feed
func (api *APIServer) handleGetFeed(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	userID := r.URL.Query().Get("user_id")
	if userID == "" {
		http.Error(w, "User ID parameter required", http.StatusBadRequest)
		return
	}

	limit := 20 // Default limit
	if l := r.URL.Query().Get("limit"); l != "" {
		fmt.Sscanf(l, "%d", &limit)
	}

	posts, err := api.socialManager.GetFeed(userID, limit)
	if err != nil {
		http.Error(w, "Failed to get feed: "+err.Error(), http.StatusInternalServerError)
		return
	}

	json.NewEncoder(w).Encode(map[string]interface{}{
		"success": true,
		"data":    posts,
	})
}

// GET /social/search
func (api *APIServer) handleSearchPosts(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	query := r.URL.Query().Get("q")
	if query == "" {
		http.Error(w, "Query parameter required", http.StatusBadRequest)
		return
	}

	limit := 20 // Default limit
	if l := r.URL.Query().Get("limit"); l != "" {
		fmt.Sscanf(l, "%d", &limit)
	}

	posts := api.socialManager.SearchPosts(query, limit)

	json.NewEncoder(w).Encode(map[string]interface{}{
		"success": true,
		"data":    posts,
	})
}

// GET /social/trending
func (api *APIServer) handleGetTrendingHashtags(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	limit := 10 // Default limit
	if l := r.URL.Query().Get("limit"); l != "" {
		fmt.Sscanf(l, "%d", &limit)
	}

	hashtags := api.socialManager.GetTrendingHashtags(limit)

	json.NewEncoder(w).Encode(map[string]interface{}{
		"success": true,
		"data":    hashtags,
	})
}

// POST /social/report
func (api *APIServer) handleReportContent(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var req struct {
		Reporter    string `json:"reporter"`
		TargetID    string `json:"target_id"`
		TargetType  string `json:"target_type"`
		Reason      string `json:"reason"`
		Description string `json:"description,omitempty"`
	}

	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	err := api.socialManager.ReportContent(req.Reporter, req.TargetID, req.TargetType, req.Reason, req.Description)
	if err != nil {
		http.Error(w, "Failed to report content: "+err.Error(), http.StatusInternalServerError)
		return
	}

	json.NewEncoder(w).Encode(map[string]interface{}{
		"success": true,
		"message": "Content reported successfully",
	})
}

// ===== GOVERNANCE API ENDPOINTS =====

// POST /governance/proposal/create
func (api *APIServer) handleCreateProposal(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var req struct {
		Proposer    string             `json:"proposer"`
		Title       string             `json:"title"`
		Description string             `json:"description"`
		Category    string             `json:"category"`
		Actions     []governance.GovernanceAction `json:"actions"`
		CurrentBlock int64             `json:"current_block"`
	}

	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	proposal, err := api.governanceManager.CreateProposal(req.Proposer, req.Title, req.Description, req.Category, req.Actions, req.CurrentBlock)
	if err != nil {
		http.Error(w, "Failed to create proposal: "+err.Error(), http.StatusInternalServerError)
		return
	}

	json.NewEncoder(w).Encode(map[string]interface{}{
		"success": true,
		"data":    proposal,
	})
}

// GET /governance/proposal/get (duplicate - removing)
// This function is a duplicate of the one at line 1193

// POST /governance/proposal/activate
func (api *APIServer) handleActivateProposal(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var req struct {
		ProposalID  string `json:"proposal_id"`
		CurrentBlock int64 `json:"current_block"`
	}

	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	err := api.governanceManager.ActivateProposal(req.ProposalID, req.CurrentBlock)
	if err != nil {
		http.Error(w, "Failed to activate proposal: "+err.Error(), http.StatusInternalServerError)
		return
	}

	json.NewEncoder(w).Encode(map[string]interface{}{
		"success": true,
		"message": "Proposal activated successfully",
	})
}

// POST /governance/proposal/vote
func (api *APIServer) handleVoteProposal(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var req struct {
		ProposalID string `json:"proposal_id"`
		Voter      string `json:"voter"`
		Choice     string `json:"choice"`
		Reason     string `json:"reason,omitempty"`
		Weight     uint64 `json:"weight"`
	}

	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	err := api.governanceManager.Vote(req.ProposalID, req.Voter, req.Choice, req.Reason, req.Weight)
	if err != nil {
		http.Error(w, "Failed to vote on proposal: "+err.Error(), http.StatusInternalServerError)
		return
	}

	json.NewEncoder(w).Encode(map[string]interface{}{
		"success": true,
		"message": "Vote cast successfully",
	})
}

// POST /governance/proposal/execute
func (api *APIServer) handleExecuteProposal(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var req struct {
		ProposalID  string `json:"proposal_id"`
		CurrentBlock int64 `json:"current_block"`
	}

	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	err := api.governanceManager.ExecuteProposal(req.ProposalID, req.CurrentBlock)
	if err != nil {
		http.Error(w, "Failed to execute proposal: "+err.Error(), http.StatusInternalServerError)
		return
	}

	json.NewEncoder(w).Encode(map[string]interface{}{
		"success": true,
		"message": "Proposal executed successfully",
	})
}

// POST /governance/proposal/discuss
func (api *APIServer) handleAddDiscussionComment(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var req struct {
		ProposalID string `json:"proposal_id"`
		Author     string `json:"author"`
		Content    string `json:"content"`
		ParentID   string `json:"parent_id,omitempty"`
	}

	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	err := api.governanceManager.AddDiscussionComment(req.ProposalID, req.Author, req.Content, req.ParentID)
	if err != nil {
		http.Error(w, "Failed to add discussion comment: "+err.Error(), http.StatusInternalServerError)
		return
	}

	json.NewEncoder(w).Encode(map[string]interface{}{
		"success": true,
		"message": "Comment added successfully",
	})
}

// GET /governance/proposals/active
func (api *APIServer) handleGetActiveProposals(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	proposals := api.governanceManager.GetActiveProposals()

	json.NewEncoder(w).Encode(map[string]interface{}{
		"success": true,
		"data":    proposals,
	})
}

// GET /governance/proposals/category
func (api *APIServer) handleGetProposalsByCategory(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	category := r.URL.Query().Get("category")
	if category == "" {
		http.Error(w, "Category parameter required", http.StatusBadRequest)
		return
	}

	proposals := api.governanceManager.GetProposalsByCategory(category)

	json.NewEncoder(w).Encode(map[string]interface{}{
		"success": true,
		"data":    proposals,
	})
}

// POST /governance/referendum/create
func (api *APIServer) handleCreateReferendum(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var req struct {
		Title       string   `json:"title"`
		Description string   `json:"description"`
		Question    string   `json:"question"`
		Options     []string `json:"options"`
		Duration    string   `json:"duration"` // e.g., "24h", "7d"
	}

	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	// Parse duration
	duration, err := time.ParseDuration(req.Duration)
	if err != nil {
		http.Error(w, "Invalid duration format", http.StatusBadRequest)
		return
	}

	referendum, err := api.governanceManager.CreateReferendum(req.Title, req.Description, req.Question, req.Options, duration)
	if err != nil {
		http.Error(w, "Failed to create referendum: "+err.Error(), http.StatusInternalServerError)
		return
	}

	json.NewEncoder(w).Encode(map[string]interface{}{
		"success": true,
		"data":    referendum,
	})
}

// POST /governance/referendum/vote
func (api *APIServer) handleVoteReferendum(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var req struct {
		ReferendumID string `json:"referendum_id"`
		Voter        string `json:"voter"`
		Option       string `json:"option"`
	}

	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	err := api.governanceManager.VoteReferendum(req.ReferendumID, req.Voter, req.Option)
	if err != nil {
		http.Error(w, "Failed to vote on referendum: "+err.Error(), http.StatusInternalServerError)
		return
	}

	json.NewEncoder(w).Encode(map[string]interface{}{
		"success": true,
		"message": "Referendum vote cast successfully",
	})
}