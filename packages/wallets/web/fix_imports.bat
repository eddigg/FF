@echo off
echo Fixing import paths...

REM Fix all features/shared/widgets/common_widgets.dart imports
powershell -Command "(Get-Content 'lib/features/health/presentation/widgets/test_environment_section.dart') -replace 'package:atlas_blockchain_flutter/features/shared/widgets/common_widgets.dart', 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' | Set-Content 'lib/features/health/presentation/widgets/test_environment_section.dart'"

powershell -Command "(Get-Content 'lib/features/health/presentation/widgets/system_overview_section.dart') -replace 'package:atlas_blockchain_flutter/features/shared/widgets/common_widgets.dart', 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' | Set-Content 'lib/features/health/presentation/widgets/system_overview_section.dart'"

powershell -Command "(Get-Content 'lib/features/health/presentation/widgets/privacy_security_section.dart') -replace 'package:atlas_blockchain_flutter/features/shared/widgets/common_widgets.dart', 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' | Set-Content 'lib/features/health/presentation/widgets/privacy_security_section.dart'"

powershell -Command "(Get-Content 'lib/features/health/presentation/widgets/performance_trends_section.dart') -replace 'package:atlas_blockchain_flutter/features/shared/widgets/common_widgets.dart', 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' | Set-Content 'lib/features/health/presentation/widgets/performance_trends_section.dart'"

powershell -Command "(Get-Content 'lib/features/health/presentation/widgets/performance_metrics_analytics_section.dart') -replace 'package:atlas_blockchain_flutter/features/shared/widgets/common_widgets.dart', 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' | Set-Content 'lib/features/health/presentation/widgets/performance_metrics_analytics_section.dart'"

powershell -Command "(Get-Content 'lib/features/health/presentation/widgets/blockchain_backup_section.dart') -replace 'package:atlas_blockchain_flutter/features/shared/widgets/common_widgets.dart', 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' | Set-Content 'lib/features/health/presentation/widgets/blockchain_backup_section.dart'"

powershell -Command "(Get-Content 'lib/features/health/presentation/widgets/alerts_section.dart') -replace 'package:atlas_blockchain_flutter/features/shared/widgets/common_widgets.dart', 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' | Set-Content 'lib/features/health/presentation/widgets/alerts_section.dart'"

powershell -Command "(Get-Content 'lib/features/health/presentation/widgets/health_checks_section.dart') -replace 'package:atlas_blockchain_flutter/features/shared/widgets/common_widgets.dart', 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' | Set-Content 'lib/features/health/presentation/widgets/health_checks_section.dart'"

powershell -Command "(Get-Content 'lib/features/wallet/presentation/pages/wallet_page.dart') -replace 'package:atlas_blockchain_flutter/features/shared/widgets/common_widgets.dart', 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' | Set-Content 'lib/features/wallet/presentation/pages/wallet_page.dart'"

powershell -Command "(Get-Content 'lib/features/social/presentation/widgets/social_sidebar.dart') -replace 'package:atlas_blockchain_flutter/features/shared/widgets/common_widgets.dart', 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' | Set-Content 'lib/features/social/presentation/widgets/social_sidebar.dart'"

powershell -Command "(Get-Content 'lib/features/social/presentation/widgets/social_right_sidebar.dart') -replace 'package:atlas_blockchain_flutter/features/shared/widgets/common_widgets.dart', 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' | Set-Content 'lib/features/social/presentation/widgets/social_right_sidebar.dart'"

powershell -Command "(Get-Content 'lib/features/social/presentation/widgets/social_feed.dart') -replace 'package:atlas_blockchain_flutter/features/shared/widgets/common_widgets.dart', 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' | Set-Content 'lib/features/social/presentation/widgets/social_feed.dart'"

powershell -Command "(Get-Content 'lib/features/social/presentation/widgets/create_post_section.dart') -replace 'package:atlas_blockchain_flutter/features/shared/widgets/common_widgets.dart', 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' | Set-Content 'lib/features/social/presentation/widgets/create_post_section.dart'"

