# End-to-End Integration Plan: ATLAS.BC + Cercaend

This document outlines the 10 essential steps to connect the `ATLAS.BC` Go backend with the `cercaend` Flutter frontend for full end-to-end functionality.

1.  **Analyze Backend API Surface:** Inspect `ATLAS.BC 0.0.1/internal/api/api.go` to identify all existing HTTP endpoints and their handlers. This will determine the backend's current capabilities.

2.  **Analyze Frontend Code Structure:** List the contents of the `cercaend/lib/` directory, focusing on `main.dart`, `app_state.dart`, and the `backend` subdirectory to understand the app's entry point, state management, and data handling logic.

3.  **Run Backend and Identify Port:** Execute the `blockchain.exe` server and examine its output to confirm it runs successfully and to identify the network port it listens on for API requests.

4.  **Define API Contract:** Based on the analysis, create a simple `API_CONTRACT.md` file specifying the exact endpoints and JSON data structures the frontend will use. We will start with a single endpoint, for instance, `/api/v1/network/stats`, to get basic blockchain info.

5.  **Implement Backend API Endpoint:** If the required endpoint from the contract doesn't exist, create it in `api.go`. This includes the route registration and the handler function to return mock or real blockchain data.

6.  **Create Frontend API Client:** Create a new file, `cercaend/lib/backend/api_client.dart`, containing a class to handle HTTP requests to the Go backend. This client will have a method to call the `/api/v1/network/stats` endpoint.

7.  **Integrate API Client into Frontend UI:** Modify the main page widget in the Flutter app to call the new `api_client.dart` method when the screen loads. The fetched data will be stored in the app's state.

8.  **Display Backend Data in UI:** Update a Text widget on the main page to display the blockchain statistics retrieved from the backend, confirming the data flow.

9.  **Run Both Applications Simultaneously:** Launch the Go backend server and the Flutter frontend application to prepare for live testing.

10. **Verify End-to-End Data Flow:** Confirm that the frontend successfully calls the backend, retrieves the JSON data, and displays it correctly in the UI. This validates the complete end-to-end connection.
