import 'package:flutter/material.dart';
import '../widgets/create_wallet_tab.dart';
import '../widgets/import_wallet_tab.dart';
import '../../../../shared/widgets/web_scaffold.dart'; // Use WebScaffold instead of AppScaffold
import '../../../../shared/themes/web_parity_theme.dart';
import '../../../../shared/themes/web_colors.dart';
import '../../../../shared/themes/web_typography.dart';

class WalletSetupPage extends StatefulWidget {
  const WalletSetupPage({Key? key}) : super(key: key);

  @override
  State<WalletSetupPage> createState() => _WalletSetupPageState();
}

class _WalletSetupPageState extends State<WalletSetupPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return WebScaffold(
      title: 'Wallet Setup',
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(WebParityTheme.spacingXl),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(WebParityTheme.radiusXl),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                offset: const Offset(0, 10),
                blurRadius: 30,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Wallet Setup',
                style: TextStyle(
                  fontSize: 28.8, // 1.8rem
                  fontWeight: FontWeight.w700,
                  color: WebColors.textPrimary,
                ),
              ),
              const SizedBox(height: WebParityTheme.spacingMd),
              Text(
                'Set up your wallet to access ATLAS B.C.',
                style: WebTypography.body1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: WebParityTheme.spacingXl),
              _buildTabs(),
              const SizedBox(height: WebParityTheme.spacingXl),
              IndexedStack(
                index: _selectedIndex,
                children: const [
                  CreateWalletTab(),
                  ImportWalletTab(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: BoxDecoration(
        color: WebColors.backgroundLight,
        borderRadius: BorderRadius.circular(WebParityTheme.radiusMd),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: WebParityTheme.spacingMd),
                decoration: BoxDecoration(
                  color: _selectedIndex == 0 ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(WebParityTheme.radiusSm),
                  boxShadow: _selectedIndex == 0 ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      offset: const Offset(0, 10),
                      blurRadius: 30,
                    ),
                  ] : null,
                ),
                child: Text(
                  'Create New',
                  style: WebTypography.button.copyWith(
                    color: _selectedIndex == 0 ? WebColors.primary : WebColors.textMuted,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: WebParityTheme.spacingMd),
                decoration: BoxDecoration(
                  color: _selectedIndex == 1 ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(WebParityTheme.radiusSm),
                  boxShadow: _selectedIndex == 1 ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      offset: const Offset(0, 10),
                      blurRadius: 30,
                    ),
                  ] : null,
                ),
                child: Text(
                  'Import Existing',
                  style: WebTypography.button.copyWith(
                    color: _selectedIndex == 1 ? WebColors.primary : WebColors.textMuted,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}