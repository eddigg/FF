#!/bin/bash

# Fix remaining compilation errors for the Flutter blockchain application
cd GOFLUTTER

# Fix dashboard syntax error
sed -i 's/return GestureDetector(/return GestureDetector(); /g' lib/features/dashboard/presentation/pages/dashboard_page.dart

# Add missing widget imports to proposal_detail_page.dart
sed -i '1a import "\"../../../../shared/widgets/common_widgets.dart\"";' lib/features/governance/presentation/pages/proposal_detail_page.dart

# Add missing widget imports to identity_page.dart (already has common_widgets import, so widgets should be available)

# Add missing widget imports to receive_page.dart and send_page.dart (already have common_widgets import)

# Fix the remaining sharding syntax errors
sed -i 's/),$/},/' lib/features/node_dashboard/presentation/widgets/sharding_section.dart
sed -i 's/),$/},/' lib/features/node_dashboard/presentation/widgets/sharding_management_section.dart

# Verify the fixes
echo "Final compilation test:"
flutter run --debug
