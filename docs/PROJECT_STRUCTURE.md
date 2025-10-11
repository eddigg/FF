# ATLAS Blockchain Project - Structure Overview

## Project Components

### 1. ATLAS.BC0.0.1 (Backend)
- **Purpose**: Go-based blockchain implementation
- **Location**: `./ATLAS.BC0.0.1/`
- **Responsibilities**:
  - User identity management
  - Wallet creation and management
  - Transaction processing
  - DeFi functionality
  - Governance system
  - REST API endpoints for blockchain data

### 2. GOFLUTTER (Web Frontend)
- **Purpose**: Flutter web application for blockchain features
- **Location**: `./GOFLUTTER/`
- **Responsibilities**:
  - Wallet dashboard
  - Transaction history
  - Send/receive functionality
  - DeFi features
  - Governance participation

### 3. cercaend (Mobile App)
- **Purpose**: Flutter mobile wallet application
- **Location**: `./cercaend/`
- **Responsibilities**:
  - User authentication
  - Wallet management
  - Transaction processing
  - Social features
  - Firebase integration

## Project Architecture

```
├── ATLAS.BC0.0.1/              # Go-based blockchain backend
├── GOFLUTTER/                  # Flutter web frontend
│   ├── lib/
│   │   ├── features/           # Feature modules
│   │   ├── shared/             # Shared components, themes, widgets
│   │   └── main.dart
│   ├── pubspec.yaml
│   └── ...
├── cercaend/                   # Flutter mobile app
├── docs/                       # Project documentation
│   ├── api/                    # API documentation
│   ├── architecture/           # Architecture documents
│   └── development/            # Development guides
├── samples/                    # Sample implementations
├── scripts/                    # Setup and utility scripts
└── README.md
```

## Setup Instructions

### Backend Setup (ATLAS.BC0.0.1)
1. Navigate to the ATLAS.BC0.0.1 directory
2. Follow the Go project setup instructions in the README

### Web Frontend Setup (GOFLUTTER)
1. Navigate to the GOFLUTTER directory
2. Run `flutter pub get`
3. Run `flutter run` to start the development server

### Mobile App Setup (cercaend)
1. Navigate to the cercaend directory
2. Run `flutter pub get`
3. Run `flutter run` to start the development server