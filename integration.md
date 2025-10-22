# ROOTs ARCHITECTUR

FF/
├── apps/                  # All application executables
│   ├── cercaend/          # Flutter application
│   │   ├── android/        # Android platform files
│   │   ├── ios/            # iOS platform files
│   │   ├── lib/            # Dart source code
│   │   │   ├── blockchain/ # Blockchain integration
│   │   │   └── ...         # Existing Cercaend code
│   │   ├── web/            # Web platform files
│   │   └── ...             # Flutter config files
│   └── blockchain/        # Go blockchain node
│       ├── cmd/            # Blockchain entry points
│       ├── internal/       # Private blockchain code
│       ├── pkg/            # Public blockchain libraries
│       └── ...             # Blockchain config files
├── shared/                # Cross-project shared code
│   ├── models/            # Shared data models
│   │   ├── dart/           # Dart models
│   │   └── go/             # Go models
│   ├── proto/              # Protocol buffers
│   └── utils/              # Shared utilities
├── integrations/          # Integration components
│   ├── api-gateway/       # Unified API layer
│   ├── flutter-plugin/     # Flutter<->Blockchain bridge
│   └── docs/               # Integration documentation
├── scripts/               # Build and deployment scripts
│   ├── build-all.sh        # Build both projects
│   ├── run-dev.sh          # Run development environment
│   └── test-integration.sh  # Integration tests
├── docs/                  # Project documentation
│   ├── architecture.md     # System architecture
│   ├── integration.md      # Integration guide
│   ├── development.md      # Development guide
│   └── ...                 # Other documentation
├── config/                # Configuration files
│   ├── docker-compose.yml  # Development environment
│   ├── env.example         # Environment variable template
│   └── ...                 # Other config files
├── backups/               # Database backups
│   └── blockchain/         # Blockchain state backups
└── logs/                  # Log files
    ├── blockchain/         # Blockchain logs
    └── api-gateway/         # API gateway logs