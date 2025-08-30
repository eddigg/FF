# Wallet & Identity Integration Framework

This document outlines the logical and technical framework for integrating user identity, wallet management, and transactions between the Cercaend Flutter application and the ATLAS.BC backend.

### **Analysis of Core Components**

-   **Cercaend Frontend:** Utilizes Firebase for user authentication (sign-up/login). User data, including the associated blockchain wallet address, is intended to be stored in Firestore. The UI contains placeholders for wallet functionality (`WalletpageWidget`, `WalletWidget`).
-   **ATLAS.BC Backend:** Provides a comprehensive API for this workflow:
    -   `/identity/create`: To create a user's decentralized identity, linking it to their primary wallet address.
    -   `/flutterflow/connect-wallet`: A crucial endpoint to handle wallet creation (generating a new private/public key pair) and importing existing wallets.
    -   `/flutterflow/wallet-info`: To fetch on-chain data like balance, nonce, and transaction history.
    -   `/faucet`: To request test tokens for a given address.
    -   `/flutterflow/send-transaction`: To submit a signed transaction to the network.

### **End-to-End Implementation Framework**

Here is the clinical, step-by-step process to achieve full functionality:

**1. User Registration & Wallet Creation:**
   - **Trigger:** User completes sign-up via the existing Firebase authentication UI.
   - **Action (Frontend):**
     1.  On successful Firebase registration, immediately call the backend: `POST /flutterflow/connect-wallet` with `{"action": "create"}`.
     2.  **Mock Response:** `{"success": true, "data": {"address": "0xABC...", "privateKey": "mock_private_key", "sessionToken": "mock_token"}}`.
     3.  **Secure Storage:** The received `privateKey` **must** be stored securely on the device using a package like `flutter_secure_storage`. The `address` and `sessionToken` are stored in the app's state (e.g., FFAppState).
     4.  **Firestore Update:** The user's public wallet `address` is saved to their corresponding user document in Firestore to link their Firebase UID with their wallet.

**2. User Login:**
   - **Trigger:** User logs in with Firebase.
   - **Action (Frontend):**
     1.  Fetch the user's document from Firestore to retrieve their saved wallet `address`.
     2.  Retrieve the `privateKey` from secure storage.
     3.  The user is now authenticated and their wallet is active in the app.

**3. Wallet Tab - Account Status:**
   - **Trigger:** User navigates to the "Account" section within the Wallet tab.
   - **Action (Frontend):**
     1.  The UI should be driven by a `FutureBuilder` that calls a new `apiClient.getWalletInfo()` method.
     2.  This method calls: `GET /flutterflow/wallet-info?address=<user_address>`.
     3.  **Mock Response:** `{"success": true, "data": {"address": "0xABC...", "balance": 1000, "nonce": 1, "recentTransactions": []}}`.
     4.  The UI renders the balance and other information from the response.

**4. Faucet Feature:**
   - **Trigger:** User clicks a "Request Test Tokens" button within the Wallet UI.
   - **Action (Frontend):**
     1.  Call the backend: `POST /faucet` with `{"address": "<user_address>"}`.
     2.  **Mock Response:** `{"success": true, "message": "1000 tokens credited"}`.
     3.  On success, trigger a refresh of the wallet information (re-call `getWalletInfo()`) to display the updated balance.

**5. Send Transaction Feature:**
   - **Trigger:** User fills out a "Send" form (recipient address, amount) and clicks "Submit".
   - **Action (Frontend):**
     1.  Construct a JSON object for the transaction.
     2.  **Client-Side Signing (Critical):** Use the `privateKey` retrieved from secure storage to sign the transaction object. This is a critical security step that must happen on the device, not the server. Libraries like `web3dart` or `etherdart` can perform this cryptographic operation.
     3.  Call the backend: `POST /flutterflow/send-transaction` with the transaction data, including the generated `signature`.
     4.  **Mock Response:** `{"success": true, "data": {"transactionHash": "0x123..."}}`.
     5.  Display the transaction hash to the user and trigger a refresh of the wallet's transaction history.
