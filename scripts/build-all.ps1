# scripts/build-all.ps1

# Build blockchain
Write-Host "Building blockchain..." -ForegroundColor Green
Set-Location apps/blockchain
go build -o ../bin/blockchain-node ./core/cmd
Set-Location ../..

# Build API Gateway
Write-Host "Building API Gateway..." -ForegroundColor Green
Set-Location integrations/api-gateway
go build -o ../bin/api-gateway .
Set-Location ../..

# Build Flutter Web
Write-Host "Building Flutter web app..." -ForegroundColor Green
Set-Location apps/cercaend
flutter pub get
flutter build web
Set-Location ../..

# Generate protobuf files
Write-Host "Generating protobuf files..." -ForegroundColor Green
Set-Location packages/api
protoc --dart_out=../../apps/cercaend/lib/shared --go_out=../../apps/blockchain/pkg blockchain.proto
Set-Location ../..