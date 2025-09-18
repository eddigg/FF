import 'package:flutter/material.dart';
import '../widgets/governance_overview.dart';
import '../widgets/dao_treasury.dart';
import '../widgets/proposals_section.dart';
import '../../../../shared/themes/web_parity_theme.dart';
import '../../../../shared/widgets/web_scaffold.dart';

class GovernancePage extends StatelessWidget {
  const GovernancePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WebScaffold(
      title: 'Governance',
      showBackButton: true,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(WebParityTheme.containerPadding),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: GovernanceOverview()),
                  SizedBox(width: WebParityTheme.spacingMd),
                  Expanded(child: DAOTreasury()),
                  SizedBox(width: WebParityTheme.spacingMd),
                  Expanded(child: ProposalsSection()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}