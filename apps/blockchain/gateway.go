package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"time"
	"github.com/gorilla/mux"
	"github.com/gorilla/handlers"
	"atlas-blockchain/core/pkg/blockchain"
)

// APIGateway handles routing and rate limiting for Flutter clients
type APIGateway struct {
	router       *mux.Router
	blockManager *blockchain.BlockManager
	rateLimiter  map[string]*RateLimitBucket
}

// RateLimitBucket for simple rate limiting
type RateLimitBucket struct {
	tokens int
	last   time.Time
}

func NewAPIGateway(bm *blockchain.BlockManager) *APIGateway {
	gateway := &APIGateway{
		router:       mux.NewRouter(),
		blockManager: bm,
		rateLimiter:  make(map[string]*RateLimitBucket),
	}
	gateway.setupRoutes()
	return gateway
}

func (g *APIGateway) setupRoutes() {
	g.router.HandleFunc("/balance/{address}", g.handleBalance).Methods("GET")
	g.router.HandleFunc("/transactions/{address}", g.handleTransactions).Methods("GET")
	g.router.HandleFunc("/submit-transaction", g.handleSubmitTransaction).Methods("POST")
	g.router.Use(g.rateLimitMiddleware)
	g.router.Use(g.corsMiddleware)
}

func (g *APIGateway) rateLimitMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		clientIP := r.RemoteAddr
		bucket := g.rateLimiter[clientIP]
		if bucket == nil {
			bucket = &RateLimitBucket{tokens: 10, last: time.Now()}
			g.rateLimiter[clientIP] = bucket
		}
		if bucket.tokens > 0 {
			bucket.tokens--
			next.ServeHTTP(w, r)
		} else {
			http.Error(w, "Rate limit exceeded", http.StatusTooManyRequests)
		}
	})
}

func (g *APIGateway) corsMiddleware(next http.Handler) http.Handler {
	return handlers.CORS(
		handlers.AllowedOrigins([]string{"*"}),
		handlers.AllowedMethods([]string{"GET", "POST", "OPTIONS"}),
		handlers.AllowedHeaders([]string{"Content-Type", "Authorization"}),
	)(next)
}

func (g *APIGateway) handleBalance(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	address := vars["address"]

	balance := g.blockManager.state.GetBalance(address)
	response := map[string]interface{}{
		"address": address,
		"balance": balance,
		"timestamp": time.Now().Unix(),
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}

func (g *APIGateway) handleTransactions(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	address := vars["address"]

	// Simplified: return mock transactions
	transactions := []map[string]interface{}{
		{"hash": "tx1", "amount": 10.0, "timestamp": time.Now().Unix()},
	}

	response := map[string]interface{}{
		"address": address,
		"transactions": transactions,
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}

func (g *APIGateway) handleSubmitTransaction(w http.ResponseWriter, r *http.Request) {
	var tx map[string]interface{}
	json.NewDecoder(r.Body).Decode(&tx)

	// Simplified: simulate transaction submission
	response := map[string]interface{}{
		"hash": "tx_${time.Now().Unix()}",
		"status": "submitted",
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}

func (g *APIGateway) Start(port string) {
	log.Printf("Starting API Gateway on port %s", port)
	log.Fatal(http.ListenAndServe(":"+port, g.router))
}