powershell -Command "(Get-Content 'lib/features/social/presentation/widgets/content_moderation_section.dart') -replace 'package:atlas_blockchain_flutter/features/shared/widgets/common_widgets.dart', 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' | Set-Content 'lib/features/social/presentation/widgets/content_moderation_section.dart'"

powershell -Command "(Get-Content 'lib/features/node_dashboard/presentation/widgets/network_overview.dart') -replace 'package:atlas_blockchain_flutter/features/shared/widgets/common_widgets.dart', 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' | Set-Content 'lib/features/node_dashboard/presentation/widgets/network_overview.dart'"

powershell -Command "(Get-Content 'lib/features/node_dashboard/presentation/widgets/peer_monitoring_section.dart') -replace 'package:atlas_blockchain_flutter/features/shared/widgets/common_widgets.dart', 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' | Set-Content 'lib/features/node_dashboard/presentation/widgets/peer_monitoring_section.dart'"

powershell -Command "(Get-Content 'lib/features/node_dashboard/presentation/widgets/validator_info.dart') -replace 'package:atlas_blockchain_flutter/features/shared/widgets/common_widgets.dart', 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' | Set-Content 'lib/features/node_dashboard/presentation/widgets/validator_info.dart'"

powershell -Command "(Get-Content 'lib/features/node_dashboard/presentation/widgets/node_controls_section.dart') -replace 'package:atlas_blockchain_flutter/features/shared/widgets/common_widgets.dart', 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' | Set-Content 'lib/features/node_dashboard/presentation/widgets/node_controls_section.dart'"

powershell -Command "(Get-Content 'lib/features/identity/presentation/widgets/identity_sidebar.dart') -replace 'package:atlas_blockchain_flutter/features/shared/widgets/common_widgets.dart', 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' | Set-Content 'lib/features/identity/presentation/widgets/identity_sidebar.dart'"

powershell -Command "(Get-Content 'lib/features/identity/presentation/widgets/privacy_section.dart') -replace 'package:atlas_blockchain_flutter/features/shared/widgets/common_widgets.dart', 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' | Set-Content 'lib/features/identity/presentation/widgets/privacy_section.dart'"

powershell -Command "(Get-Content 'lib/features/identity/presentation/widgets/kyc_section.dart') -replace 'package:atlas_blockchain_flutter/features/shared/widgets/common_widgets.dart', 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' | Set-Content 'lib/features/identity/presentation/widgets/kyc_section.dart'"

powershell -Command "(Get-Content 'lib/features/governance/presentation/widgets/proposals_section.dart') -replace 'package:atlas_blockchain_flutter/features/shared/widgets/common_widgets.dart', 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' | Set-Content 'lib/features/governance/presentation/widgets/proposals_section.dart'"

powershell -Command "(Get-Content 'lib/features/governance/presentation/widgets/governance_overview.dart') -replace 'package:atlas_blockchain_flutter/features/shared/widgets/common_widgets.dart', 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' | Set-Content 'lib/features/governance/presentation/widgets/governance_overview.dart'"

powershell -Command "(Get-Content 'lib/features/governance/presentation/widgets/dao_treasury.dart') -replace 'package:atlas_blockchain_flutter/features/shared/widgets/common_widgets.dart', 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' | Set-Content 'lib/features/governance/presentation/widgets/dao_treasury.dart'"

powershell -Command "(Get-Content 'lib/features/explorer/presentation/pages/explorer_page.dart') -replace 'package:atlas_blockchain_flutter/features/shared/widgets/common_widgets.dart', 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' | Set-Content 'lib/features/explorer/presentation/pages/explorer_page.dart'"

powershell -Command "(Get-Content 'lib/features/defi/presentation/widgets/liquidity_section.dart') -replace 'package:atlas_blockchain_flutter/features/shared/widgets/common_widgets.dart', 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' | Set-Content 'lib/features/defi/presentation/widgets/liquidity_section.dart'"

