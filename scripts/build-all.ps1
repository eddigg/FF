# scripts/build-all.ps1

# Build blockchain
Write-Host "Building blockchain..." -ForegroundColor Green
Set-Location apps/blockchain
go build -o ../bin/blockchain-node ./cmd
Set-Location ../..

# Build API Gateway
Write-Host "Building API Gateway..." -ForegroundColor Green
Set-Location integrations/api-gateway
go build -o ../bin/api-gateway .
Set-Location ../..

# Build Flutter
Write-Host "Building Flutter app..." -ForegroundColor Green
Set-Location apps/cercaend
flutter pub get
flutter build apk
Set-Location ../..

# Generate protobuf files
Write-Host "Generating protobuf files..." -ForegroundColor Green
Set-Location shared
protoc --dart_out=../apps/cercaend/lib/shared --go_out=../apps/blockchain/pkg proto/*.proto
Set-Location ..
