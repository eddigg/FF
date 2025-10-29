# FF Project - Development Setup Guide

This monorepo contains a Flutter frontend application (cercaend) and a Go blockchain backend (atlas-blockchain). The project uses a Node.js API gateway for development.

## Quick Start

To run the entire development environment:

```powershell
# Run all services
.\scripts\run-dev.ps1

# Or run services individually:
.\scripts\start-blockchain.ps1    # Starts blockchain on port 8080
.\scripts\start-api-gateway.ps1   # Starts API gateway on port 3000
.\scripts\start-flutter.ps1       # Starts Flutter app
```

## Architecture

### Components

1. **Blockchain Server** (`apps/blockchain/core/blockchain_with_sqlite.exe`)
   - Go-based blockchain implementation
   - Runs on port 8080
   - Provides REST API endpoints for blockchain operations
   - Uses SQLite for data persistence

2. **API Gateway** (`integrations/api-gateway/index.js`)
   - Node.js/Express mock API server
   - Runs on port 3000
   - Provides endpoints that the Flutter app expects
   - Currently uses mock data for development

3. **Flutter App** (`apps/cercaend/`)
   - Frontend application built with Flutter
   - Connects to API Gateway on port 3000
   - Uses Firebase and Supabase for additional services

### API Endpoints

The Flutter app expects these endpoints from the API Gateway:

- `GET /balance/{address}` - Get account balance
- `GET /transactions/{address}` - Get transaction history
- `POST /submit-transaction` - Submit new transaction

## Development Workflow

### Running Individual Components

```powershell
# 1. Start the blockchain server
.\scripts\start-blockchain.ps1

# 2. Start the API gateway (in a new terminal)
.\scripts\start-api-gateway.ps1

# 3. Start the Flutter app (in a new terminal)
.\scripts\start-flutter.ps1
```

### Building from Source

If you need to rebuild the blockchain:

```powershell
cd apps/blockchain
go build -o blockchain-server.exe .
```

### Configuration

The Flutter app is configured to connect to `http://localhost:3000` for API calls. The API gateway provides mock responses for development.

For production, the API gateway would need to be updated to proxy requests to the actual blockchain server.

## Project Structure

```
apps/
├── blockchain/          # Go blockchain implementation
│   └── core/
│       ├── blockchain_with_sqlite.exe  # Compiled executable
│       └── pkg/                        # Go packages
├── cercaend/            # Flutter frontend app

integrations/
└── api-gateway/         # Node.js API gateway (mock server)

scripts/
├── run-dev.ps1         # Start all services
├── start-blockchain.ps1 # Start blockchain only
├── start-api-gateway.ps1 # Start API gateway only
├── start-flutter.ps1   # Start Flutter only
└── stop-services.ps1   # Stop all services
```

## Troubleshooting

### Port Conflicts
- Blockchain: 8080
- API Gateway: 3000
- Flutter: Uses device-specific ports

### Service Logs
Check the log files created in each service directory:
- `blockchain.log` / `blockchain-error.log`
- `api-gateway.log` / `api-gateway-error.log`
- `flutter.log` / `flutter-error.log`

### Common Issues

1. **Missing Dependencies**: Run `flutter pub get` in the cercaend directory
2. **Port in Use**: Check if ports 3000 and 8080 are available
3. **Node.js Not Found**: Ensure Node.js is installed for the API gateway

## Next Steps

For production deployment:
1. Update the API gateway to proxy real blockchain requests instead of using mock data
2. Configure proper Firebase/Supabase credentials
3. Set up Docker deployment using the provided `docker-compose.yml`
4. Configure environment-specific settings

## Support

Check the individual README files in each application directory for more detailed setup instructions:
- `apps/cercaend/README.md`
- `apps/blockchain/README.md` (when available)
