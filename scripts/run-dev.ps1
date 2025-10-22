# scripts/run-dev.ps1

# Start blockchain node
Write-Host "Starting blockchain node..." -ForegroundColor Green
Set-Location apps/blockchain
Start-Process -NoNewWindow -FilePath "./bin/blockchain-node" -ArgumentList "--dev" -RedirectStandardOutput "blockchain.log" -RedirectStandardError "blockchain-error.log"
Set-Location ../..

# Start API Gateway
Write-Host "Starting API Gateway..." -ForegroundColor Green
Set-Location integrations/api-gateway
Start-Process -NoNewWindow -FilePath "./bin/api-gateway" -RedirectStandardOutput "api-gateway.log" -RedirectStandardError "api-gateway-error.log"
Set-Location ../..

# Start Flutter app
Write-Host "Starting Flutter app..." -ForegroundColor Green
Set-Location apps/cercaend
flutter run -d all
Set-Location ../..

Write-Host "Development environment started!" -ForegroundColor Green
Write-Host "Press Ctrl+C to stop all services..." -ForegroundColor Yellow
