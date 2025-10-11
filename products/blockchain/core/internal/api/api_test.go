
package api

import (
    "encoding/json"
    "net/http"
    "net/http/httptest"
    "testing"
    "atlas-blockchain/internal/blockchain"
    "atlas-blockchain/pkg/network"
    "atlas-blockchain/internal/identity"
    "atlas-blockchain/internal/social"
    "atlas-blockchain/internal/governance"
)

// MockBlockManager is a mock implementation of the BlockManager.
type MockBlockManager struct{}

func (m *MockBlockManager) GetBlockHeight() uint64 {
    return 12345
}
func (m *MockBlockManager) GetBlocks(limit, offset int) []*blockchain.Block { return nil }
func (m *MockBlockManager) GetBlockByHash(hash string) *blockchain.Block    { return nil }

// MockTransactionManager is a mock implementation of the TransactionManager.
type MockTransactionManager struct{}

func (m *MockTransactionManager) GetPoolSize() int                               { return 42 }
func (m *MockTransactionManager) AddTransaction(tx blockchain.Transaction) error { return nil }
func (m *MockTransactionManager) GetTransactionByHash(hash string) *blockchain.Transaction {
    return nil
}
func (m *MockTransactionManager) GetAllTransactions() []blockchain.Transaction { return nil }


// MockConsensusManager is a mock implementation of the ConsensusManager.
type MockConsensusManager struct{}

func (m *MockConsensusManager) GetAllValidators() []*blockchain.Validator {
    return make([]*blockchain.Validator, 10)
}
func (m *MockConsensusManager) GetValidatorInfo(address string) (*blockchain.Validator, error) {
    return &blockchain.Validator{Address: address, Stake: 1000}, nil
}

// MockNode is a mock implementation of the Node.
type MockNode struct {
    ValidatorAddress string
}

func TestHandleGetStatus(t *testing.T) {
    // 1. Setup
    mockBM := &MockBlockManager{}
    mockTM := &MockTransactionManager{}
    mockCM := &MockConsensusManager{}
    mockNode := &network.Node{ValidatorAddress: "mock_validator_address"}
    // Identity, Social, and Governance managers can be nil for this specific test
    // if they are not directly used in handleGetStatus.
    var mockIM *identity.IdentityManager
    var mockSM *social.SocialManager
    var mockGM *governance.GovernanceManager

    apiServer := NewAPIServer(mockBM, mockTM, nil, mockCM, mockNode, mockIM, mockSM, mockGM)

    req, err := http.NewRequest("GET", "/status", nil)
    if err != nil {
        t.Fatalf("could not create request: %v", err)
    }

    rr := httptest.NewRecorder()

    // 2. Execution
    handler := http.HandlerFunc(apiServer.handleGetStatus)
    handler.ServeHTTP(rr, req)

    // 3. Verification
    if status := rr.Code; status != http.StatusOK {
        t.Errorf("handler returned wrong status code: got %v want %v",
            status, http.StatusOK)
    }

    // Check the response body
    var response map[string]interface{}
    err = json.Unmarshal(rr.Body.Bytes(), &response)
    if err != nil {
        t.Fatalf("could not unmarshal response: %v", err)
    }

    expectedKeys := []string{
        "blockHeight",
        "txPoolSize",
        "isValidator",
        "totalValidators",
        "mode",
    }

    for _, key := range expectedKeys {
        if _, ok := response[key]; !ok {
            t.Errorf("response missing expected key: %s", key)
        }
    }

    // Check types for a couple of keys
    if val, ok := response["blockHeight"].(float64); !ok || val != 12345 {
         t.Errorf("blockHeight has wrong value or type: got %T, %v", response["blockHeight"], response["blockHeight"])
    }
     if val, ok := response["txPoolSize"].(float64); !ok || val != 42 {
        t.Errorf("txPoolSize has wrong value or type: got %T, %v", response["txPoolSize"], response["txPoolSize"])
    }
}
