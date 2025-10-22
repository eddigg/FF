import 'package:flutter/material.dart';

class WebScaffold extends StatelessWidget {
  final Widget body;
  final String? title;
  final Color? backgroundColor;

  const WebScaffold({
    Key? key,
    required this.body,
    this.title,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? const Color(0xFF121212),
      appBar: title != null
          ? AppBar(
              title: Text(title!),
              backgroundColor: const Color(0xFF1E1E1E),
            )
          : null,
      body: body,
    );
  }
}