import 'package:flutter/material.dart';
import '../widgets/create_wallet_tab.dart';
import '../widgets/import_wallet_tab.dart';

class WalletSetupPage extends StatefulWidget {
  const WalletSetupPage({super.key});

  @override
  State<WalletSetupPage> createState() => _WalletSetupPageState();
}

class _WalletSetupPageState extends State<WalletSetupPage> {
  int _selectedIndex = 0;

  void _goBack() {
    // Navigate back to intro page
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // To allow gradient to show through
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 60,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const _Header(),
                  const SizedBox(height: 30),
                  _buildTabs(),
                  const SizedBox(height: 30),
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
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          _buildTabItem(0, 'Create New'),
          _buildTabItem(1, 'Import Existing'),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String text) {
    final bool isActive = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: const Color(0xFF4299E1).withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ]
                : [],
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isActive ? const Color(0xFF4299E1) : const Color(0xFF718096),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text(
          '🔐 Wallet Setup',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4A5568),
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Set up your wallet to access ATLAS B.C.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF718096),
          ),
        ),
      ],
    );
  }
}