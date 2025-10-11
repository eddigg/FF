@echo off
echo Fixing all remaining import issues...

REM Fix any remaining features/shared/widgets/web_scaffold.dart imports
powershell -Command "Get-ChildItem -Path lib -Recurse -Filter '*.dart' | ForEach-Object { (Get-Content $_.FullName) -replace 'package:atlas_blockchain_flutter/features/shared/widgets/web_scaffold.dart', 'package:atlas_blockchain_flutter/shared/widgets/web_scaffold.dart' | Set-Content $_.FullName }"

REM Fix any remaining src/shared imports
powershell -Command "Get-ChildItem -Path lib -Recurse -Filter '*.dart' | ForEach-Object { (Get-Content $_.FullName) -replace 'package:atlas_blockchain_flutter/src/shared/', 'package:atlas_blockchain_flutter/shared/' | Set-Content $_.FullName }"

REM Fix any remaining features/shared imports
powershell -Command "Get-ChildItem -Path lib -Recurse -Filter '*.dart' | ForEach-Object { (Get-Content $_.FullName) -replace 'package:atlas_blockchain_flutter/features/shared/', 'package:atlas_blockchain_flutter/shared/' | Set-Content $_.FullName }"

echo All import paths fixed!