powershell -Command "(Get-Content 'lib/features/defi/presentation/widgets/portfolio_section.dart') -replace 'package:atlas_blockchain_flutter/features/shared/widgets/common_widgets.dart', 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' | Set-Content 'lib/features/defi/presentation/widgets/portfolio_section.dart'"

powershell -Command "(Get-Content 'lib/features/defi/presentation/widgets/lending_section.dart') -replace 'package:atlas_blockchain_flutter/features/shared/widgets/common_widgets.dart', 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' | Set-Content 'lib/features/defi/presentation/widgets/lending_section.dart'"

powershell -Command "(Get-Content 'lib/features/contracts/presentation/widgets/contract_deployment_section.dart') -replace 'package:atlas_blockchain_flutter/features/shared/widgets/common_widgets.dart', 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' | Set-Content 'lib/features/contracts/presentation/widgets/contract_deployment_section.dart'"

powershell -Command "(Get-Content 'lib/features/contracts/presentation/widgets/contract_examples_section.dart') -replace 'package:atlas_blockchain_flutter/features/shared/widgets/common_widgets.dart', 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' | Set-Content 'lib/features/contracts/presentation/widgets/contract_examples_section.dart'"

powershell -Command "(Get-Content 'lib/features/contracts/presentation/widgets/contract_interaction_section.dart') -replace 'package:atlas_blockchain_flutter/features/shared/widgets/common_widgets.dart', 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' | Set-Content 'lib/features/contracts/presentation/widgets/contract_interaction_section.dart'"

powershell -Command "(Get-Content 'lib/features/contracts/presentation/widgets/deployed_contracts_section.dart') -replace 'package:atlas_blockchain_flutter/features/shared/widgets/common_widgets.dart', 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' | Set-Content 'lib/features/contracts/presentation/widgets/deployed_contracts_section.dart'"

echo Fixed features/shared imports, now fixing src/shared imports...

REM Fix all src/shared/themes/web_parity_theme.dart imports
powershell -Command "(Get-Content 'lib/features/wallet/presentation/pages/wallet_page.dart') -replace 'package:atlas_blockchain_flutter/src/shared/themes/web_parity_theme.dart', 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart' | Set-Content 'lib/features/wallet/presentation/pages/wallet_page.dart'"

powershell -Command "(Get-Content 'lib/features/social/presentation/widgets/create_post_section.dart') -replace 'package:atlas_blockchain_flutter/src/shared/themes/web_parity_theme.dart', 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart' | Set-Content 'lib/features/social/presentation/widgets/create_post_section.dart'"

powershell -Command "(Get-Content 'lib/features/social/presentation/widgets/social_right_sidebar.dart') -replace 'package:atlas_blockchain_flutter/src/shared/themes/web_parity_theme.dart', 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart' | Set-Content 'lib/features/social/presentation/widgets/social_right_sidebar.dart'"

powershell -Command "(Get-Content 'lib/features/social/presentation/widgets/social_sidebar.dart') -replace 'package:atlas_blockchain_flutter/src/shared/themes/web_parity_theme.dart', 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart' | Set-Content 'lib/features/social/presentation/widgets/social_sidebar.dart'"

powershell -Command "(Get-Content 'lib/features/social/presentation/widgets/trending_topics_section.dart') -replace 'package:atlas_blockchain_flutter/src/shared/themes/web_parity_theme.dart', 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart' | Set-Content 'lib/features/social/presentation/widgets/trending_topics_section.dart'"

powershell -Command "(Get-Content 'lib/features/social/presentation/widgets/social_feed.dart') -replace 'package:atlas_blockchain_flutter/src/shared/themes/web_parity_theme.dart', 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart' | Set-Content 'lib/features/social/presentation/widgets/social_feed.dart'"

powershell -Command "(Get-Content 'lib/features/social/presentation/widgets/content_moderation_section.dart') -replace 'package:atlas_blockchain_flutter/src/shared/themes/web_parity_theme.dart', 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart' | Set-Content 'lib/features/social/presentation/widgets/content_moderation_section.dart'"

