#!/bin/bash
# FF Project Reorganization Script
# This script reorganizes the FF project structure to better separate
# the Flutter frontend (Cercaend) and Go backend (ATLAS Blockchain)

echo "Starting FF project reorganization..."

# Create directory structure if it doesn't exist
echo "Creating directory structure..."
mkdir -p apps/cercaend/lib/services/blockchain
mkdir -p apps/blockchain/cmd
mkdir -p apps/blockchain/internal/{api,blockchain,defi,governance,identity,social}
mkdir -p apps/blockchain/pkg/{block,config,crypto,database,monitoring,network,sharding,state,transaction,vm,wallet}
mkdir -p shared/{models/{dart,go},proto,utils}
mkdir -p integrations/{api-gateway,flutter-plugin,docs}
mkdir -p scripts
mkdir -p config

echo "Directory structure created."

# Move Flutter application files
echo "Moving Flutter application files..."
mv lib/ apps/cercaend/
mv android/ apps/cercaend/
mv ios/ apps/cercaend/
mv web/ apps/cercaend/
mv pubspec.yaml apps/cercaend/
mv pubspec.lock apps/cercaend/
mv assets/ apps/cercaend/
mv analysis_options.yaml apps/cercaend/
mv cercaend_wallet.iml apps/cercaend/
mv ff_consolidated_project.iml apps/cercaend/

# Move blockchain components
echo "Moving blockchain components..."
mv products/blockchain/* apps/blockchain/
mv nodekey.priv apps/blockchain/
mv governance/ apps/blockchain/internal/

# Move existing blockchain integration files
echo "Moving existing blockchain integration files..."
mv lib/services/blockchain/* apps/cercaend/lib/services/blockchain/

# Move documentation
echo "Moving documentation..."
mv docs/integration.md .
mv docs/architecture.md .

# Create README files for new directories
echo "Creating README files for new directories..."
echo "# Cercaend Flutter Application
This directory contains the Flutter frontend application for the Cercaend platform.

## Structure
- lib/: Dart source code
- android/: Android platform files
- ios/: iOS platform files
- web/: Web platform files
- assets/: Application assets" > apps/cercaend/README.md

echo "# ATLAS Blockchain
This directory contains the Go implementation of the ATLAS Blockchain platform.

## Structure
- cmd/: Entry points
- internal/: Private application code
- pkg/: Public libraries
- nodekey.priv: Node private key" > apps/blockchain/README.md

echo "# Shared Components
This directory contains code shared between the Flutter frontend and Go backend.

## Structure
- models/: Shared data models
  - dart/: Dart models
  - go/: Go models
- proto/: Protocol buffer definitions
- utils/: Shared utilities" > shared/README.md

echo "# Integration Components
This directory contains components that bridge the Flutter frontend and Go backend.

## Structure
- api-gateway/: Unified API layer
- flutter-plugin/: Flutter to Blockchain bridge
- docs/: Integration documentation" > integrations/README.md

echo "# Scripts
This directory contains build and deployment scripts.

## Available Scripts
- reorganize.sh: This reorganization script
- build-all.sh: Build all components
- run-dev.sh: Run development environment" > scripts/README.md

echo "# Config
This directory contains configuration files for the project.

## Files
- docker-compose.yml: Development environment
- env.example: Environment variable template" > config/README.md

echo "Reorganization complete!"
echo ""
echo "Next steps:"
echo "1. Update imports in the Flutter application to reflect new paths"
echo "2. Update Go module paths in the blockchain code"
echo "3. Create shared models and protocol buffers"
echo "4. Implement the API gateway and Flutter plugin"
echo "5. Update build scripts and configuration files"
