package vm

import (
	"fmt"
	// "blockchain/zk"
)

// ContractType represents the type of contract
type ContractType string

const (
	ContractTypeSystem   ContractType = "system"   // Pre-approved system contracts
	ContractTypeGovernance ContractType = "governance" // Governance contracts
	ContractTypeCustom   ContractType = "custom"   // User contracts (require approval)
	ContractTypeVoting   ContractType = "voting"   // Voting system contracts
)

// ContractPermission represents contract execution permissions
type ContractPermission struct {
	ContractAddress string
	ContractType    ContractType
	AllowedFunctions []string
	IsActive        bool
	ApprovedBy      string
	ApprovedAt      int64
}

// VM represents the custom virtual machine for executing smart contracts.
type VM struct {
	// Add fields for state, storage, gas metering, etc.
	StateManager interface{} // Reference to StateManager for oracles (will be cast in main)
	// ProofVerifier *zk.ProofVerifier // For zero-knowledge proof verification (disabled)

	// Minimal stack and memory for contract execution
	stack  []int64
	Memory map[string]int64
	
	// Gas metering
	gasUsed  uint64
	gasLimit uint64

	// Permissioned contract system
	contractRegistry map[string]*ContractPermission
	currentContract  *Contract
	callStack        []*ExecutionContext
	maxCallDepth     int
}

// Gas costs for different operations
var GasCosts = map[string]uint64{
	"PUSH":   3,
	"POP":    1,
	"ADD":    3,
	"SUB":    3,
	"MUL":    5,
	"DIV":    5,
	"STORE":  5,
	"LOAD":   3,
	"JUMP":   1,
	"JUMPIF": 2,
	"CALL":   10,
	"RETURN": 1,
	"DUP":    1,
	"SWAP":   1,
	"GT":     3,
	"LT":     3,
	"EQ":     3,
	"NEQ":    3,
	"AND":    3,
	"OR":     3,
	"NOT":    2,
}

// Instruction represents a single VM instruction.
type Instruction struct {
	Opcode   string
	Operands []interface{}
}

// NewVM creates a new VM instance with permissioned contract support
func NewVM() *VM {
	return &VM{
		stack:            make([]int64, 0),
		Memory:           make(map[string]int64),
		contractRegistry: make(map[string]*ContractPermission),
		callStack:        make([]*ExecutionContext, 0),
		maxCallDepth:     10, // Prevent infinite recursion
	}
}

// RegisterSystemContract registers a pre-approved system contract
func (vm *VM) RegisterSystemContract(address string, allowedFunctions []string) {
	vm.contractRegistry[address] = &ContractPermission{
		ContractAddress:  address,
		ContractType:     ContractTypeSystem,
		AllowedFunctions: allowedFunctions,
		IsActive:         true,
		ApprovedBy:       "SYSTEM",
		ApprovedAt:       0, // System contracts are always approved
	}
}

// RegisterGovernanceContract registers a governance contract
func (vm *VM) RegisterGovernanceContract(address string, allowedFunctions []string, approvedBy string) {
	vm.contractRegistry[address] = &ContractPermission{
		ContractAddress:  address,
		ContractType:     ContractTypeGovernance,
		AllowedFunctions: allowedFunctions,
		IsActive:         true,
		ApprovedBy:       approvedBy,
		ApprovedAt:       0, // Governance contracts are pre-approved
	}
}

// RegisterVotingContract registers a voting system contract
func (vm *VM) RegisterVotingContract(address string, allowedFunctions []string) {
	vm.contractRegistry[address] = &ContractPermission{
		ContractAddress:  address,
		ContractType:     ContractTypeVoting,
		AllowedFunctions: allowedFunctions,
		IsActive:         true,
		ApprovedBy:       "SYSTEM",
		ApprovedAt:       0, // Voting contracts are system-controlled
	}
}

// ApproveCustomContract approves a custom contract for execution
func (vm *VM) ApproveCustomContract(address string, allowedFunctions []string, approvedBy string, approvedAt int64) error {
	// Check if contract is already registered
	if _, exists := vm.contractRegistry[address]; exists {
		return fmt.Errorf("contract %s is already registered", address)
	}

	vm.contractRegistry[address] = &ContractPermission{
		ContractAddress:  address,
		ContractType:     ContractTypeCustom,
		AllowedFunctions: allowedFunctions,
		IsActive:         true,
		ApprovedBy:       approvedBy,
		ApprovedAt:       approvedAt,
	}
	return nil
}

