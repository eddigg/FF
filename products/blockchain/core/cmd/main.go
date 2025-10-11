package main

import (
	"context"
	"flag"
	"fmt"
	"log"
	"os"
	"os/signal"
	"syscall"
	"time"
	"atlas-blockchain/pkg/wallet"
	"atlas-blockchain/pkg/block"
	"atlas-blockchain/pkg/transaction"
	"atlas-blockchain/pkg/network"
	"atlas-blockchain/pkg/config"
	"atlas-blockchain/internal/blockchain"
	"atlas-blockchain/internal/identity"
	"atlas-blockchain/internal/defi"
	"atlas-blockchain/internal/social"
	"atlas-blockchain/internal/governance"
	"atlas-blockchain/internal/api"
	"encoding/json"
	"github.com/libp2p/go-libp2p/core/peer"
)

var (
	blockchainConfig   *config.BlockchainConfig
	node               *network.Node
	transactionManager *blockchain.TransactionManager
	blockManager       *blockchain.BlockManager
	consensusManager   *blockchain.ConsensusManager
	stateManager       *blockchain.StateManager
	chainSyncManager   *blockchain.ChainSyncManager
	identityManager    *identity.IdentityManager
	defiManager        *defi.DeFiManager
	socialManager      *social.SocialManager
	governanceManager  *governance.GovernanceManager
	validatorMode      *bool
	p2pNode            *network.P2PNode // Add P2P node
	isTestMode         bool             // Flag to indicate if we're running in test mode
)

// SetTestMode sets the test mode flag
func SetTestMode(enabled bool) {
	isTestMode = enabled
}

