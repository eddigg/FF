@echo off
echo Fixing remaining relative imports...

REM Fix relative web_scaffold imports
powershell -Command "(Get-Content 'lib/features/wallet/presentation/pages/wallet_setup_page.dart') -replace '../../../shared/widgets/web_scaffold.dart', '../../../../shared/widgets/web_scaffold.dart' | Set-Content 'lib/features/wallet/presentation/pages/wallet_setup_page.dart'"

powershell -Command "(Get-Content 'lib/features/social/presentation/pages/social_page.dart') -replace '../../../shared/widgets/web_scaffold.dart', '../../../../shared/widgets/web_scaffold.dart' | Set-Content 'lib/features/social/presentation/pages/social_page.dart'"

powershell -Command "(Get-Content 'lib/features/node_dashboard/presentation/pages/node_dashboard_page.dart') -replace '../../../shared/widgets/web_scaffold.dart', '../../../../shared/widgets/web_scaffold.dart' | Set-Content 'lib/features/node_dashboard/presentation/pages/node_dashboard_page.dart'"

powershell -Command "(Get-Content 'lib/features/health/presentation/pages/health_page.dart') -replace '../../../shared/widgets/web_scaffold.dart', '../../../../shared/widgets/web_scaffold.dart' | Set-Content 'lib/features/health/presentation/pages/health_page.dart'"

powershell -Command "(Get-Content 'lib/features/identity/presentation/pages/identity_page.dart') -replace '../../../shared/widgets/web_scaffold.dart', '../../../../shared/widgets/web_scaffold.dart' | Set-Content 'lib/features/identity/presentation/pages/identity_page.dart'"

powershell -Command "(Get-Content 'lib/features/contracts/presentation/pages/contracts_page.dart') -replace '../../../shared/widgets/web_scaffold.dart', '../../../../shared/widgets/web_scaffold.dart' | Set-Content 'lib/features/contracts/presentation/pages/contracts_page.dart'"

echo Remaining imports fixed!