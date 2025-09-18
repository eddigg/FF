# User Flow Integration: Cercaend (Flutter) & ATLAS.BC (Web/Backend)

This document outlines the key user flows for wallet functionality in both the `cercaend` Flutter application and the `ATLAS.BC 0.0.1` web interface, and how they are intended to integrate.

## 1. ATLAS.BC 0.0.1 Web User Flow (Reference: `ATLAS.BC 0.0.1/web/frontend/wallet.html`)

This describes the user's interaction with the standalone web wallet.

**Flow: Wallet Overview & Actions**

1.  **User Accesses Wallet Page:** User navigates to `wallet.html`.
2.  **Connection Status Check:** The page attempts to connect to the blockchain API (e.g., `http://localhost:8080/status`).
3.  **Wallet Information Display:**
    *   If connected, the page fetches and displays the current wallet balance (`/balance?address=...`).
    *   The wallet address is displayed, with options to copy and view QR code.
4.  **Account Management:**
    *   User can select from existing accounts (dropdown).
    *   User can create a new account.
    *   User can export or import an account (via private key/JWK).
    *   User can delete an account.
5.  **Faucet Request:**
    *   User clicks "Request Faucet" button.
    *   A request is sent to the faucet API (`/faucet`).
    *   Balance is updated upon successful response.
6.  **Send Transaction:**
    *   User inputs recipient address, amount, and optional message.
    *   User clicks "Send Transaction".
    *   The transaction is signed locally (client-side).
    *   The signed transaction is submitted to the blockchain (`/submit-transaction`).
    *   Transaction history is updated.
7.  **Transaction History Display:** Recent transactions are fetched (e.g., from `/mempool`) and displayed.
8.  **Validator Registration:** User can register as a validator by providing stake and KYC details.

## 2. Cercaend (Flutter) User Flow (Current State & Planned Integration)

This describes the user's interaction within the `cercaend` Flutter app, focusing on the newly integrated wallet feature.

**Flow: Accessing Wallet & Basic Interactions**

1.  **User Logs In/Accesses User Profile:** User is on the `Userpage` (`cercaend/lib/mainpages/userpage/userpage_widget.dart`).
2.  **User Selects "Wallet" Chip:** User taps the "Wallet" option in the `ChoiceChips` widget.
3.  **Navigate to Wallet Page:** The app navigates to the `WalletWidget` (`cercaend/lib/secondarypages/wallet/wallet_widget.dart`).
4.  **Wallet Information Display (Mocked):**
    *   The `WalletWidget` initializes and calls its internal `ApiClient` (which will now be an in-memory mock).
    *   The `ApiClient` returns mock wallet balance and address.
    *   The UI displays this mock balance and address.
5.  **Faucet Request (Mocked):**
    *   User taps "Request Faucet" button.
    *   The `WalletWidget` calls the `requestFaucet` method on its in-memory `ApiClient`.
    *   The `ApiClient` updates its internal mock balance and returns a success.
    *   The UI updates to reflect the new mock balance.
6.  **Send Transaction (Mocked):**
    *   User inputs recipient address and amount into the `TextFormField`s.
    *   User taps "Send" button.
    *   The `WalletWidget` calls the `sendTransaction` method on its in-memory `ApiClient`.
    *   The `ApiClient` validates the transaction against its internal mock balance, updates mock balances, and adds a mock transaction to its history.
    *   The UI updates (e.g., balance changes, transaction appears in history).
7.  **Transaction History Display (Mocked):** The `WalletWidget` fetches and displays mock transaction history from its in-memory `ApiClient`.

## 3. Connecting the Dots: Integration Strategy

The core strategy is to replicate the *functionality* and *user experience* of the `ATLAS.BC 0.0.1` web wallet within the `cercaend` Flutter app, initially using in-memory mocks, and later connecting to the actual `ATLAS.BC` backend.

*   **UI/UX Consistency:** The `wallet.html` serves as the visual and interaction blueprint. Elements like balance display, address, faucet button, send form, and transaction history will be mirrored in Flutter.
*   **API Contract Adherence:** The `ApiClient` in `cercaend` is designed to call endpoints that match the `ATLAS.BC` backend's API (e.g., `/flutterflow/wallet-info`, `/faucet`, `/flutterflow/send-transaction`).
*   **Mock-First Approach:** By using an in-memory mock within Flutter, we eliminate external dependencies and system-level startup issues, allowing rapid development and testing of the Flutter UI and its interaction logic.
*   **Seamless Transition:** Once the Flutter wallet is fully functional with in-memory mocks, the transition to the real `ATLAS.BC` backend will primarily involve changing the `baseUrl` in `ApiClient` and ensuring the actual backend implements the defined API contract.
*   **Security (Future Consideration):** The `wallet.html` mentions client-side signing and secure storage. While the in-memory mock won't fully implement cryptographic signing, the architecture in Flutter should account for secure storage of private keys and client-side transaction signing when connecting to the real blockchain.

This `flow.md` will serve as a living document, evolving as we implement and refine the integration.
