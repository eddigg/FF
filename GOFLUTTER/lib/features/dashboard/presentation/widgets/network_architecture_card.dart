import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../bloc/dashboard_bloc.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/themes/web_parity_theme.dart';
import '../../../../shared/themes/web_colors.dart';
import '../../../../shared/themes/web_typography.dart';

/// Network architecture card widget matching web implementation
class NetworkArchitectureCard extends StatefulWidget {
  const NetworkArchitectureCard({Key? key}) : super(key: key);

  @override
  State<NetworkArchitectureCard> createState() => _NetworkArchitectureCardState();
}

class _NetworkArchitectureCardState extends State<NetworkArchitectureCard> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('network-architecture-card'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_isVisible) {
          setState(() {
            _isVisible = true;
          });
          
          // Load data when card becomes visible
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              context.read<DashboardBloc>().add(LoadDashboardData());
            }
          });
        }
      },
      child: GlassCard(
        padding: const EdgeInsets.all(WebParityTheme.architectureCardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🌐 Network Architecture',
              style: WebTypography.h2.copyWith(
                color: WebColors.textPrimary,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.01,
              ),
            ),
            const SizedBox(height: WebParityTheme.spacingLg),
            // Grid of architecture cards
            LayoutBuilder(
              builder: (context, constraints) {
                // Determine the number of columns based on screen width
                int crossAxisCount = WebParityTheme.getGridColumns(constraints.maxWidth);
                double spacing = WebParityTheme.getResponsiveSpacing(constraints.maxWidth);
                
                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: spacing,
                  mainAxisSpacing: spacing,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _ArchitectureInfoCard(
                      title: 'Node Types',
                      cardType: ArchitectureCardType.nodeTypes,
                      isVisible: _isVisible,
                    ),
                    _ArchitectureInfoCard(
                      title: 'P2P Protocol',
                      cardType: ArchitectureCardType.p2pProtocol,
                      isVisible: _isVisible,
                    ),
                    _ArchitectureInfoCard(
                      title: 'Consensus Mechanism',
                      cardType: ArchitectureCardType.consensusMechanism,
                      isVisible: _isVisible,
                    ),
                    _ArchitectureInfoCard(
                      title: 'Network Topology',
                      cardType: ArchitectureCardType.networkTopology,
                      isVisible: _isVisible,
                    ),
                    _ArchitectureInfoCard(
                      title: 'Security Features',
                      cardType: ArchitectureCardType.securityFeatures,
                      isVisible: _isVisible,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Types of architecture cards
enum ArchitectureCardType {
  nodeTypes,
  p2pProtocol,
  consensusMechanism,
  networkTopology,
  securityFeatures,
}

/// Individual architecture info card
class _ArchitectureInfoCard extends StatelessWidget {
  final String title;
  final ArchitectureCardType cardType;
  final bool isVisible;

  const _ArchitectureInfoCard({
    Key? key,
    required this.title,
    required this.cardType,
    required this.isVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(WebParityTheme.architectureCardPadding),
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          String content = 'Loading real-time network data...';
          
          // Only show real data when visible and loaded
          if (isVisible && state is DashboardLoaded) {
            final architecture = state.dashboardModel.networkArchitecture;
            
            switch (cardType) {
              case ArchitectureCardType.nodeTypes:
                final nodeTypes = architecture['nodeTypes'] as Map<String, dynamic>?;
                if (nodeTypes != null) {
                  final validators = nodeTypes['validators'] as Map<String, dynamic>?;
                  final observers = nodeTypes['observers'] as Map<String, dynamic>?;
                  final fullNodes = nodeTypes['fullNodes'] as Map<String, dynamic>?;
                  
                  content = 
                    '${validators != null ? 'Validators: ${validators['count']} active (${validators['active']} online)\n' : ''}'
                    '${observers != null ? 'Observers: ${observers['count']} connected\n' : ''}'
                    '${fullNodes != null ? 'Full Nodes: ${fullNodes['count']} total\n' : ''}'
                    '${validators != null ? validators['description'] : ''}';
                }
                break;
                
              case ArchitectureCardType.p2pProtocol:
                final p2p = architecture['p2pProtocol'] as Map<String, dynamic>?;
                if (p2p != null) {
                  content = 
                    '${p2p['type'] != null ? 'Type: ${p2p['type']} v${p2p['version']}\n' : ''}'
                    '${p2p['discovery'] != null ? 'Discovery: ${p2p['discovery']}\n' : ''}'
                    '${p2p['transport'] != null ? 'Transport: ${p2p['transport']}\n' : ''}'
                    '${p2p['description'] ?? ''}';
                }
                break;
                
              case ArchitectureCardType.consensusMechanism:
                final consensus = architecture['consensusMechanism'] as Map<String, dynamic>?;
                if (consensus != null) {
                  content = 
                    '${consensus['type'] != null ? 'Type: ${consensus['type']}\n' : ''}'
                    '${consensus['blockTime'] != null ? 'Block Time: ${consensus['blockTime']}\n' : ''}'
                    '${consensus['finality'] != null ? 'Finality: ${consensus['finality']}\n' : ''}'
                    '${consensus['description'] ?? ''}';
                }
                break;
                
              case ArchitectureCardType.networkTopology:
                final topology = architecture['networkTopology'] as Map<String, dynamic>?;
                if (topology != null) {
                  content = 
                    '${topology['type'] != null ? 'Type: ${topology['type']}\n' : ''}'
                    '${topology['maxPeers'] != null ? 'Max Peers: ${topology['maxPeers']}\n' : ''}'
                    '${topology['connections'] != null ? 'Connections: ${topology['connections']}\n' : ''}'
                    '${topology['description'] ?? ''}';
                }
                break;
                
              case ArchitectureCardType.securityFeatures:
                final security = architecture['securityFeatures'] as Map<String, dynamic>?;
                if (security != null) {
                  content = 
                    '${security['encryption'] != null ? 'Encryption: ${security['encryption']}\n' : ''}'
                    '${security['authentication'] != null ? 'Authentication: ${security['authentication']}\n' : ''}'
                    '${security['rateLimiting'] != null ? 'Rate Limiting: ${security['rateLimiting']}\n' : ''}'
                    '${security['slashing'] != null ? 'Slashing: ${security['slashing']}\n' : ''}'
                    '${security['description'] ?? ''}';
                }
                break;
            }
          } else if (state is DashboardError) {
            content = 'Connection Error: ${state.message}\nMake sure the blockchain is running';
          }
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: WebTypography.h4.copyWith(
                  color: const Color(0xFF1e3c72), // Specific color from web
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: WebParityTheme.spacingSm),
              Text(
                content,
                style: WebTypography.body2.copyWith(
                  color: WebColors.textSecondary,
                  fontSize: 15.2, // 0.95rem
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}