# Design Document

## Overview

This design document outlines the technical approach for achieving complete UI/UX parity between the web frontend (ATLAS.BC0.0.1/web/frontend) and the Flutter application (GOFLUTTER). The design focuses on replicating the sophisticated visual design, layout patterns, animations, and interactive features from the web version while leveraging Flutter's widget system and existing architecture.

## Architecture

### Design System Architecture

The implementation will follow a layered architecture approach:

1. **Theme Layer**: Centralized design tokens matching web CSS variables
2. **Component Layer**: Reusable widgets that mirror web UI components
3. **Layout Layer**: Screen-specific layouts matching web page structures
4. **Integration Layer**: API integration matching web JavaScript functionality

### Key Design Principles

- **Pixel-Perfect Matching**: All visual elements must match the web version exactly
- **Component Reusability**: Create reusable widgets for common UI patterns
- **Responsive Design**: Implement the same breakpoints and responsive behavior as web
- **Performance**: Maintain smooth animations and transitions
- **Maintainability**: Structure code to be easily updatable when web design changes

## Components and Interfaces

### Core Theme System

**WebParityTheme**
- Manages color schemes, gradients, and typography matching web CSS
- Provides consistent spacing, border radius, and shadow definitions
- Handles responsive breakpoints identical to web version

**Key Theme Components:**
- `WebColors`: Exact color palette from web CSS
- `WebTypography`: Inter font family with matching weights and sizes
- `WebShadows`: Box shadow definitions matching web styling
- `WebGradients`: Linear and radial gradients from web design

### Dashboard Components

**DashboardPage (Enhanced)**
- Main container with web-identical background gradients and patterns
- Header section with title, subtitle, and node selector
- Navigation card grid with responsive layout
- Network architecture section below navigation

**NavigationCard Widget**
- Matches web nav-card styling exactly
- Implements hover animations and transitions
- Supports emoji icons, titles, descriptions, and action buttons
- Handles routing to respective feature pages

**NetworkArchitectureCard Widget**
- Displays 5 architecture information cards
- Fetches real-time data from API endpoints
- Handles loading states and error conditions
- Matches web styling and layout exactly

**NodeSelector Widget**
- Port selection buttons matching web functionality
- Updates global API port state
- Triggers data refresh across components
- Maintains selected state in local storage

### Shared UI Components

**GlassCard Widget (Enhanced)**
- Backdrop blur effects matching web styling
- Configurable opacity and border styling
- Hover animations and transitions
- Support for nested content layouts

**WebButton Widget**
- Multiple variants (primary, secondary, success, warning)
- Gradient backgrounds matching web CSS
- Hover animations and state management
- Consistent sizing and typography

**StatusIndicator Widget**
- Animated status dots matching web design
- Color-coded status states
- Pulse animations for active states

### Layout Components

**WebScaffold Widget**
- Consistent page structure across all screens
- Background gradient and pattern implementation
- Header and navigation management
- Responsive layout handling

**ResponsiveGrid Widget**
- Implements web breakpoint system
- Handles column count changes (1, 2, 4 columns)
- Maintains consistent spacing and gaps
- Supports different content types

## Data Models

### Theme Data Models

```dart
class WebColorScheme {
  final Color primary;
  final Color secondary;
  final Color background;
  final List<Color> backgroundGradient;
  final Color cardBackground;
  final Color textPrimary;
  final Color textSecondary;
}

class WebTypography {
  final TextStyle heading1;
  final TextStyle heading2;
  final TextStyle body;
  final TextStyle caption;
  final String fontFamily; // 'Inter'
}

class WebShadows {
  final BoxShadow cardShadow;
  final BoxShadow cardHoverShadow;
  final BoxShadow buttonShadow;
  final List<BoxShadow> glassEffect;
}
```

### Navigation Data Models