func main() {
	// Parse command line flags early
	port := flag.Int("port", 8000, "Port for peer discovery")
	maxPeers := flag.Int("peers", 10, "Maximum number of peers")
	apiPort := flag.Int("api", 8080, "Port for API server")
	validatorMode = flag.Bool("validator", false, "Run node as validator (with wallet)")
	keyPath := flag.String("key", "nodekey.priv", "Path to private key file for libp2p identity")
	legacyNetworking := flag.Bool("legacy-net", false, "Enable legacy TCP networking") // NEW FLAG
	testMode := flag.Bool("test", false, "Run in test mode (disable infinite loops)")
	flag.Parse()
	
	// Set test mode flag
	isTestMode = *testMode

	blockchainConfig = config.DefaultConfig()
	blockchainConfig.PeerDiscoveryPort = *port
	blockchainConfig.MaxPeers = *maxPeers

	stateManager = blockchain.NewStateManager(blockchainConfig)
	
	// Migrate existing JSON snapshots to database if available
	if err := stateManager.MigrateToDatabase(); err != nil {
		log.Printf("⚠️  Database migration failed: %v", err)
	}
	
	transactionManager = blockchain.NewTransactionManager(blockchainConfig, stateManager)
	blockManager = blockchain.NewBlockManager(blockchainConfig, stateManager)
	consensusManager = blockchain.NewConsensusManager(blockchainConfig, blockManager)
	stateManager.SetConsensusManager(consensusManager)
	
	// Initialize identity manager for social-commerce-governance platform
	identityManager = identity.NewIdentityManager()
	
	// Initialize DeFi manager for lending, trading, staking, and governance
	defiManager = defi.NewDeFiManager(identityManager)
	
	// Initialize social media manager for posts, comments, and content moderation
	socialManager = social.NewSocialManager(identityManager)
	
	// Initialize governance manager for proposals, voting, and community governance
	governanceManager = governance.NewGovernanceManager(socialManager, defiManager, identityManager)

	ctx := context.Background()
	p2pNode, err := network.NewP2PNode(ctx, blockchainConfig.PeerDiscoveryPort, *keyPath)
	if err != nil {
		log.Fatalf("Failed to start P2P node: %v", err)
	}

	// Initialize chain synchronization manager
	chainSyncManager = blockchain.NewChainSyncManager(blockManager, stateManager, p2pNode, blockchainConfig)
	chainSyncManager.SetCallbacks(
		func() { log.Printf("🔄 [SYNC] Chain synchronization started") },
		func(blocksSynced, totalBlocks int64) { 
			log.Printf("📊 [SYNC] Progress: %d/%d blocks", blocksSynced, totalBlocks) 
		},
		func() { log.Printf("✅ [SYNC] Chain synchronization completed") },
		func(err error) { log.Printf("❌ [SYNC] Chain synchronization failed: %v", err) },
		func(forkHeight int64, canonical, forked []string) { 
			log.Printf("🔄 [SYNC] Fork detected at height %d", forkHeight) 
		},
	)
	if err != nil {
		log.Fatalf("Failed to start P2P node: %v", err)
	}

	// Enhanced debug: log all multiaddresses and peerstore contents
	log.Printf("[DEBUG] Our Peer ID: %s", p2pNode.Host.ID().String())
	for _, addr := range p2pNode.Host.Addrs() {
		log.Printf("[DEBUG] Listening on multiaddress: %s", addr.String())
	}
	log.Printf("[DEBUG] Peerstore peers at startup: %v", p2pNode.Host.Peerstore().Peers())

	// Improved: Always attempt manual connection if NODE1_MULTIADDR is set
		addrStr := os.Getenv("NODE1_MULTIADDR")
	if addrStr != "" {
		log.Printf("[P2P] Attempting manual connection to: %s", addrStr)
		info, err := peer.AddrInfoFromString(addrStr)
		if err == nil {
			log.Printf("[DEBUG] Peerstore before connect: %v", p2pNode.Host.Peerstore().Peers())
			if err := p2pNode.Host.Connect(ctx, *info); err != nil {
				log.Printf("[P2P] Failed to connect to peer: %v (%T)", err, err)
			} else {
				log.Printf("[P2P] Successfully connected to peer: %s", info.ID.String())
			}
			log.Printf("[DEBUG] Peerstore after connect: %v", p2pNode.Host.Peerstore().Peers())
		} else {
			log.Printf("[P2P] Invalid multiaddress: %v", err)
		}
	}

	// Assign block and transaction processing callbacks
	p2pNode.OnBlockReceived = func(blockMsg network.BlockMessage) {
		var blk block.Block
		if err := json.Unmarshal(blockMsg.BlockData, &blk); err != nil {
			log.Printf("[P2P] Failed to unmarshal received block: %v", err)
			return
		}
		if err := blockManager.AddBlock(&blk); err != nil {
			log.Printf("[P2P] Failed to add received block: %v", err)
		} else {
			log.Printf("[P2P] Received and added new block: %d", blk.Index)
		}
	}
	p2pNode.OnTransactionReceived = func(txMsg network.TransactionMessage) {
		var tx transaction.Transaction
		if err := json.Unmarshal(txMsg.TxData, &tx); err != nil {
			log.Printf("[P2P] Failed to unmarshal received transaction: %v", err)
			return
		}
		if err := transactionManager.AddTransaction(tx); err != nil {
			log.Printf("[P2P] Failed to add received transaction: %v", err)
		} else {
			log.Printf("[P2P] Received and added new transaction from %s", tx.Sender)
		}
	}
	p2pNode.RegisterStreamHandler()

	// Broadcast new blocks to peers when added
	blockManager.SetOnBlockAddedCallback(func(blk *block.Block) {
		data, err := json.Marshal(blk)
		if err != nil {
			log.Printf("[P2P] Failed to marshal block for broadcast: %v", err)
			return
		}
		netMsg := network.NetworkMessage{Type: network.MsgTypeBlock, Payload: data}
		for _, peer := range p2pNode.Host.Peerstore().Peers() {
			if peer == p2pNode.Host.ID() {
				continue // Don't send to self
			}
			if err := p2pNode.SendMessage(context.Background(), peer, netMsg); err != nil {
				log.Printf("[P2P] Failed to broadcast block to peer %s: %v", peer.String(), err)
			}
		}
	})

	// Example: Broadcast new transactions (if you have an event/callback for new transactions)
	// transactionManager.OnNewTransaction = func(tx transaction.Transaction) {
	// 	data, err := json.Marshal(tx)
	// 	if err != nil {
	// 		log.Printf("[P2P] Failed to marshal transaction for broadcast: %v", err)
	// 		return
	// 	}
	// 	msg := network.TransactionMessage{TxData: data}
	// 	netMsg := network.NetworkMessage{Type: network.MsgTypeTransaction, Payload: data}
	// 	for _, peer := range p2pNode.Host.Peerstore().Peers() {
	// 		if peer == p2pNode.Host.ID() {
	// 			continue // Don't send to self
	// 		}
	// 		if err := p2pNode.SendMessage(context.Background(), peer, netMsg); err != nil {
	// 			log.Printf("[P2P] Failed to broadcast transaction to peer %s: %v", peer.String(), err)
	// 		}
	// 	}
	// }

	// DebugTxFlow()
	// panic("[DEBUG] DebugTxFlow complete - halting execution for inspection.")
	// Initialize configuration
	if err := blockchainConfig.Validate(); err != nil {
		log.Fatalf("Invalid configuration: %v", err)
	}

	// Create and initialize node
	node = network.NewNode(fmt.Sprintf("localhost:%d", *port), "testtoken")
	if *validatorMode {
		if err := initializeNode(); err != nil {
			log.Fatalf("Failed to initialize node: %v", err)
		}
	} else {
		node.Wallet = nil
		node.ValidatorAddress = ""
		// Node runs as observer/relay
	}

	// Set up wallet synchronization callback
	blockManager.SetOnBlockAddedCallback(func(block *block.Block) {
		// Synchronize wallet balance with state manager after each block
		if node.Wallet != nil {
			stateManager.SyncWalletBalance(node.Wallet)
		}
	})

	// After successful registration as validator (in initializeNode or main)
	if *validatorMode {
		// Broadcast validator registration to peers
		regMsg := network.ValidatorRegistrationMessage{
			Address: node.ValidatorAddress,
			Stake:   uint64(blockchainConfig.MinStake * 2), // or actual stake
		}
		payload, _ := json.Marshal(regMsg)
		netMsg := network.NetworkMessage{Type: network.MsgTypeValidatorRegistration, Payload: payload}
		for _, peer := range p2pNode.Host.Peerstore().Peers() {
			if peer == p2pNode.Host.ID() {
				continue
			}
			log.Printf("[P2P] Broadcasting validator registration to peer: %s", peer.String())
			_ = p2pNode.SendMessage(context.Background(), peer, netMsg)
		}
	}

	// Handle incoming validator registration messages
	p2pNode.OnValidatorRegistrationReceived = func(reg network.ValidatorRegistrationMessage) {
		log.Printf("[P2P] Received validator registration: %s", reg.Address)
		if consensusManager != nil {
			consensusManager.AddExternalValidator(reg.Address, reg.Stake)
			log.Printf("[P2P] Registered external validator: %s", reg.Address)
		}
	}

	// Start API server
	apiServer := api.NewAPIServer(blockManager, transactionManager, stateManager, consensusManager, node, identityManager, socialManager, governanceManager)
	
	// TODO: Set up monitoring integration callbacks when monitor field is exported
	// Set up monitoring integration callbacks
	// if apiServer.monitor != nil {
	// 	apiServer.monitor.SetIntegrationCallbacks(
	// 		// Get transaction count
	// 		func() int {
	// 			return transactionManager.GetPoolSize()
	// 		},
	// 		// Get block height
	// 		func() int64 {
	// 			return int64(blockManager.GetBlockHeight())
	// 		},
	// 		// Get pending transactions
	// 		func() int {
	// 			return transactionManager.GetPoolSize()
	// 		},
	// 		// Get validator count
	// 		func() int {
	// 			return len(consensusManager.GetAllValidators())
	// 		},
	// 		// Get active peers
	// 		func() int {
	// 			return len(p2pNode.Host.Peerstore().Peers())
	// 		},
	// 		// Get total staked
	// 		func() float64 {
	// 			total := 0.0
	// 			for _, validator := range consensusManager.GetAllValidators() {
	// 				total += float64(validator.Stake)
	// 			}
	// 			return total
	// 		},
	// 		// Get last block hash
	// 		func() string {
	// 			if height := blockManager.GetBlockHeight(); height > 0 {
	// 				if lastBlock, err := blockManager.GetBlockByIndex(height - 1); err == nil {
	// 					return lastBlock.Hash
	// 				}
	// 			}
	// 			return ""
	// 		},
	// 		// Get contract count
	// 		func() int {
	// 			// This would integrate with the VM system
	// 			return 0 // Placeholder for now
	// 		},
	// 		// Get sync status
	// 		func() string {
	// 			if chainSyncManager != nil {
	// 				return string(chainSyncManager.GetStatus())
	// 			}
	// 			return "unknown"
	// 		},
	// 	)
	// }
	
	go apiServer.Start(fmt.Sprintf(":%d", *apiPort))

	// Start blockchain operations
	go startBlockchain(*legacyNetworking)
	
	// Start backup system
	if stateManager != nil {
		stateManager.StartBackupSystem()
	}

	// Handle graceful shutdown
	sigChan := make(chan os.Signal, 1)
	signal.Notify(sigChan, syscall.SIGINT, syscall.SIGTERM)
	<-sigChan
	shutdown()
}

