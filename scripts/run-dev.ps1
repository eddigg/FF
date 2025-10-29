# scripts/run-dev.ps1

# Start blockchain node
Write-Host "Starting blockchain node..." -ForegroundColor Green
Set-Location apps/blockchain/core
Start-Process -NoNewWindow -FilePath "./blockchain_with_sqlite.exe" -RedirectStandardOutput "blockchain.log" -RedirectStandardError "blockchain-error.log"
Set-Location ../../..

# Start API Gateway
Write-Host "Starting API Gateway..." -ForegroundColor Green
Set-Location integrations/api-gateway
Start-Process -NoNewWindow -FilePath "node" -ArgumentList "index.js" -RedirectStandardOutput "api-gateway.log" -RedirectStandardError "api-gateway-error.log"
Set-Location ../..

# Start Flutter app
Write-Host "Starting Flutter app..." -ForegroundColor Green
Set-Location apps/cercaend
Start-Process -NoNewWindow -FilePath "flutter" -ArgumentList "run -d windows" -RedirectStandardOutput "flutter.log" -RedirectStandardError "flutter-error.log"
Set-Location ../..

Write-Host "Development environment started!" -ForegroundColor Green
Write-Host "Blockchain: http://localhost:8080" -ForegroundColor Yellow
Write-Host "API Gateway: http://localhost:3000" -ForegroundColor Yellow
Write-Host "Flutter App: Check your device" -ForegroundColor Yellow
Write-Host "Press Ctrl+C to stop all services..." -ForegroundColor Yellow
