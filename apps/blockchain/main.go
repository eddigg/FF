package main

import (
	"atlas-blockchain/core/pkg/blockchain"
	"atlas-blockchain/core/pkg/config"
	_ "github.com/mattn/go-sqlite3"
)

func main() {
	// Initialize blockchain configuration
	config := config.DefaultConfig()

	// Initialize state manager
	stateManager := blockchain.NewStateManager(config)

	// Initialize blockchain manager with proper parameters
	blockManager := blockchain.NewBlockManager(config, stateManager)

	gateway := NewAPIGateway(blockManager)
	gateway.Start("8080")
}
