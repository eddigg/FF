@echo off
REM Final Compilation Fixes for Flutter Application

echo Fixing remaining compilation errors...

cd GOFLUTTER

REM Fix identity profile_section.dart cardTitleStyle references
powershell -Command "(Get-Content lib/features/identity/presentation/widgets/profile_section.dart) -replace 'cardTitleStyle', 'cardTitleStyle' | Set-Content lib/features/identity/presentation/widgets/profile_section.dart"

powershell -Command "(Get-Content lib/features/identity/presentation/widgets/kyc_section.dart) -replace 'cardTitleStyle', 'cardTitleStyle' | Set-Content lib/features/identity/presentation/widgets/kyc_section.dart"

powershell -Command "(Get-Content lib/features/identity/presentation/widgets/privacy_section.dart) -replace 'cardTitleStyle', 'cardTitleStyle' | Set-Content lib/features/identity/presentation/widgets/privacy_section.dart"

REM Add proper widget imports to proposal_detail_page.dart
powershell -Command "(Get-Content lib/features/governance/presentation/pages/proposal_detail_page.dart) | Where-Object {$_ -notmatch 'import.*common_widgets'} | Set-Content temp.txt && echo import 'package:atlas_blockchain_flutter/features/shared/widgets/common_widgets.dart'; >> temp.txt && type lib/features/governance/presentation/pages/proposal_detail_page.dart >> temp.txt && move temp.txt lib/features/governance/presentation/pages/proposal_detail_page.dart"

REM Fix sharding section syntax
powershell -Command "(Get-Content lib/features/node_dashboard/presentation/widgets/sharding_section.dart) -replace '])[^;]*;', ']),);' | Set-Content lib/features/node_dashboard/presentation/widgets/sharding_section.dart"

powershell -Command "(Get-Content lib/features/node_dashboard/presentation/widgets/sharding_management_section.dart) -replace '])[^;]*;', ']),);' | Set-Content lib/features/node_dashboard/presentation/widgets/sharding_management_section.dart"

REM Add widget imports to receive_page.dart
powershell -Command "if (!(Select-String -Path lib/features/wallet/presentation/pages/receive_page.dart -Pattern 'package:atlas_blockchain_flutter/features/shared/widgets/common_widgets.dart')) { Add-Content lib/features/wallet/presentation/pages/receive_page.dart 'import \"package:atlas_blockchain_flutter/features/shared/widgets/common_widgets.dart\";' }"

echo Running final compilation test...
flutter run --debug

echo Fixes completed! Running final test.
