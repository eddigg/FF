# Test script to verify all services are running correctly

Write-Host "🔍 Testing ATLAS Blockchain Services..." -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

# Test 1: Blockchain Node
Write-Host "Testing Blockchain Node (localhost:8080)..." -ForegroundColor Yellow
try {
    $blockchainResponse = Invoke-WebRequest -Uri "http://localhost:8080" -Method GET -TimeoutSec 5
    Write-Host "✅ Blockchain Node: OK (Status: $($blockchainResponse.StatusCode))" -ForegroundColor Green
} catch {
    Write-Host "❌ Blockchain Node: Not reachable" -ForegroundColor Red
}

# Test 2: API Gateway
Write-Host "Testing API Gateway (localhost:3000)..." -ForegroundColor Yellow
try {
    $gatewayResponse = Invoke-WebRequest -Uri "http://localhost:3000" -Method GET -TimeoutSec 5
    Write-Host "✅ API Gateway: OK (Status: $($gatewayResponse.StatusCode))" -ForegroundColor Green
} catch {
    Write-Host "❌ API Gateway: Not reachable" -ForegroundColor Red
}

# Test 3: Frontend
Write-Host "Testing Frontend (localhost:5000)..." -ForegroundColor Yellow
try {
    $frontendResponse = Invoke-WebRequest -Uri "http://localhost:5000" -Method GET -TimeoutSec 5
    Write-Host "✅ Frontend: OK (Status: $($frontendResponse.StatusCode))" -ForegroundColor Green
} catch {
    Write-Host "❌ Frontend: Not reachable" -ForegroundColor Red
}

# Test 4: API Gateway Blockchain Integration
Write-Host "Testing API Gateway ↔ Blockchain Integration..." -ForegroundColor Yellow
try {
    $balanceResponse = Invoke-WebRequest -Uri "http://localhost:3000/balance/0x1234567890123456789012345678901234567890" -Method GET -TimeoutSec 5
    $balanceData = $balanceResponse.Content | ConvertFrom-Json
    Write-Host "✅ API Gateway ↔ Blockchain: OK (Balance: $($balanceData.balance))" -ForegroundColor Green
} catch {
    Write-Host "❌ API Gateway ↔ Blockchain: Integration failed" -ForegroundColor Red
}

Write-Host "Test completed." -ForegroundColor Green