import 'package:flutter/material.dart';
import '../themes/web_parity_theme.dart';

/// Responsive grid widget implementing web breakpoint system
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double? spacing;
  final double? runSpacing;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.spacing,
    this.runSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = WebParityTheme.getGridColumns(screenWidth);
    final crossAxisSpacing =
        spacing ?? WebParityTheme.getResponsiveSpacing(screenWidth);
    final mainAxisSpacing =
        runSpacing ?? WebParityTheme.getResponsiveSpacing(screenWidth);

    return GridView.count(
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: crossAxisSpacing,
      mainAxisSpacing: mainAxisSpacing,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: children,
    );
  }
}
