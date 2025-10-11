# GOFLUTTER Project Consolidation Plan

## Current Issues
1. **Triple duplication** of shared themes and widgets
2. **Multiple dashboard pages** (3 versions)
3. **Inconsistent architecture** - some features follow Clean Architecture, others don't
4. **Scattered presentation layer** - pages in multiple locations
5. **Empty domain folders** - incomplete Clean Architecture
6. **Duplicate API implementations**

## Proposed Structure

```
lib/
├── core/                           # Keep as-is, well organized
│   ├── api/
│   ├── crypto/
│   ├── network/
│   ├── routing/
│   └── services/
├── shared/                         # CONSOLIDATE HERE (remove duplicates)
│   ├── themes/
│   │   ├── app_colors.dart
│   │   ├── web_parity_theme.dart
│   │   └── web_typography.dart
│   └── widgets/
│       ├── common_widgets.dart
│       ├── web_scaffold.dart
│       └── glass_card.dart
├── features/                       # Clean up each feature
│   ├── dashboard/
│   │   ├── presentation/
│   │   │   ├── pages/
│   │   │   │   └── dashboard_page.dart    # ONE unified version
│   │   │   └── widgets/
│   │   └── data/                          # Keep existing
│   ├── wallet/
│   ├── explorer/
│   └── [other features]/
└── presentation/                   # REMOVE - move to features
```

## Action Items

### Phase 1: Remove Duplicates
1. Delete `lib/src/shared/` entirely
2. Delete `lib/features/shared/` 
3. Keep only `lib/shared/`
4. Move any unique files to `lib/shared/`

### Phase 2: Consolidate Dashboard
1. Create single `UnifiedDashboardPage`
2. Delete `dashboard_page.dart` and `simple_dashboard_page.dart`
3. Update router to use unified version

### Phase 3: Move Scattered Pages
1. Move `lib/presentation/pages/*` to appropriate `lib/features/*/presentation/pages/`
2. Update imports
3. Delete empty `lib/presentation/`

### Phase 4: Clean Architecture Cleanup
1. Either implement proper domain layer OR remove empty folders
2. Consolidate repository interfaces

### Phase 5: API Cleanup
1. Remove duplicate API implementations
2. Standardize on one approach

## Benefits
- **50% reduction** in duplicate code
- **Clear single source of truth** for shared components
- **Consistent architecture** across features
- **Easier maintenance** and debugging
- **Better performance** (no duplicate imports)