# scripts/stop-services.ps1

Write-Host "Stopping all services..." -ForegroundColor Yellow

# Stop blockchain processes
Get-Process | Where-Object { $_.ProcessName -like "*blockchain*" } | Stop-Process -Force -ErrorAction SilentlyContinue

# Stop node processes (API Gateway)
Get-Process | Where-Object { $_.ProcessName -eq "node" } | Stop-Process -Force -ErrorAction SilentlyContinue

# Stop flutter processes
Get-Process | Where-Object { $_.ProcessName -like "*flutter*" } | Stop-Process -Force -ErrorAction SilentlyContinue

Write-Host "All services stopped!" -ForegroundColor Green