```dart
class NavigationCardData {
  final String emoji;
  final String title;
  final String description;
  final String route;
  final WebButtonStyle buttonStyle;
  final Color? accentColor;
}

class NetworkArchitectureData {
  final NodeTypesInfo nodeTypes;
  final P2PProtocolInfo p2pProtocol;
  final ConsensusMechanismInfo consensusMechanism;
  final NetworkTopologyInfo networkTopology;
  final SecurityFeaturesInfo securityFeatures;
}
```

### API Integration Models

```dart
class ApiPortManager {
  final int currentPort;
  final List<int> availablePorts;
  final ValueNotifier<int> portNotifier;
  
  void switchPort(int newPort);
  void refreshAllData();
}

class NetworkDataProvider {
  Future<NetworkArchitectureData> fetchNetworkArchitecture();
  Future<List<BlockData>> fetchRecentBlocks();
  Future<WalletBalance> fetchWalletBalance(String address);
}
```

## Error Handling

### API Error Management
- Implement identical error states as web version
- Display connection errors with port information
- Graceful fallback to cached data when possible
- User-friendly error messages matching web text

### Loading States
- Skeleton loading animations matching web patterns
- Progressive loading for different data sections
- Timeout handling with retry mechanisms
- Loading indicators consistent with web design

### Offline Handling
- Cache critical UI data for offline viewing
- Display offline indicators when network unavailable
- Queue API calls for when connection restored
- Maintain UI functionality during network issues

## Testing Strategy

### Visual Regression Testing
- Screenshot comparison tests against web version
- Pixel-perfect validation for key UI components
- Cross-platform consistency verification
- Responsive layout testing at different screen sizes

### Component Testing
- Unit tests for all custom widgets
- Theme system validation tests
- Animation and transition testing
- State management verification

### Integration Testing
- End-to-end navigation flow testing
- API integration validation
- Port switching functionality testing
- Real-time data update verification

### Performance Testing
- Animation performance benchmarking
- Memory usage optimization validation
- Startup time measurement
- Scroll performance testing

## Implementation Phases

### Phase 1: Theme System Foundation
- Implement WebParityTheme with exact color matching
- Create typography system with Inter font
- Set up gradient and shadow definitions
- Establish responsive breakpoint system

### Phase 2: Core Dashboard Components
- Enhance DashboardPage with web-identical layout
- Implement NavigationCard widget with animations
- Create NodeSelector with port switching functionality
- Add background patterns and effects

### Phase 3: Network Architecture Integration
- Implement NetworkArchitectureCard widget
- Integrate real-time API data fetching
- Add loading states and error handling
- Implement hover effects and animations

### Phase 4: Shared Component Library
- Enhance GlassCard with backdrop blur effects
- Create WebButton with all variants
- Implement StatusIndicator with animations
- Build ResponsiveGrid layout system

### Phase 5: Integration and Polish
- Integrate all components into existing pages
- Implement cross-page navigation consistency
- Add performance optimizations
- Conduct visual regression testing

### Phase 6: Responsive Design Implementation
- Implement mobile layout adaptations
- Add tablet-specific responsive behavior
- Ensure desktop layout matches web exactly
- Test across different screen sizes and orientations

## Technical Considerations

### Flutter-Specific Implementations
- Use `BackdropFilter` for glass effects matching web backdrop-filter
- Implement `AnimatedContainer` for smooth hover transitions
- Utilize `CustomPainter` for complex gradient backgrounds
- Leverage `MediaQuery` for responsive breakpoint handling

### Performance Optimizations
- Implement widget caching for expensive renders
- Use `const` constructors where possible
- Optimize image and gradient rendering
- Implement lazy loading for data-heavy components

### State Management Integration
- Integrate with existing BLoC pattern
- Maintain API port state globally
- Handle real-time data updates efficiently
- Coordinate state between multiple components

### Platform Considerations
- Ensure consistent behavior across platforms
- Handle platform-specific font rendering
- Optimize for different screen densities
- Maintain performance on lower-end devices