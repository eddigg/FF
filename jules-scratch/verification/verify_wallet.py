from playwright.sync_api import Page, expect

def verify_wallet_integration(page: Page):
    # 1. Arrange: Go to the user page.
    page.goto("http://localhost:8000")

    # 2. Act: Navigate to the wallet tab.
    wallet_tab = page.get_by_role("tab", name="Wallet")
    wallet_tab.click()

    # 3. Assert: Check if the wallet widget is visible.
    expect(page.get_by_text("Create Your Wallet")).to_be_visible()

    # 4. Screenshot: Capture the final result for visual verification.
    page.screenshot(path="jules-scratch/verification/wallet_verification.png")