func initializeNode() error {
	// Initialize wallet for the node
	walletObj, err := wallet.NewWallet()
	if err != nil {
		return fmt.Errorf("failed to create wallet: %v", err)
	}

	// Add initial balance to the node's wallet
	walletObj.SetBalance(int64(blockchainConfig.MinStake * 2))

	// Register node as validator using wallet
	kyc := blockchain.KYCInfo{
		FullName:   "Node Validator",
		Country:    "Test Country",
		IDNumber:   "NODE001",
		Verified:   true,
	}
	if err := consensusManager.RegisterValidator(walletObj, uint64(blockchainConfig.MinStake*2), kyc); err != nil {
		return fmt.Errorf("failed to register as validator: %v", err)
	}

	// Store wallet in node for future use
	node.Wallet = walletObj
	node.ValidatorAddress = walletObj.PublicKeyStr()

	// Initialize local blockchain
	// Note: LocalBlockchain field access removed as it's unexported

	return nil
}

func startBlockchain(legacyNetworking bool) {
	// Don't start infinite loops if in test mode
	if isTestMode {
		log.Printf("🧪 Test mode enabled - skipping infinite loops")
		return
	}
	
	// Start block production
	go produceBlocks()

	// Start peer discovery (legacy TCP networking) ONLY if enabled
	if legacyNetworking {
	go discoverPeers()
	}

	// Start transaction processing
	go processTransactions()

	// Start transaction pool maintenance
	go maintainTransactionPool()

	// Start validator monitoring
	go monitorValidators()

	// Start transaction pool synchronization
	node.StartTransactionPoolSync()
	
	// Start chain synchronization
	go startChainSync()
}

