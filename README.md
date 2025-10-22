# FF Project Monorepo

This monorepo contains the `cercaend` Flutter frontend application and the `atlas-blockchain` Go backend application, along with shared packages and scripts.

## Structure

*   **`apps/`**: Contains the main applications.
    *   `cercaend/`: The Flutter frontend application.
    *   `blockchain/`: The Go blockchain backend application.
*   **`packages/`**: Contains shared code and components used across applications.
    *   `api/`: Shared API definitions (e.g., gRPC `.proto` files, OpenAPI specifications).
    *   `models/`: Shared data models (e.g., Go structs, Dart classes).
    *   `utils/`: General utility functions.
    *   `api-gateway/`: API Gateway related code.
    *   `apis/`: Other API related code.
    *   `bridges/`: Bridge implementations.
    *   `flutter-plugin/`: Flutter plugin packages.
    *   `sdk/`: SDKs for interacting with the blockchain.
    *   `webhooks/`: Webhook related code.
    *   `wallets/`: Wallet related packages.
    *   `core/`: Core shared logic.
    *   `crypto/`: Cryptography related utilities.
    *   `ui/`: Shared UI components.
    *   `data/`: Data-related packages (analytics, blockchain data, intelligence).
    *   `config/`: Configuration related packages (environments).
    *   `mock-server/`: Mock server implementations.
*   **`scripts/`**: Contains scripts for building, testing, deployment, and other operational tasks.
    *   `deployment/`: Deployment scripts.
    *   `monitoring/`: Monitoring scripts.
    *   `scaling/`: Scaling scripts.
    *   `security/`: Security related scripts.
    *   `reorganize.ps1`: The script used for initial reorganization.
*   **`docs/`**: Project documentation.
*   **`tools/`**: Development tools and configurations.
*   **`experiments/`**: Experimental code or features.
*   **`samples/`**: Example code or usage.
*   **`docker-compose.yml`**: Docker Compose configuration for the project.
*   **`env.example`**: Example environment variables.

## Getting Started

Refer to the `README.md` files within each application (`apps/cercaend/README.md`, `apps/blockchain/README.md`) for specific instructions on how to set up and run each application.

## Development

### Firebase and Supabase

The `cercaend` application uses both Firebase and Supabase. Ensure that the necessary credentials and configurations are in place for both services. We will gradually clean up legacy structures and ensure smooth integration.

### Components and UI Logic

We will continue to work on developing shared components, UI logic, and design for `cercaend` to ensure seamless communication with the `atlas-blockchain` API. The goal is to create a robust bridge between the frontend and the blockchain.