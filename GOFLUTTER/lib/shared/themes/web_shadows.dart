import 'package:flutter/material.dart';

class WebShadows {
  static const List<BoxShadow> button = [
    BoxShadow(
      color: Color(0x33000000), // 20% opacity black
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x1A000000), // 10% opacity black
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> modal = [
    BoxShadow(
      color: Color(0x40000000), // 25% opacity black
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];
}