func produceBlocks() {
	log.Printf("🚀 Starting block production loop with interval: %v", blockchainConfig.BlockTime)
	ticker := time.NewTicker(blockchainConfig.BlockTime)
	defer ticker.Stop()

	blockCount := 0
	for {
		select {
		case <-ticker.C:
			blockCount++
			log.Printf("⏰ Block production tick #%d - Current time: %s", blockCount, time.Now().Format("15:04:05"))
			
			// Check if we are the chosen validator
			log.Printf("🔍 Attempting to choose validator...")
			validator, err := consensusManager.ChooseValidator()
			if err != nil {
				log.Printf("❌ Failed to choose validator: %v", err)
				continue
			}
			log.Printf("✅ Chosen validator: %s (Our address: %s)", validator.Address, node.ValidatorAddress)

			// If we are the validator, forge a new block
			if validator.Address == node.ValidatorAddress {
				log.Printf("🎯 We are the chosen validator! Attempting to forge block...")
				currentHeight := blockManager.GetBlockHeight()
				log.Printf("📊 Current blockchain height: %d", currentHeight)
				
				if err := forgeAndBroadcastBlock(); err != nil {
					log.Printf("❌ Failed to forge block: %v", err)
					// Slash validator for failed block production
					if err := consensusManager.SlashValidator(node.ValidatorAddress, "failed block production"); err != nil {
						log.Printf("❌ Failed to slash validator: %v", err)
					}
				} else {
					log.Printf("✅ Successfully forged and broadcasted block!")
				}
			} else {
				log.Printf("⏳ Not our turn to forge. Waiting for next tick...")
			}
			
			log.Printf("🔄 Block production tick #%d completed, waiting for next tick...", blockCount)
		}
	}
}

func monitorValidators() {
	ticker := time.NewTicker(time.Minute)
	defer ticker.Stop()

	for {
		select {
		case <-ticker.C:
			// Get all validators
			validators := consensusManager.GetAllValidators()

			// Log validator status
			for _, v := range validators {
				log.Printf("Validator %s: Stake=%d, Active=%v, SlashCount=%d",
					v.Address, v.Stake, v.Active, v.SlashCount)
			}
		}
	}
}

