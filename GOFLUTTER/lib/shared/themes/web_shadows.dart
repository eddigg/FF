import 'package:flutter/material.dart';

/// Web parity shadow system matching box-shadow definitions from web CSS
class WebShadows {
  WebShadows._();

  // Navigation bar shadows matching web CSS
  static const List<BoxShadow> navBar = [
    BoxShadow(
      color: Color(0x14000000), // rgba(0,0,0,0.08)
      offset: Offset(0, 20),
      blurRadius: 40,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x0F000000), // rgba(0,0,0,0.06)
      offset: Offset(0, 8),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];

  // Navigation bar hover shadows
  static const List<BoxShadow> navBarHover = [
    BoxShadow(
      color: Color(0x1F000000), // rgba(0,0,0,0.12)
      offset: Offset(0, 25),
      blurRadius: 50,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x14000000), // rgba(0,0,0,0.08)
      offset: Offset(0, 12),
      blurRadius: 24,
      spreadRadius: 0,
    ),
  ];

  // Navigation card shadows matching web CSS
  static const List<BoxShadow> navCard = [
    BoxShadow(
      color: Color(0x14000000), // rgba(0,0,0,0.08)
      offset: Offset(0, 8),
      blurRadius: 25,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x0A000000), // rgba(0,0,0,0.04)
      offset: Offset(0, 4),
      blurRadius: 10,
      spreadRadius: 0,
    ),
  ];

  // Navigation card hover shadows
  static const List<BoxShadow> navCardHover = [
    BoxShadow(
      color: Color(0x1F000000), // rgba(0,0,0,0.12)
      offset: Offset(0, 15),
      blurRadius: 35,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x14000000), // rgba(0,0,0,0.08)
      offset: Offset(0, 8),
      blurRadius: 20,
      spreadRadius: 0,
    ),
  ];

  // Architecture card shadows
  static const List<BoxShadow> architectureCard = [
    BoxShadow(
      color: Color(0x0F000000), // rgba(0,0,0,0.06)
      offset: Offset(0, 8),
      blurRadius: 25,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x0A000000), // rgba(0,0,0,0.04)
      offset: Offset(0, 4),
      blurRadius: 10,
      spreadRadius: 0,
    ),
  ];

  // Architecture card hover shadows
  static const List<BoxShadow> architectureCardHover = [
    BoxShadow(
      color: Color(0x1A000000), // rgba(0,0,0,0.1)
      offset: Offset(0, 12),
      blurRadius: 30,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x0F000000), // rgba(0,0,0,0.06)
      offset: Offset(0, 6),
      blurRadius: 15,
      spreadRadius: 0,
    ),
  ];

  // General card shadows matching web CSS
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x1A000000), // rgba(0,0,0,0.1)
      offset: Offset(0, 10),
      blurRadius: 30,
      spreadRadius: 0,
    ),
  ];

  // Card hover shadows
  static const List<BoxShadow> cardHover = [
    BoxShadow(
      color: Color(0x26000000), // rgba(0,0,0,0.15)
      offset: Offset(0, 15),
      blurRadius: 40,
      spreadRadius: 0,
    ),
  ];

  // Button shadows matching web CSS
  static const List<BoxShadow> button = [
    BoxShadow(
      color: Color(0x66000000), // rgba(0,0,0,0.4) for button hover
      offset: Offset(0, 5),
      blurRadius: 15,
      spreadRadius: 0,
    ),
  ];

  // Button hover shadows with color variants
  static const List<BoxShadow> buttonPrimaryHover = [
    BoxShadow(
      color: Color(0x664299E1), // rgba(66, 153, 225, 0.4)
      offset: Offset(0, 5),
      blurRadius: 15,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> buttonSuccessHover = [
    BoxShadow(
      color: Color(0x6648BB78), // rgba(72, 187, 120, 0.4)
      offset: Offset(0, 5),
      blurRadius: 15,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> buttonWarningHover = [
    BoxShadow(
      color: Color(0x66ED8936), // rgba(237, 137, 54, 0.4)
      offset: Offset(0, 5),
      blurRadius: 15,
      spreadRadius: 0,
    ),
  ];

  // Logout button shadow matching web CSS
  static const List<BoxShadow> logoutButton = [
    BoxShadow(
      color: Color(0x332D3748), // rgba(45, 55, 72, 0.2)
      offset: Offset(0, 8),
      blurRadius: 25,
      spreadRadius: 0,
    ),
  ];

  // Refresh button shadow
  static const List<BoxShadow> refreshButton = [
    BoxShadow(
      color: Color(0x33000000), // rgba(0,0,0,0.2)
      offset: Offset(0, 5),
      blurRadius: 15,
      spreadRadius: 0,
    ),
  ];

  // Form input focus shadow
  static const List<BoxShadow> inputFocus = [
    BoxShadow(
      color: Color(0x1A4299E1), // rgba(66, 153, 225, 0.1)
      offset: Offset(0, 0),
      blurRadius: 0,
      spreadRadius: 3,
    ),
  ];

  // Glass effect shadows for backdrop blur components
  static const List<BoxShadow> glassEffect = [
    BoxShadow(
      color: Color(0x14000000), // rgba(0,0,0,0.08)
      offset: Offset(0, 20),
      blurRadius: 40,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x0F000000), // rgba(0,0,0,0.06)
      offset: Offset(0, 8),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];

  // Network architecture section shadow
  static const List<BoxShadow> networkArchitecture = [
    BoxShadow(
      color: Color(0x14000000), // rgba(0,0,0,0.08)
      offset: Offset(0, 20),
      blurRadius: 40,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x0F000000), // rgba(0,0,0,0.06)
      offset: Offset(0, 8),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];
}
