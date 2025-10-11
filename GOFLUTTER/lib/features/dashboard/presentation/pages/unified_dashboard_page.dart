import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UnifiedDashboardPage extends StatelessWidget {
  const UnifiedDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    print('🏠 Dashboard page is building...');
    print('🔍 Current route in dashboard: ${GoRouterState.of(context).uri}');

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        title: const Text('🔗 ATLAS B.C. Dashboard'),
        backgroundColor: const Color(0xFF667EEA),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeSection(),
                const SizedBox(height: 30),
                _buildFeaturesSection(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🎉 Welcome to ATLAS Blockchain',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Your decentralized network is ready. Explore all features below!',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 20),
                SizedBox(width: 10),
                Text(
                  'Connected to ATLAS.BC Network',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Explore Blockchain Features',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            // Responsive grid: 2 columns on mobile, 3-4 on larger screens
            int crossAxisCount = constraints.maxWidth > 800
                ? 4
                : constraints.maxWidth > 600
                ? 3
                : 2;

            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.0,
              children: _getFeatureCards(context),
            );
          },
        ),
      ],
    );
  }

  List<Widget> _getFeatureCards(BuildContext context) {
    final features = [
      FeatureCardData(
        icon: '💼',
        title: 'Wallet',
        description: 'Manage your ATLAS tokens and view balance',
        route: '/wallet',
        color: Colors.blue,
      ),
      FeatureCardData(
        icon: '🔍',
        title: 'Explorer',
        description: 'Browse blocks and transactions',
        route: '/explorer',
        color: Colors.purple,
      ),
      FeatureCardData(
        icon: '🌐',
        title: 'Network',
        description: 'Monitor nodes and network health',
        route: '/node-dashboard',
        color: Colors.cyan,
      ),
      FeatureCardData(
        icon: '🏥',
        title: 'Health',
        description: 'System health and performance metrics',
        route: '/health',
        color: Colors.teal,
      ),
      FeatureCardData(
        icon: '🏛️',
        title: 'Governance',
        description: 'Vote on proposals and participate',
        route: '/governance',
        color: Colors.orange,
      ),
      FeatureCardData(
        icon: '💰',
        title: 'DeFi',
        description: 'Lending, borrowing, and trading',
        route: '/defi',
        color: Colors.green,
      ),
      FeatureCardData(
        icon: '⚡',
        title: 'Contracts',
        description: 'Deploy and interact with smart contracts',
        route: '/contracts',
        color: Colors.red,
      ),
      FeatureCardData(
        icon: '📱',
        title: 'Social',
        description: 'Connect with the ATLAS community',
        route: '/social',
        color: Colors.pink,
      ),
      FeatureCardData(
        icon: '👤',
        title: 'Identity',
        description: 'Manage your blockchain identity',
        route: '/identity',
        color: Colors.indigo,
      ),
    ];

    return features
        .map((feature) => _buildFeatureCard(context, feature))
        .toList();
  }

  Widget _buildFeatureCard(BuildContext context, FeatureCardData feature) {
    return GestureDetector(
      onTap: () => context.go(feature.route),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: feature.color.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: feature.color.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: feature.color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(feature.icon, style: const TextStyle(fontSize: 24)),
            ),
            const SizedBox(height: 12),
            Text(
              feature.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              feature.description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureCardData {
  final String icon;
  final String title;
  final String description;
  final String route;
  final Color color;

  FeatureCardData({
    required this.icon,
    required this.title,
    required this.description,
    required this.route,
    required this.color,
  });
}