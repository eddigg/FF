package main

import (
	"log"
	"atlas-blockchain/internal/blockchain"
	"atlas-blockchain/products/blockchain/api"
)

func main() {
	// Initialize blockchain manager (simplified for demo)
	blockManager := blockchain.NewBlockManager()

	gateway := api.NewAPIGateway(blockManager)
	gateway.Start("8080")
}
