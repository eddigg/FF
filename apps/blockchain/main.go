package main

import (
	"log"
	"atlas-blockchain/core/pkg/blockchain"
)

func main() {
	// Initialize blockchain manager (simplified for demo)
	blockManager := blockchain.NewBlockManager()

	gateway := NewAPIGateway(blockManager)
	gateway.Start("8080")
}
