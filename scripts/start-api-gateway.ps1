# scripts/start-api-gateway.ps1

Write-Host "Starting API Gateway..." -ForegroundColor Green
Set-Location integrations/api-gateway
Start-Process -NoNewWindow -FilePath "node" -ArgumentList "index.js" -RedirectStandardOutput "api-gateway.log" -RedirectStandardError "api-gateway-error.log"
Set-Location ../..

Write-Host "API Gateway started!" -ForegroundColor Green
Write-Host "API available at: http://localhost:3000" -ForegroundColor Yellow
Write-Host "Check api-gateway.log for server output" -ForegroundColor Yellow
