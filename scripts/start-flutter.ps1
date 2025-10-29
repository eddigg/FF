# scripts/start-flutter.ps1

Write-Host "Starting Flutter App..." -ForegroundColor Green
Set-Location apps/cercaend
flutter run -d chrome
Set-Location ../..

Write-Host "Flutter app started!" -ForegroundColor Green
