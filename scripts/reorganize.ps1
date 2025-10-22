# FF Project Reorganization Script for Windows PowerShell
# This script reorganizes the FF project structure

Write-Host "Starting FF project reorganization..."

# Function to move files with error handling
function Move-FileSafely {
    param(
        [string]$source,
        [string]$destination
    )

    try {
        if (Test-Path $source) {
            Write-Host "Moving $source to $destination"
            Move-Item -Path $source -Destination $destination -Force -ErrorAction Stop
            Write-Host "Successfully moved $source"
        } else {
            Write-Host "Source not found: $source"
        }
    } catch {
        Write-Host "ERROR moving $source : $_" -ForegroundColor Red
    }
}

# 1. Move Flutter application files
Write-Host "`n--- Moving Flutter Application Files ---"

# Create directories if they don't exist
$cercaendLibPath = "apps\cercaend\lib"
if (-not (Test-Path $cercaendLibPath)) {
    New-Item -ItemType Directory -Path $cercaendLibPath | Out-Null
}

# Move Flutter files
Move-FileSafely -source "lib" -destination "apps\cercaend\lib"
Move-FileSafely -source "android" -destination "apps\cercaend\"
Move-FileSafely -source "ios" -destination "apps\cercaend\"
Move-FileSafely -source "web" -destination "apps\cercaend\"
Move-FileSafely -source "pubspec.yaml" -destination "apps\cercaend\"
Move-FileSafely -source "pubspec.lock" -destination "apps\cercaend\"
Move-FileSafely -source "assets" -destination "apps\cercaend\"
Move-FileSafely -source "analysis_options.yaml" -destination "apps\cercaend\"
Move-FileSafely -source "cercaend_wallet.iml" -destination "apps\cercaend\"
Move-FileSafely -source "ff_consolidated_project.iml" -destination "apps\cercaend\"

# 2. Move Blockchain components
Write-Host "`n--- Moving Blockchain Components ---"

# Create blockchain directories if they don't exist
$blockchainPath = "apps\blockchain"
if (-not (Test-Path $blockchainPath)) {
    New-Item -ItemType Directory -Path $blockchainPath | Out-Null
}

# Move blockchain files
if (Test-Path "products\blockchain") {
    # Move entire blockchain directory
    Move-Item -Path "products\blockchain\*" -Destination "apps\blockchain\" -Force -ErrorAction Stop
    Write-Host "Moved blockchain components"
} else {
    Write-Host "Blockchain source directory not found" -ForegroundColor Yellow
}

Move-FileSafely -source "nodekey.priv" -destination "apps\blockchain\"
Move-FileSafely -source "governance" -destination "apps\blockchain\internal\"

# 3. Move existing blockchain integration files
Write-Host "`n--- Moving Blockchain Integration Files ---"

# Create services directory if it doesn't exist
$blockchainServicesPath = "apps\cercaend\lib\services\blockchain"
if (-not (Test-Path $blockchainServicesPath)) {
    New-Item -ItemType Directory -Path $blockchainServicesPath | Out-Null
}

if (Test-Path "lib\services\blockchain") {
    Move-Item -Path "lib\services\blockchain\*" -Destination "apps\cercaend\lib\services\blockchain\" -Force -ErrorAction Stop
    Write-Host "Moved blockchain integration files"
} else {
    Write-Host "Blockchain integration source directory not found" -ForegroundColor Yellow
}

Write-Host "`n--- Reorganization Complete ---"
Write-Host "Next steps:"
Write-Host "1. Verify all files are in their correct locations"
Write-Host "2. Update imports in the Flutter application"
Write-Host "3. Update Go module paths in the blockchain code"
Write-Host "4. Create shared models and protocol buffers"
Write-Host "5. Implement the API gateway and Flutter plugin"
