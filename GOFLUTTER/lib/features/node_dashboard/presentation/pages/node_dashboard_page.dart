import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/node_performance_metrics.dart';
import '../widgets/network_overview.dart';
import '../widgets/validator_info.dart';
import '../widgets/sharding_section.dart';
import '../widgets/peer_monitoring_section.dart';
import '../widgets/node_controls_section.dart';
import '../widgets/sharding_management_section.dart';
import '../../../../shared/themes/web_parity_theme.dart';
import '../../../../shared/widgets/web_scaffold.dart';
import '../../../../core/stubs/stub_blocs_clean.dart';

class NodeDashboardPage extends StatefulWidget {
  const NodeDashboardPage({Key? key}) : super(key: key);

  @override
  State<NodeDashboardPage> createState() => _NodeDashboardPageState();
}

class _NodeDashboardPageState extends State<NodeDashboardPage> {
  @override
  void initState() {
    super.initState();
    // Load data when the page is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<NodeDashboardBloc>().add(LoadNodeData());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WebScaffold(
      title: 'Network Dashboard',
      showBackButton: true,
      body: BlocBuilder<NodeDashboardBloc, NodeDashboardState>(
        builder: (context, state) {
          if (state is NodeDashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NodeDashboardLoaded) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(WebParityTheme.containerPadding),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(child: NodePerformanceMetrics()),
                        const SizedBox(width: WebParityTheme.spacingMd),
                        const Expanded(child: NetworkOverview()),
                        const SizedBox(width: WebParityTheme.spacingMd),
                        const Expanded(child: ValidatorInfo()),
                      ],
                    ),
                    const SizedBox(height: WebParityTheme.spacingMd),
                    const ShardingSection(),
                    const SizedBox(height: WebParityTheme.spacingMd),
                    const PeerMonitoringSection(),
                    const SizedBox(height: WebParityTheme.spacingMd),
                    const NodeControlsSection(),
                    const SizedBox(height: WebParityTheme.spacingMd),
                    const ShardingManagementSection(),
                  ],
                ),
              ),
            );
          }

          // Handle error states
          return const Center(child: Text('Failed to load node dashboard'));
        },
      ),
    );
  }
}