import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../themes/web_gradients.dart';
import '../widgets/web_background_painter.dart';
import '../../core/navigation/navigation_state_manager.dart';

/// WebScaffold widget for consistent page structure across all screens
class WebScaffold extends StatelessWidget {
  final Widget child;
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  const WebScaffold({
    Key? key,
    required this.child,
    this.title = 'ATLAS B.C.',
    this.showBackButton = true,
    this.actions,
    this.bottom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: showBackButton
            ? Consumer<NavigationStateManager>(
                builder: (context, navManager, child) {
                  return IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      // Try to navigate back using history, fallback to dashboard
                      final previousRoute = navManager.navigateBack();
                      // Check if we're already at the previous route to avoid infinite loops
                      final currentLocation = GoRouterState.of(context).uri.toString();
                      if (previousRoute != currentLocation) {
                        context.go(previousRoute);
                      } else {
                        // If we can't go back, go to dashboard
                        context.go('/dashboard');
                      }
                    },
                  );
                },
              )
            : null,
        actions: actions,
        bottom: bottom,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: WebGradients.backgroundMain,
        ),
        child: Stack(
          children: [
            // Background radial gradients matching web CSS
            CustomPaint(
              size: MediaQuery.of(context).size,
              painter: WebBackgroundPainter(),
            ),
            child,
          ],
        ),
      ),
    );
  }
}