powershell -Command "(Get-Content 'lib/features/node_dashboard/presentation/widgets/network_overview.dart') -replace 'package:atlas_blockchain_flutter/src/shared/themes/web_parity_theme.dart', 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart' | Set-Content 'lib/features/node_dashboard/presentation/widgets/network_overview.dart'"

powershell -Command "(Get-Content 'lib/features/node_dashboard/presentation/widgets/validator_info.dart') -replace 'package:atlas_blockchain_flutter/src/shared/themes/web_parity_theme.dart', 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart' | Set-Content 'lib/features/node_dashboard/presentation/widgets/validator_info.dart'"

powershell -Command "(Get-Content 'lib/features/node_dashboard/presentation/widgets/node_performance_metrics.dart') -replace 'package:atlas_blockchain_flutter/src/shared/themes/web_parity_theme.dart', 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart' | Set-Content 'lib/features/node_dashboard/presentation/widgets/node_performance_metrics.dart'"

powershell -Command "(Get-Content 'lib/features/node_dashboard/presentation/widgets/node_controls_section.dart') -replace 'package:atlas_blockchain_flutter/src/shared/themes/web_parity_theme.dart', 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart' | Set-Content 'lib/features/node_dashboard/presentation/widgets/node_controls_section.dart'"

powershell -Command "(Get-Content 'lib/features/node_dashboard/presentation/widgets/peer_monitoring_section.dart') -replace 'package:atlas_blockchain_flutter/src/shared/themes/web_parity_theme.dart', 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart' | Set-Content 'lib/features/node_dashboard/presentation/widgets/peer_monitoring_section.dart'"

powershell -Command "(Get-Content 'lib/features/health/presentation/widgets/alerts_section.dart') -replace 'package:atlas_blockchain_flutter/src/shared/themes/web_parity_theme.dart', 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart' | Set-Content 'lib/features/health/presentation/widgets/alerts_section.dart'"

powershell -Command "(Get-Content 'lib/features/health/presentation/widgets/performance_trends_section.dart') -replace 'package:atlas_blockchain_flutter/src/shared/themes/web_parity_theme.dart', 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart' | Set-Content 'lib/features/health/presentation/widgets/performance_trends_section.dart'"

powershell -Command "(Get-Content 'lib/features/health/presentation/widgets/system_overview_section.dart') -replace 'package:atlas_blockchain_flutter/src/shared/themes/web_parity_theme.dart', 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart' | Set-Content 'lib/features/health/presentation/widgets/system_overview_section.dart'"

powershell -Command "(Get-Content 'lib/features/health/presentation/widgets/privacy_security_section.dart') -replace 'package:atlas_blockchain_flutter/src/shared/themes/web_parity_theme.dart', 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart' | Set-Content 'lib/features/health/presentation/widgets/privacy_security_section.dart'"

powershell -Command "(Get-Content 'lib/features/health/presentation/widgets/test_environment_section.dart') -replace 'package:atlas_blockchain_flutter/src/shared/themes/web_parity_theme.dart', 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart' | Set-Content 'lib/features/health/presentation/widgets/test_environment_section.dart'"

powershell -Command "(Get-Content 'lib/features/health/presentation/widgets/performance_metrics_analytics_section.dart') -replace 'package:atlas_blockchain_flutter/src/shared/themes/web_parity_theme.dart', 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart' | Set-Content 'lib/features/health/presentation/widgets/performance_metrics_analytics_section.dart'"

powershell -Command "(Get-Content 'lib/features/health/presentation/widgets/health_checks_section.dart') -replace 'package:atlas_blockchain_flutter/src/shared/themes/web_parity_theme.dart', 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart' | Set-Content 'lib/features/health/presentation/widgets/health_checks_section.dart'"

powershell -Command "(Get-Content 'lib/features/health/presentation/widgets/blockchain_backup_section.dart') -replace 'package:atlas_blockchain_flutter/src/shared/themes/web_parity_theme.dart', 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart' | Set-Content 'lib/features/health/presentation/widgets/blockchain_backup_section.dart'"

