# API Contract

This document defines the API contract for the interaction between the ATLAS.BC backend and the Cercaend frontend.

## 1. Get Node Status

Provides a snapshot of the current blockchain node status.

- **Endpoint:** `GET /status`
- **Method:** `GET`
- **Description:** Retrieves key metrics and status information from the running node.
- **Success Response (200 OK):**
  - **Content-Type:** `application/json`
  - **Body:**
    ```json
    {
      "blockHeight": 8675309,
      "txPoolSize": 42,
      "isValidator": true,
      "validatorAddress": "atlasvaloper1abcdefghijklmnopqrstuvwxyz123456",
      "stakeAmount": 1000000,
      "totalValidators": 100,
      "walletBalance": 5000,
      "walletStaked": 1000000,
      "totalBalance": 1005000,
      "mode": "validator"
    }
    ```