func forgeAndBroadcastBlock() error {
	log.Printf("🔨 Starting block forging process...")
	// Enable block forging using consensus logic
	validatorWallet := node.Wallet
	lastBlock := blockManager.GetLatestBlock()
	newBlock, err := blockchain.ForgeBlock(validatorWallet, lastBlock, stateManager, transactionManager, consensusManager)
	if err != nil {
		log.Printf("❌ forgeBlock failed: %v", err)
		return fmt.Errorf("failed to forge block: %v", err)
	}
	log.Printf("✅ Block forged successfully: Index=%d, Hash=%s", newBlock.Index, newBlock.Hash[:16]+"...")

	// Broadcast the new block to peers (if P2P is enabled)
	if p2pNode != nil {
		blockData, err := json.Marshal(newBlock)
		if err == nil {
			p2pNode.BroadcastBlock(context.Background(), blockData)
			log.Printf("📡 Broadcasted new block to peers.")
		} else {
			log.Printf("[P2P] Failed to marshal block for broadcast: %v", err)
		}
	}

	// Reward the validator
	consensusManager.RewardValidator(node.ValidatorAddress, 100) // TODO: Define BLOCK_REWARD constant
	return nil
}

func processTransactions() {
	for {
		// TODO: Process transactions when node fields are exported
		// Process any new transactions in the node's pool
		// node.mu.RLock()
		// for _, tx := range node.LocalTxPool {
		// 	if err := transactionManager.AddTransaction(tx); err != nil {
		// 		log.Printf("Failed to add transaction to manager: %v", err)
		// 	}
		// }
		// node.mu.RUnlock()

		// Clear the node's pool after processing
		// node.mu.Lock()
		// node.LocalTxPool = nil
		// node.mu.Unlock()

		time.Sleep(time.Second)
	}
}

func maintainTransactionPool() {
	ticker := time.NewTicker(time.Minute)
	defer ticker.Stop()

	for {
		select {
		case <-ticker.C:
			// Remove expired transactions
			transactionManager.RemoveExpiredTransactions()

			// Log pool status
			log.Printf("Transaction pool size: %d", transactionManager.GetPoolSize())
		}
	}
}

func discoverPeers() {
	// TODO: Start network services when startNetwork method is exported
	// Start network services
	// if err := node.startNetwork(); err != nil {
	// 	log.Printf("Failed to start network: %v", err)
	// }
}

func shutdown() {
	log.Println("Shutting down blockchain node...")
	// Save final state
	log.Printf("Final blockchain length: %d", blockManager.GetChainLength())
	log.Printf("Final transaction pool size: %d", transactionManager.GetPoolSize())
	
	// Stop backup system
	if stateManager != nil {
		stateManager.StopBackupSystem()
		log.Println("Backup system stopped")
	}
	
	// Close database connection
	if err := stateManager.CloseDatabase(); err != nil {
		log.Printf("Failed to close database: %v", err)
	} else {
		log.Println("Database connection closed")
	}
	
	// Persist state (fallback to JSON)
	err := stateManager.ExportState("final_state.json")
	if err != nil {
		log.Printf("Failed to export state: %v", err)
	} else {
		log.Println("State exported to final_state.json")
	}
}

// startChainSync initiates chain synchronization
func startChainSync() {
	log.Printf("🔄 Starting chain synchronization...")
	
	// Wait a bit for the network to stabilize
	time.Sleep(5 * time.Second)
	
	ctx := context.Background()
	err := chainSyncManager.StartSync(ctx)
	if err != nil {
		log.Printf("❌ Failed to start chain synchronization: %v", err)
		return
	}
	
	// Monitor sync status
	ticker := time.NewTicker(30 * time.Second)
	defer ticker.Stop()
	
	for {
		select {
		case <-ticker.C:
			status := chainSyncManager.GetStatus()
			blocksSynced, totalBlocks := chainSyncManager.GetSyncProgress()
			duration := chainSyncManager.GetSyncDuration()
			
			log.Printf("📊 [SYNC] Status: %s, Progress: %d/%d, Duration: %v", 
				status, blocksSynced, totalBlocks, duration)
			
			// TODO: Check sync status when constants are defined
			if status == "complete" || status == "failed" {
				log.Printf("🔄 [SYNC] Chain synchronization finished with status: %s", status)
				return
			}
		}
	}
}

