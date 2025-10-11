@echo off
echo Fixing relative import paths...

REM Fix relative imports to use package imports
powershell -Command "(Get-Content 'lib/features/wallet/presentation/screens/receive_screen.dart') -replace '../../../shared/widgets/common_widgets.dart', '../../../../shared/widgets/common_widgets.dart' | Set-Content 'lib/features/wallet/presentation/screens/receive_screen.dart'"

powershell -Command "(Get-Content 'lib/features/wallet/presentation/widgets/wallet_overview_panel.dart') -replace '../../../shared/widgets/common_widgets.dart', '../../../../shared/widgets/common_widgets.dart' | Set-Content 'lib/features/wallet/presentation/widgets/wallet_overview_panel.dart'"

powershell -Command "(Get-Content 'lib/features/wallet/presentation/widgets/send_transaction_panel.dart') -replace '../../../shared/widgets/common_widgets.dart', '../../../../shared/widgets/common_widgets.dart' | Set-Content 'lib/features/wallet/presentation/widgets/send_transaction_panel.dart'"

powershell -Command "(Get-Content 'lib/features/identity/presentation/widgets/reputation_section.dart') -replace '../../../shared/widgets/common_widgets.dart', '../../../../shared/widgets/common_widgets.dart' | Set-Content 'lib/features/identity/presentation/widgets/reputation_section.dart'"

powershell -Command "(Get-Content 'lib/features/identity/presentation/widgets/verification_section.dart') -replace '../../../shared/widgets/common_widgets.dart', '../../../../shared/widgets/common_widgets.dart' | Set-Content 'lib/features/identity/presentation/widgets/verification_section.dart'"

powershell -Command "(Get-Content 'lib/features/identity/presentation/widgets/activity_section.dart') -replace '../../../shared/widgets/common_widgets.dart', '../../../../shared/widgets/common_widgets.dart' | Set-Content 'lib/features/identity/presentation/widgets/activity_section.dart'"

powershell -Command "(Get-Content 'lib/features/node_dashboard/presentation/widgets/node_performance_metrics.dart') -replace '../../../shared/widgets/common_widgets.dart', '../../../../shared/widgets/common_widgets.dart' | Set-Content 'lib/features/node_dashboard/presentation/widgets/node_performance_metrics.dart'"

powershell -Command "(Get-Content 'lib/features/governance/presentation/pages/create_proposal_page.dart') -replace '../../../shared/widgets/common_widgets.dart', '../../../../shared/widgets/common_widgets.dart' | Set-Content 'lib/features/governance/presentation/pages/create_proposal_page.dart'"

powershell -Command "(Get-Content 'lib/features/explorer/presentation/widgets/transaction_list_item.dart') -replace '../../../shared/widgets/common_widgets.dart', '../../../../shared/widgets/common_widgets.dart' | Set-Content 'lib/features/explorer/presentation/widgets/transaction_list_item.dart'"

powershell -Command "(Get-Content 'lib/features/explorer/presentation/widgets/search_bar.dart') -replace '../../../shared/widgets/common_widgets.dart', '../../../../shared/widgets/common_widgets.dart' | Set-Content 'lib/features/explorer/presentation/widgets/search_bar.dart'"

powershell -Command "(Get-Content 'lib/features/explorer/presentation/widgets/block_list_item.dart') -replace '../../../shared/widgets/common_widgets.dart', '../../../../shared/widgets/common_widgets.dart' | Set-Content 'lib/features/explorer/presentation/widgets/block_list_item.dart'"

powershell -Command "(Get-Content 'lib/features/defi/presentation/pages/defi_page.dart') -replace '../../../../shared/widgets/common_widgets.dart', 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' | Set-Content 'lib/features/defi/presentation/pages/defi_page.dart'"

powershell -Command "(Get-Content 'lib/features/dashboard/presentation/widgets/node_metrics_card.dart') -replace '../../../shared/widgets/common_widgets.dart', '../../../../shared/widgets/common_widgets.dart' | Set-Content 'lib/features/dashboard/presentation/widgets/node_metrics_card.dart'"

powershell -Command "(Get-Content 'lib/features/dashboard/presentation/widgets/network_architecture_card.dart') -replace '../../../shared/widgets/common_widgets.dart', '../../../../shared/widgets/common_widgets.dart' | Set-Content 'lib/features/dashboard/presentation/widgets/network_architecture_card.dart'"

powershell -Command "(Get-Content 'lib/features/dashboard/presentation/widgets/nav_card.dart') -replace '../../../shared/widgets/common_widgets.dart', '../../../../shared/widgets/common_widgets.dart' | Set-Content 'lib/features/dashboard/presentation/widgets/nav_card.dart'"

echo Relative import paths fixed!