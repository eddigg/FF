@echo off
echo Setting up Flutter development environment...

:: Check if Flutter is installed
where flutter >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo Flutter SDK not found. Please install Flutter first.
    echo Visit https://flutter.dev/docs/get-started/install/windows
    exit /b 1
)

:: Check Flutter version
echo Checking Flutter version...
flutter --version

:: Upgrade Flutter to latest stable
echo Upgrading Flutter to latest stable version...
flutter upgrade

:: Enable web support
echo Enabling web support...
flutter config --enable-web

:: Create Flutter project
echo Creating Flutter project...
cd %~dp0
mkdir FLUTTER_IMPLEMENTATION
cd FLUTTER_IMPLEMENTATION
flutter create --org com.cercaend --project-name cercaend_wallet .

:: Install required dependencies
echo Installing required dependencies...
flutter pub add firebase_core
flutter pub add firebase_auth
flutter pub add cloud_firestore
flutter pub add flutter_secure_storage
flutter pub add provider
flutter pub add dio
flutter pub add web3dart
flutter pub add get_it
flutter pub add shared_preferences
flutter pub add flutter_dotenv

:: Add dev dependencies
echo Adding dev dependencies...
flutter pub add --dev flutter_test
flutter pub add --dev mockito
flutter pub add --dev build_runner

:: Configure Firebase
echo Please configure Firebase manually:
echo 1. Create a Firebase project at https://console.firebase.google.com/
echo 2. Register your app with Firebase
echo 3. Download google-services.json and place it in the android/app directory
echo 4. Download GoogleService-Info.plist and place it in the ios/Runner directory
echo 5. Follow the instructions to add the Firebase SDK to your app

echo.
echo Flutter development environment setup complete!
echo.
echo Next steps:
echo 1. Configure Firebase for your project
echo 2. Set up your project structure according to the FLUTTER_PROJECT_STRUCTURE.md guidelines
echo 3. Implement the core services as outlined in the TECHNICAL_SPECIFICATION.md

pause