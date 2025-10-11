@echo off
REM Verify compilation status script

echo ====================================================================
echo ATLAS FLUTTER BLOCKCHAIN APP - COMPILATION VERIFICATION
echo ====================================================================
echo.

cd GOFLUTTER

echo Running flutter analyze to check for critical errors...
flutter analyze --no-fatal-infos 2>&1 | findstr "error" | find /C "error" > error_count.txt
set /p error_count=<error_count.txt

echo.
echo ==============================================
echo FINAL COMPILATION RESULTS
echo ==============================================
echo Critical Errors Found: %error_count%
echo.

if %error_count% equ 0 (
    echo 🎯 SUCCESS: 0 compilation errors achieved!
    echo 🎉 ATLAS Application is ready for deployment!
    echo.
    echo 🚀 Launching application...
    start flutter run --web-port=3002
) else (
    echo ❌ FAILURE: %error_count% compilation errors remaining
    echo 🔧 Additional fixes required
    echo.
    flutter analyze --no-fatal-infos 2>&1 | findstr "error" | head -10
)
echo.
echo ==============================================
