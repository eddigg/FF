import 'package:flutter/material.dart';
import '../widgets/system_overview_section.dart';
import '../widgets/health_checks_section.dart';
import '../widgets/alerts_section.dart';
import '../widgets/performance_trends_section.dart';
import '../widgets/performance_metrics_analytics_section.dart';
import '../widgets/test_environment_section.dart';
import '../widgets/blockchain_backup_section.dart';
import '../widgets/privacy_security_section.dart';
import '../../../../shared/themes/web_parity_theme.dart';
import '../../../../shared/widgets/web_scaffold.dart';

class HealthPage extends StatelessWidget {
  const HealthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WebScaffold(
      title: 'Health Dashboard',
      showBackButton: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(WebParityTheme.containerPadding),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: SystemOverviewSection()),
                  SizedBox(width: WebParityTheme.spacingMd),
                  Expanded(child: HealthChecksSection()),
                  SizedBox(width: WebParityTheme.spacingMd),
                  Expanded(child: AlertsSection()),
                ],
              ),
              SizedBox(height: WebParityTheme.spacingMd),
              PerformanceTrendsSection(),
              SizedBox(height: WebParityTheme.spacingMd),
              PerformanceMetricsAnalyticsSection(),
              SizedBox(height: WebParityTheme.spacingMd),
              TestEnvironmentSection(),
              SizedBox(height: WebParityTheme.spacingMd),
              BlockchainBackupSection(),
              SizedBox(height: WebParityTheme.spacingMd),
              PrivacySecuritySection(),
            ],
          ),
        ),
      ),
    );
  }
}
