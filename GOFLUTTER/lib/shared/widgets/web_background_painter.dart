import 'package:flutter/material.dart';
import '../themes/web_gradients.dart';

/// Custom painter for web parity background effects
class WebBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    
    // Draw the radial gradients from web CSS
    for (final gradient in WebGradients.backgroundOverlays) {
      final rect = Rect.fromLTWH(0, 0, size.width, size.height);
      final shader = gradient.createShader(rect);
      paint.shader = shader;
      
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}