func DebugTxFlow() {
	fmt.Println("[DEBUG] DebugTxFlow started")
	fmt.Println("[DEBUG] Creating wallet A...")
	walletA, err := wallet.NewWallet()
	if err != nil {
		fmt.Printf("Failed to create wallet A: %v\n", err)
		return
	}
	fmt.Println("[DEBUG] Creating wallet B...")
	walletB, err := wallet.NewWallet()
	if err != nil {
		fmt.Printf("Failed to create wallet B: %v\n", err)
		return
	}
	fmt.Println("[DEBUG] Setting initial balance for wallet A...")
	stateManager.SetBalance(walletA.PublicKeyStr(), 1000)
	absPath := "C:/Users/Cesar Perez/Desktop/BLOCKCHAIN-090725/debug_output.txt"
	fmt.Printf("[DEBUG] Attempting to open %s...\n", absPath)
	debugFile, errDebug := os.OpenFile(absPath, os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
	if errDebug != nil {
		fmt.Fprintf(os.Stderr, "[DEBUG ERROR] Could not open debug_output.txt: %v\n", errDebug)
	} else {
		fmt.Println("[DEBUG] Writing initial balances to debug_output.txt...")
		fmt.Fprintf(debugFile, "[DEBUG] Initial balance A: %d\n", stateManager.GetBalance(walletA.PublicKeyStr()))
		fmt.Fprintf(debugFile, "[DEBUG] Initial balance B: %d\n", stateManager.GetBalance(walletB.PublicKeyStr()))
	}
	fmt.Println("[DEBUG] Creating transaction...")
	tx := transaction.Transaction{
		Sender:    walletA.PublicKeyStr(),
		Recipient: walletB.PublicKeyStr(),
		Amount:    100,
		Fee:       1,
		Timestamp: 0,
		Nonce:     0,
		Data:      "test transfer",
	}
	fmt.Println("[DEBUG] Signing transaction...")
	err = walletA.SignTransaction(&tx)
	if err != nil {
		if errDebug == nil { debugFile.Close() }
		fmt.Printf("Failed to sign transaction: %v\n", err)
		return
	}
	fmt.Println("[DEBUG] Adding transaction to manager...")
	err = transactionManager.AddTransaction(tx)
	fmt.Println("[DEBUG] Finished AddTransaction call.")
	if err != nil {
		if errDebug == nil { debugFile.Close() }
		fmt.Printf("Failed to add transaction: %v\n", err)
		return
	}
	fmt.Println("[DEBUG] Creating block with transaction...")
	transactions := transactionManager.GetTransactionsForBlock()
	lastBlock := blockManager.GetLatestBlock()
	blockObj, err := block.CreateNewBlock(transactions, lastBlock, walletA)
	if err != nil {
		if errDebug == nil { debugFile.Close() }
		fmt.Printf("Failed to create block: %v\n", err)
		return
	}
	if errDebug == nil {
		fmt.Println("[DEBUG] Writing block validator to debug_output.txt...")
		fmt.Fprintf(debugFile, "[DEBUG] Block validator: %s\n", blockObj.Validator)
	}
	fmt.Println("[DEBUG] Adding block to chain...")
	err = blockManager.AddBlock(blockObj)
	if err != nil {
		if errDebug == nil { debugFile.Close() }
		fmt.Printf("Failed to add block: %v\n", err)
		return
	}
	if errDebug == nil {
		fmt.Println("[DEBUG] Writing post-tx balances to debug_output.txt...")
		fmt.Fprintf(debugFile, "[DEBUG] Post-tx balance A: %d\n", stateManager.GetBalance(walletA.PublicKeyStr()))
		fmt.Fprintf(debugFile, "[DEBUG] Post-tx balance B: %d\n", stateManager.GetBalance(walletB.PublicKeyStr()))
		debugFile.Close()
	}
	fmt.Println("[DEBUG] Printing balances to stdout...")
	fmt.Printf("[DEBUG] Initial balance A: %d\n", stateManager.GetBalance(walletA.PublicKeyStr()))
	fmt.Printf("[DEBUG] Initial balance B: %d\n", stateManager.GetBalance(walletB.PublicKeyStr()))
	fmt.Printf("[DEBUG] Block validator: %s\n", blockObj.Validator)
	fmt.Printf("[DEBUG] Post-tx balance A: %d\n", stateManager.GetBalance(walletA.PublicKeyStr()))
	fmt.Printf("[DEBUG] Post-tx balance B: %d\n", stateManager.GetBalance(walletB.PublicKeyStr()))
	fmt.Println("[DEBUG] DebugTxFlow finished")
}
