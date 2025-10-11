import 'package:flutter/material.dart';
import 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart';
import 'package:atlas_blockchain_flutter/shared/themes/web_colors.dart';

class WebScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Widget? floatingActionButton;
  final Color? backgroundColor;
  final bool showBackButton;

  const WebScaffold({
    super.key,
    required this.body,
    this.title = 'ATLAS Blockchain',
    this.appBar,
    this.drawer,
    this.floatingActionButton,
    this.backgroundColor,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          appBar ??
          AppBar(
            title: Text(title),
            backgroundColor: const Color(0xFF667EEA),
            foregroundColor: Colors.white,
            automaticallyImplyLeading: showBackButton,
          ),
      drawer: drawer,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [WebColors.background, const Color(0xFF0D0D15)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(WebParityTheme.containerPadding),
            child: body,
          ),
        ),
      ),
      floatingActionButton: floatingActionButton,
      backgroundColor: backgroundColor,
    );
  }
}
