// Simplified button widget
import 'package:flutter/material.dart';

class SharedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  SharedButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}