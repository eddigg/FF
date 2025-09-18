import 'package:flutter/material.dart';
import '../widgets/node_performance_metrics.dart';
import '../widgets/network_overview.dart';
import '../widgets/validator_info.dart';
import '../widgets/sharding_section.dart';
import '../widgets/peer_monitoring_section.dart';
import '../widgets/node_controls_section.dart';
import '../widgets/sharding_management_section.dart';
import '../../../../shared/themes/web_parity_theme.dart';
import '../../../../shared/widgets/web_scaffold.dart';

class NodeDashboardPage extends StatelessWidget {
  const NodeDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WebScaffold(
      title: 'Network Dashboard',
      showBackButton: true,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(WebParityTheme.containerPadding),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: NodePerformanceMetrics()),
                  SizedBox(width: WebParityTheme.spacingMd),
                  Expanded(child: NetworkOverview()),
                  SizedBox(width: WebParityTheme.spacingMd),
                  Expanded(child: ValidatorInfo()),
                ],
              ),
              SizedBox(height: WebParityTheme.spacingMd),
              ShardingSection(),
              SizedBox(height: WebParityTheme.spacingMd),
              PeerMonitoringSection(),
              SizedBox(height: WebParityTheme.spacingMd),
              NodeControlsSection(),
              SizedBox(height: WebParityTheme.spacingMd),
              ShardingManagementSection(),
            ],
          ),
        ),
      ),
    );
  }
}