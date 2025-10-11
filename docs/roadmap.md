Project Cercaend: Mobile Wallet Integration Roadmap
Version: 0.1 Date: [Current Date] Authors: [Your Names Here], Gemini Code Assist

1. Vision & Goal
1.1. Project Statement: To build and release a functional Android application (.apk) for Cercaend. This app will provide each user with a secure, self-custodial wallet integrated directly with the Atlas Blockchain (ATLAS.BC0.0.1), enabling them to view balances and perform transactions.

1.2. Core Principles:

Security First: The user is in full control. Private keys and recovery phrases will be generated and stored exclusively on the user's device. They will never be sent to or stored on any backend server (Firebase or Atlas).
Simplicity: The user experience for creating a wallet, checking a balance, and sending tokens should be intuitive for an average mobile app user, not just a crypto expert.
Direct Integration: We will focus on the direct connection between the cercaend app and the ATLAS.BC0.0.1 backend, shelving the GOFLUTTER project for now to ensure a focused path to the APK.
2. System Architecture
This section clarifies the role of each component.

2.1. Components & Responsibilities:

cercaend (Flutter App):
User Interface: All screens, buttons, and user-facing elements.
User Authentication: Manages login/signup via Firebase Authentication.
Wallet Security: Handles the creation, secure storage (flutter_secure_storage), and use of cryptographic keys for signing transactions.
API Client: Makes all requests to the Atlas Blockchain.
Firebase (Backend-as-a-Service):
User Identity: Manages user accounts (email/password, social logins). It knows who the user is. It does not know about their blockchain wallet.
User Profile Data: Stores app-related user data (e.g., username, profile picture) in Firestore. We will not store wallet addresses here to maintain a separation of concerns.
ATLAS.BC0.0.1 (Go Blockchain):
The Ledger: The single source of truth for all balances and transactions.
The Public Gateway: Exposes a REST API for the cercaend app to query blockchain data (like balances) and submit new, already-signed transactions.
2.2. High-Level Interaction Flow:

mermaid
graph TD
    A[User on Cercaend App] -->|1. Signs Up / Logs In| B(Firebase Auth);
    B --> A;
    A -->|2. Creates/Imports Wallet| C{Local Secure Storage on Device};
    C --> A;
    A -->|3. Requests Balance| D[ATLAS.BC0.0.1 API];
    D --> A;
    A -->|4. Signs Transaction Locally| C;
    A -->|5. Submits Signed TX| D;
3. User Flow & Feature Mapping
This section defines what the user does and how the app responds.

3.1. User Onboarding & Wallet Creation:

User Story: "As a new user, after I create my Cercaend account with my email, I want to be guided to set up my new blockchain wallet so I can start using the app's features."
App Flow:
User signs up/logs in via Firebase.
App checks if a wallet has been created for this user (by checking local secure storage).
If not, the app navigates to the "Wallet Setup" screen.
The app generates a new 12-word recovery phrase and the corresponding private/public keys.
The app securely stores the private key/phrase on the device.
The public wallet address is now available to the app.
3.2. Viewing Wallet & Balance:

User Story: "As a user, I want to go to my Profile screen and clearly see my wallet address and my current token balance."
App Flow:
User navigates to the Profile/Wallet screen.
App retrieves the public wallet address from local secure storage.
App makes an API call to the ATLAS.BC0.0.1 backend: GET /wallet-info?address=[user's public address].
The UI updates with the balance returned from the API.
3.3. Sending Tokens:

User Story: "As a user, I want to be able to send tokens to another person by entering their address and the amount."
App Flow:
User opens the "Send" form.
User inputs the recipient's address and the amount.
App validates the inputs.
App constructs the transaction data.
App retrieves the user's private key from secure storage.
App signs the transaction locally on the device.
App sends the signed transaction in an API call: POST /transactions.
The UI shows a "pending" and then "confirmed" state.
4. Technical Specification: API Contract
This is the technical handshake between the app and the blockchain.

GET /wallet-info

Purpose: Get balance for an address.
Request: ?address=<string>
Success Response (200): {"address": "...", "balance": 123.45}
POST /transactions

Purpose: Submit a new, signed transaction to the network.
Request Body: {"signed_transaction": "<hex_string>"}
Success Response (202): {"status": "pending", "transaction_hash": "0x..."}
GET /transactions

Purpose: Get transaction history for an address.
Request: ?address=<string>&page=1&limit=20
Success Response (200): {"transactions": [{"hash": "...", "from": "...", "to": "...", "amount": 50.0}]}
POST /faucet (For Testnet/Development)

Purpose: Request test tokens.
Request Body: {"address": "<string>"}
Success Response (200): {"message": "100 tokens sent."}
5. Tokenomics & Emission (To Be Defined)
This section is a placeholder for your team to define the economic model of your token.

5.1. Key Questions to Answer:
What is the name and symbol of the token? (e.g., Atlas Token, ATL)
What is the total supply? Is it fixed or inflationary?
How are new tokens created (emission)? (e.g., through mining, staking rewards, or a predefined schedule).
Decision: The logic for token emission must reside in ATLAS.BC0.0.1. It is a core function of the blockchain itself.
What is the purpose of the Faucet? How many tokens does it dispense, and how often can a user request them?
6. Phased Development Plan
This is your step-by-step guide to building the APK.

Phase 1: Foundation & Stability (Focus: cercaend)

Activity: Ensure the cercaend app compiles and runs on an Android emulator/device.
Activity: Verify Firebase login/signup works perfectly.
Activity: Create the basic, non-functional UI screens for Wallet, Wallet Setup, Send, and History within the Profile section.
Phase 2: Local Wallet Logic (Focus: cercaend)

Activity: Integrate a Dart cryptography library (like pointycastle).
Activity: Implement the "Create Wallet" function: generate a key pair and mnemonic.
Activity: Implement secure storage: save the private key using flutter_secure_storage.
Activity: Implement "Import Wallet" from a mnemonic phrase.
Phase 3: Blockchain Connection (Focus: cercaend & ATLAS.BC0.0.1)

Activity: Ensure the ATLAS.BC0.0.1 server is running and accessible from your development machine.
Activity: Implement the ApiClient in cercaend to handle HTTP requests.
Activity: Implement the "View Balance" feature by connecting the UI to the GET /wallet-info endpoint. This is a major milestone as it's your first successful end-to-end connection.
Phase 4: First Transaction (Focus: cercaend & ATLAS.BC0.0.1)

Activity: Implement the transaction signing logic inside cercaend.
Activity: Connect the "Send" UI to the signing logic and the POST /transactions endpoint.
Activity: Test sending a transaction between two wallets (you can run two app instances or hardcode a second address).
Phase 5: Polish & Ship

Activity: Implement the transaction history list using the GET /transactions endpoint.
Activity: Add user-friendly loading indicators and error messages everywhere.
Activity: Test the complete user journey on a real Android device.
Activity: Follow Flutter's official guide to generate the signed APK.
You now have a solid framework. You can copy this into a shared document (like Google Docs or a ROADMAP.md file in your project) and start filling in the details and tracking your progress. This plan is direct, minimizes risk, and focuses every activity on your primary goal: a working Android app.

