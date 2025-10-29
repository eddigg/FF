# scripts/start-blockchain.ps1

Write-Host "Starting Blockchain Server..." -ForegroundColor Green
Set-Location apps/blockchain/core
Start-Process -NoNewWindow -FilePath "./blockchain_with_sqlite.exe" -RedirectStandardOutput "blockchain.log" -RedirectStandardError "blockchain-error.log"
Set-Location ../../..

Write-Host "Blockchain server started!" -ForegroundColor Green
Write-Host "API available at: http://localhost:8080" -ForegroundColor Yellow
Write-Host "Check blockchain.log for server output" -ForegroundColor Yellow