powershell -Command "(Get-Content 'lib/features/governance/presentation/widgets/proposals_section.dart') -replace 'package:atlas_blockchain_flutter/src/shared/themes/web_parity_theme.dart', 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart' | Set-Content 'lib/features/governance/presentation/widgets/proposals_section.dart'"

powershell -Command "(Get-Content 'lib/features/governance/presentation/widgets/dao_treasury.dart') -replace 'package:atlas_blockchain_flutter/src/shared/themes/web_parity_theme.dart', 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart' | Set-Content 'lib/features/governance/presentation/widgets/dao_treasury.dart'"

powershell -Command "(Get-Content 'lib/features/governance/presentation/widgets/governance_overview.dart') -replace 'package:atlas_blockchain_flutter/src/shared/themes/web_parity_theme.dart', 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart' | Set-Content 'lib/features/governance/presentation/widgets/governance_overview.dart'"

powershell -Command "(Get-Content 'lib/features/defi/presentation/widgets/yield_farming_section.dart') -replace 'package:atlas_blockchain_flutter/src/shared/themes/web_parity_theme.dart', 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart' | Set-Content 'lib/features/defi/presentation/widgets/yield_farming_section.dart'"

powershell -Command "(Get-Content 'lib/features/defi/presentation/widgets/trading_section.dart') -replace 'package:atlas_blockchain_flutter/src/shared/themes/web_parity_theme.dart', 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart' | Set-Content 'lib/features/defi/presentation/widgets/trading_section.dart'"

powershell -Command "(Get-Content 'lib/features/defi/presentation/widgets/staking_section.dart') -replace 'package:atlas_blockchain_flutter/src/shared/themes/web_parity_theme.dart', 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart' | Set-Content 'lib/features/defi/presentation/widgets/staking_section.dart'"

powershell -Command "(Get-Content 'lib/features/defi/presentation/widgets/portfolio_section.dart') -replace 'package:atlas_blockchain_flutter/src/shared/themes/web_parity_theme.dart', 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart' | Set-Content 'lib/features/defi/presentation/widgets/portfolio_section.dart'"

powershell -Command "(Get-Content 'lib/features/defi/presentation/widgets/liquidity_section.dart') -replace 'package:atlas_blockchain_flutter/src/shared/themes/web_parity_theme.dart', 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart' | Set-Content 'lib/features/defi/presentation/widgets/liquidity_section.dart'"

powershell -Command "(Get-Content 'lib/features/defi/presentation/widgets/lending_section.dart') -replace 'package:atlas_blockchain_flutter/src/shared/themes/web_parity_theme.dart', 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart' | Set-Content 'lib/features/defi/presentation/widgets/lending_section.dart'"

powershell -Command "(Get-Content 'lib/features/contracts/presentation/widgets/contract_deployment_section.dart') -replace 'package:atlas_blockchain_flutter/src/shared/themes/web_parity_theme.dart', 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart' | Set-Content 'lib/features/contracts/presentation/widgets/contract_deployment_section.dart'"

powershell -Command "(Get-Content 'lib/features/contracts/presentation/widgets/contract_interaction_section.dart') -replace 'package:atlas_blockchain_flutter/src/shared/themes/web_parity_theme.dart', 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart' | Set-Content 'lib/features/contracts/presentation/widgets/contract_interaction_section.dart'"

powershell -Command "(Get-Content 'lib/features/contracts/presentation/widgets/contract_examples_section.dart') -replace 'package:atlas_blockchain_flutter/src/shared/themes/web_parity_theme.dart', 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart' | Set-Content 'lib/features/contracts/presentation/widgets/contract_examples_section.dart'"

powershell -Command "(Get-Content 'lib/features/contracts/presentation/widgets/deployed_contracts_section.dart') -replace 'package:atlas_blockchain_flutter/src/shared/themes/web_parity_theme.dart', 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart' | Set-Content 'lib/features/contracts/presentation/widgets/deployed_contracts_section.dart'"

echo Import paths fixed!