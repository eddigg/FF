import 'package:flutter/material.dart';
import 'web_colors.dart';

class WebGradients {
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
  );

  static const LinearGradient buttonPrimary = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF6A5ACD), Color(0xFF8A2BE2)],
  );

  static const LinearGradient warningGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFFF9800), Color(0xFFFF5722)],
  );

  static const LinearGradient infoGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF2196F3), Color(0xFF3F51B5)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF4A4A6D), Color(0xFF2D2D40)],
  );

  static const LinearGradient cardBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF2A2A3E), Color(0xFF1F1F2E)],
  );
}