// IsContractApproved checks if a contract is approved for execution
func (vm *VM) IsContractApproved(address string) bool {
	permission, exists := vm.contractRegistry[address]
	return exists && permission.IsActive
}

// IsFunctionAllowed checks if a function is allowed for a contract
func (vm *VM) IsFunctionAllowed(contractAddress, functionName string) bool {
	permission, exists := vm.contractRegistry[contractAddress]
	if !exists || !permission.IsActive {
		return false
	}

	// System, governance, and voting contracts have full access
	if permission.ContractType == ContractTypeSystem || 
	   permission.ContractType == ContractTypeGovernance || 
	   permission.ContractType == ContractTypeVoting {
		return true
	}

	// Custom contracts check allowed functions
	for _, allowedFunc := range permission.AllowedFunctions {
		if allowedFunc == functionName {
			return true
		}
	}
	return false
}

// Execute runs a sequence of instructions in the VM context.
func (vm *VM) Execute(instructions []Instruction, context *ExecutionContext) error {
	// Initialize stack and memory for each execution (but preserve existing stack for contract calls)
	if context.ContractAddress == "" {
		// Only reset stack for non-contract execution
		vm.stack = make([]int64, 0)
	}
	if vm.Memory == nil {
		vm.Memory = make(map[string]int64)
	}
	
	// Initialize gas metering
	vm.gasUsed = 0
	vm.gasLimit = context.GasLimit

	// Set current contract context
	if context.ContractAddress != "" {
		// Validate contract permissions
		if !vm.IsContractApproved(context.ContractAddress) {
			return fmt.Errorf("contract %s is not approved for execution", context.ContractAddress)
		}
	}

	for i, instr := range instructions {
		// Charge gas for this instruction
		if cost, exists := GasCosts[instr.Opcode]; exists {
			if !vm.chargeGas(cost) {
				return fmt.Errorf("out of gas at instruction %d", i)
			}
		}
		
		switch instr.Opcode {
		case "PUSH":
			if len(instr.Operands) != 1 {
				return fmt.Errorf("PUSH expects 1 operand at instruction %d", i)
			}
			val, ok := toInt64(instr.Operands[0])
			if !ok {
				return fmt.Errorf("PUSH operand must be int64 at instruction %d", i)
			}
			vm.stack = append(vm.stack, val)
		case "POP":
			if len(vm.stack) < 1 {
				return fmt.Errorf("POP on empty stack at instruction %d", i)
			}
			vm.stack = vm.stack[:len(vm.stack)-1]
		case "ADD":
			if len(vm.stack) < 2 {
				return fmt.Errorf("ADD needs 2 values on stack at instruction %d", i)
			}
			a, b := vm.stack[len(vm.stack)-2], vm.stack[len(vm.stack)-1]
			vm.stack = vm.stack[:len(vm.stack)-2]
			vm.stack = append(vm.stack, a+b)
		case "SUB":
			if len(vm.stack) < 2 {
				return fmt.Errorf("SUB needs 2 values on stack at instruction %d", i)
			}
			a, b := vm.stack[len(vm.stack)-2], vm.stack[len(vm.stack)-1]
			vm.stack = vm.stack[:len(vm.stack)-2]
			vm.stack = append(vm.stack, a-b)
		case "MUL":
			if len(vm.stack) < 2 {
				return fmt.Errorf("MUL needs 2 values on stack at instruction %d", i)
			}
			a, b := vm.stack[len(vm.stack)-2], vm.stack[len(vm.stack)-1]
			vm.stack = vm.stack[:len(vm.stack)-2]
			vm.stack = append(vm.stack, a*b)
		case "DIV":
			if len(vm.stack) < 2 {
				return fmt.Errorf("DIV needs 2 values on stack at instruction %d", i)
			}
			a, b := vm.stack[len(vm.stack)-2], vm.stack[len(vm.stack)-1]
			if b == 0 {
				return fmt.Errorf("division by zero at instruction %d", i)
			}
			vm.stack = vm.stack[:len(vm.stack)-2]
			vm.stack = append(vm.stack, a/b)
		case "STORE":
			if len(instr.Operands) != 1 {
				return fmt.Errorf("STORE expects 1 operand (key) at instruction %d", i)
			}
			if len(vm.stack) < 1 {
				return fmt.Errorf("STORE needs 1 value on stack at instruction %d", i)
			}
			key, ok := instr.Operands[0].(string)
			if !ok {
				return fmt.Errorf("STORE key must be string at instruction %d", i)
			}
			value := vm.stack[len(vm.stack)-1]
			vm.stack = vm.stack[:len(vm.stack)-1]
			vm.Memory[key] = value
		case "LOAD":
			if len(instr.Operands) != 1 {
				return fmt.Errorf("LOAD expects 1 operand (key) at instruction %d", i)
			}
			key, ok := instr.Operands[0].(string)
			if !ok {
				return fmt.Errorf("LOAD key must be string at instruction %d", i)
			}
			value, exists := vm.Memory[key]
			if !exists {
				value = 0 // Default to 0 if key doesn't exist
			}
			vm.stack = append(vm.stack, value)
		case "JUMP":
			if len(instr.Operands) != 1 {
				return fmt.Errorf("JUMP expects 1 operand (target) at instruction %d", i)
			}
			target, ok := toInt64(instr.Operands[0])
			if !ok {
				return fmt.Errorf("JUMP target must be int64 at instruction %d", i)
			}
			if target < 0 || target >= int64(len(instructions)) {
				return fmt.Errorf("JUMP target out of bounds at instruction %d", i)
			}
			i = int(target) - 1 // -1 because loop will increment
		case "JUMPIF":
			if len(instr.Operands) != 1 {
				return fmt.Errorf("JUMPIF expects 1 operand (target) at instruction %d", i)
			}
			if len(vm.stack) < 1 {
				return fmt.Errorf("JUMPIF needs 1 value on stack at instruction %d", i)
			}
			condition := vm.stack[len(vm.stack)-1]
			vm.stack = vm.stack[:len(vm.stack)-1]
			if condition != 0 {
				target, ok := toInt64(instr.Operands[0])
				if !ok {
					return fmt.Errorf("JUMPIF target must be int64 at instruction %d", i)
				}
				if target < 0 || target >= int64(len(instructions)) {
					return fmt.Errorf("JUMPIF target out of bounds at instruction %d", i)
				}
				i = int(target) - 1 // -1 because loop will increment
			}
		case "CALL":
			if len(instr.Operands) != 1 {
				return fmt.Errorf("CALL expects 1 operand (function name) at instruction %d", i)
			}
			functionName, ok := instr.Operands[0].(string)
			if !ok {
				return fmt.Errorf("CALL operand must be string at instruction %d", i)
			}
			
			// Check call depth to prevent infinite recursion
			if len(vm.callStack) >= vm.maxCallDepth {
				return fmt.Errorf("maximum call depth exceeded at instruction %d", i)
			}

			// Validate function call permissions
			if context.ContractAddress != "" {
				if !vm.IsFunctionAllowed(context.ContractAddress, functionName) {
					return fmt.Errorf("function %s not allowed for contract %s at instruction %d", 
						functionName, context.ContractAddress, i)
				}
			}

			// Execute the function call
			if err := vm.executeFunctionCall(functionName, context); err != nil {
				return fmt.Errorf("function call failed at instruction %d: %v", i, err)
			}
		case "RETURN":
			// Return from current execution context
			return nil
		case "DUP":
			if len(vm.stack) < 1 {
				return fmt.Errorf("DUP on empty stack at instruction %d", i)
			}
			value := vm.stack[len(vm.stack)-1]
			vm.stack = append(vm.stack, value)
		case "SWAP":
			if len(vm.stack) < 2 {
				return fmt.Errorf("SWAP needs 2 values on stack at instruction %d", i)
			}
			vm.stack[len(vm.stack)-2], vm.stack[len(vm.stack)-1] = vm.stack[len(vm.stack)-1], vm.stack[len(vm.stack)-2]
		case "GT":
			if len(vm.stack) < 2 {
				return fmt.Errorf("GT needs 2 values on stack at instruction %d", i)
			}
			a, b := vm.stack[len(vm.stack)-2], vm.stack[len(vm.stack)-1]
			vm.stack = vm.stack[:len(vm.stack)-2]
			if a > b {
				vm.stack = append(vm.stack, 1)
			} else {
				vm.stack = append(vm.stack, 0)
			}
		case "LT":
			if len(vm.stack) < 2 {
				return fmt.Errorf("LT needs 2 values on stack at instruction %d", i)
			}
			a, b := vm.stack[len(vm.stack)-2], vm.stack[len(vm.stack)-1]
			vm.stack = vm.stack[:len(vm.stack)-2]
			if a < b {
				vm.stack = append(vm.stack, 1)
			} else {
				vm.stack = append(vm.stack, 0)
			}
		case "EQ":
			if len(vm.stack) < 2 {
				return fmt.Errorf("EQ needs 2 values on stack at instruction %d", i)
			}
			a, b := vm.stack[len(vm.stack)-2], vm.stack[len(vm.stack)-1]
			vm.stack = vm.stack[:len(vm.stack)-2]
			if a == b {
				vm.stack = append(vm.stack, 1)
			} else {
				vm.stack = append(vm.stack, 0)
			}
		case "NEQ":
			if len(vm.stack) < 2 {
				return fmt.Errorf("NEQ needs 2 values on stack at instruction %d", i)
			}
			a, b := vm.stack[len(vm.stack)-2], vm.stack[len(vm.stack)-1]
			vm.stack = vm.stack[:len(vm.stack)-2]
			if a != b {
				vm.stack = append(vm.stack, 1)
			} else {
				vm.stack = append(vm.stack, 0)
			}
		case "AND":
			if len(vm.stack) < 2 {
				return fmt.Errorf("AND needs 2 values on stack at instruction %d", i)
			}
			a, b := vm.stack[len(vm.stack)-2], vm.stack[len(vm.stack)-1]
			vm.stack = vm.stack[:len(vm.stack)-2]
			if a != 0 && b != 0 {
				vm.stack = append(vm.stack, 1)
			} else {
				vm.stack = append(vm.stack, 0)
			}
		case "OR":
			if len(vm.stack) < 2 {
				return fmt.Errorf("OR needs 2 values on stack at instruction %d", i)
			}
			a, b := vm.stack[len(vm.stack)-2], vm.stack[len(vm.stack)-1]
			vm.stack = vm.stack[:len(vm.stack)-2]
			if a != 0 || b != 0 {
				vm.stack = append(vm.stack, 1)
			} else {
				vm.stack = append(vm.stack, 0)
			}
		case "NOT":
			if len(vm.stack) < 1 {
				return fmt.Errorf("NOT needs 1 value on stack at instruction %d", i)
			}
			a := vm.stack[len(vm.stack)-1]
			vm.stack = vm.stack[:len(vm.stack)-1]
			if a == 0 {
				vm.stack = append(vm.stack, 1)
			} else {
				vm.stack = append(vm.stack, 0)
			}
		default:
			return fmt.Errorf("unknown opcode '%s' at instruction %d", instr.Opcode, i)
		}
	}
	return nil
}

