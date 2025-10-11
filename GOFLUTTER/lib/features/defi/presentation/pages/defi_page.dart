import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/stubs/stub_blocs_clean.dart'; // Use stub BLoC instead
import '../widgets/defi_sidebar.dart';
import '../../../../shared/themes/web_parity_theme.dart';
import '../../../../shared/themes/web_typography.dart';
import '../../../../shared/widgets/web_scaffold.dart';
import 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' as glass_card;

class DeFiPage extends StatefulWidget {
  const DeFiPage({super.key});

  @override
  State<DeFiPage> createState() => _DeFiPageState();
}

class _DeFiPageState extends State<DeFiPage> {
  String _selectedSection = 'portfolio';

  void _onSectionSelected(String section) {
    setState(() {
      _selectedSection = section;
    });
  }

  @override
  void initState() {
    super.initState();
    // Load initial data - we don't actually need this for stub implementation
    // but we'll keep it for consistency with the real implementation
  }

  @override
  Widget build(BuildContext context) {
    return WebScaffold(
      title: 'ATLAS DeFi Platform',
      showBackButton: true,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 250,
            child: DeFiSidebar(
              selectedSection: _selectedSection,
              onSectionSelected: _onSectionSelected,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(WebParityTheme.containerPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: WebParityTheme.spacingMd),
                    // Always show some content to test if the page is working
                    _buildMockContent(
                      'Test Content',
                      'If you can see this, the page is working!',
                    ),
                    // Mock content for sections that might be empty
                    if (_selectedSection == 'portfolio')
                      _buildMockContent(
                        'Portfolio Overview',
                        'View your DeFi assets and track performance',
                      ),
                    if (_selectedSection == 'lending')
                      _buildMockContent(
                        'Lending & Borrowing',
                        'Lend your assets or borrow against collateral',
                      ),
                    if (_selectedSection == 'trading')
                      _buildMockContent(
                        'Trading',
                        'Swap tokens and trade on decentralized exchanges',
                      ),
                    if (_selectedSection == 'staking')
                      _buildMockContent(
                        'Staking',
                        'Stake your tokens to earn rewards',
                      ),
                    if (_selectedSection == 'liquidity')
                      _buildMockContent(
                        'Liquidity Pools',
                        'Provide liquidity and earn trading fees',
                      ),
                    if (_selectedSection == 'yield')
                      _buildMockContent(
                        'Yield Farming',
                        'Maximize returns by farming yield from various protocols',
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return glass_card.GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(WebParityTheme.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Decentralized Finance Platform', style: WebTypography.h3),
            const SizedBox(height: WebParityTheme.spacingSm),
            Text(
              'Lend, borrow, trade, and earn with DeFi protocols.',
              style: WebTypography.body1,
            ),
            const SizedBox(height: WebParityTheme.spacingMd),
            Wrap(
              spacing: WebParityTheme.spacingSm,
              runSpacing: WebParityTheme.spacingSm,
              children: [
                _buildFeatureCard('📈 Trading', 'Swap tokens instantly'),
                _buildFeatureCard('🔒 Staking', 'Earn rewards by staking'),
                _buildFeatureCard(
                  '💧 Liquidity',
                  'Provide liquidity for rewards',
                ),
                _buildFeatureCard('🌾 Yield Farming', 'Maximize your returns'),
                _buildFeatureCard('💰 Lending', 'Lend or borrow assets'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(String title, String description) {
    return glass_card.GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(WebParityTheme.navCardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: WebTypography.navCardTitle),
            const SizedBox(height: WebParityTheme.spacingXs),
            Text(description, style: WebTypography.caption),
          ],
        ),
      ),
    );
  }

  Widget _buildMockContent(String title, String description) {
    return glass_card.GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(WebParityTheme.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: WebTypography.h3),
            const SizedBox(height: WebParityTheme.spacingMd),
            Text(description, style: WebTypography.body1),
            const SizedBox(height: WebParityTheme.spacingLg),
            Text(
              'This is a mockup of the $title section. In a real implementation, this would show live DeFi data and allow you to interact with various DeFi protocols.',
              style: WebTypography.body2,
            ),
            const SizedBox(height: WebParityTheme.spacingMd),
            // Add some mock data visualization
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue.withValues(alpha: 0.1),
                    Colors.green.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(WebParityTheme.radiusMd),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
              ),
              child: const Center(
                child: Text(
                  '📊 DeFi Data Visualization\n(Coming Soon)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}