// executeFunctionCall handles function calls within contracts
func (vm *VM) executeFunctionCall(functionName string, context *ExecutionContext) error {
	// Push current context to call stack
	vm.callStack = append(vm.callStack, context)

	// Find the function in the current contract
	if vm.currentContract == nil {
		return fmt.Errorf("no current contract context for function call")
	}

	function, exists := vm.currentContract.Functions[functionName]
	if !exists {
		return fmt.Errorf("function %s not found in contract", functionName)
	}

	// Execute the function's instructions
	if err := vm.Execute(function.Code, context); err != nil {
		return fmt.Errorf("function %s execution failed: %v", functionName, err)
	}

	// Pop context from call stack
	if len(vm.callStack) > 0 {
		vm.callStack = vm.callStack[:len(vm.callStack)-1]
	}

	return nil
}

// chargeGas deducts gas for an operation
func (vm *VM) chargeGas(amount uint64) bool {
	if vm.gasUsed+amount > vm.gasLimit {
		return false // Out of gas
	}
	vm.gasUsed += amount
	return true
}

// GetGasUsed returns the amount of gas used
func (vm *VM) GetGasUsed() uint64 {
	return vm.gasUsed
}

// GetGasLimit returns the gas limit
func (vm *VM) GetGasLimit() uint64 {
	return vm.gasLimit
}

// toInt64 converts interface{} to int64
func toInt64(val interface{}) (int64, bool) {
	switch v := val.(type) {
	case int:
		return int64(v), true
	case int64:
		return v, true
	case float64:
		return int64(v), true
	case string:
		// Try to parse as number
		var result int64
		_, err := fmt.Sscanf(v, "%d", &result)
		return result, err == nil
	default:
		return 0, false
	}
}

// GetOracleValue retrieves oracle data (placeholder for now)
func (vm *VM) GetOracleValue(key string) (string, bool) {
	// This would integrate with the actual oracle system
	// For now, return placeholder data
	oracleData := map[string]string{
		"price_btc": "45000",
		"price_eth": "3000",
		"weather":   "sunny",
	}
	value, exists := oracleData[key]
	return value, exists
}

// VerifyZKProof verifies zero-knowledge proofs (placeholder for now)
func (vm *VM) VerifyZKProof(proof interface{}) (bool, error) {
	// This would integrate with actual ZK proof verification
	// For now, return true (mock implementation)
	return true, nil
} 