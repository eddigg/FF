import 'package:flutter/material.dart';
import '../../../../shared/themes/web_gradients.dart';

/// Navigation card data model with emoji, title, description, and route
class NavigationCardData {
  final String emoji;
  final String title;
  final String description;
  final String route;
  final LinearGradient? gradient;

  NavigationCardData({
    required this.emoji,
    required this.title,
    required this.description,
    required this.route,
    this.gradient,
  });

  /// Factory constructor for explorer card
  factory NavigationCardData.explorer() {
    return NavigationCardData(
      emoji: '🔍',
      title: 'Explorer',
      description: 'Browse blocks, transactions, and network activity in real time.',
      route: '/explorer',
    );
  }

  /// Factory constructor for wallet card
  factory NavigationCardData.wallet() {
    return NavigationCardData(
      emoji: '💼',
      title: 'Wallet',
      description: 'Manage your accounts, balances, and send transactions securely.',
      route: '/wallet',
      gradient: WebGradients.buttonSuccess,
    );
  }

  /// Factory constructor for network card
  factory NavigationCardData.network() {
    return NavigationCardData(
      emoji: '🌐',
      title: 'Network',
      description: 'Monitor node status, peers, and validator performance.',
      route: '/node-dashboard',
      gradient: WebGradients.buttonWarning,
    );
  }

  /// Factory constructor for health card
  factory NavigationCardData.health() {
    return NavigationCardData(
      emoji: '🏥',
      title: 'Health',
      description: 'System health monitoring, performance metrics, and testing.',
      route: '/health',
    );
  }

  /// Factory constructor for governance card
  factory NavigationCardData.governance() {
    return NavigationCardData(
      emoji: '🛡️',
      title: 'Governance',
      description: 'On-chain governance, voting, privacy, and sharding management.',
      route: '/governance',
    );
  }

  /// Factory constructor for contracts card
  factory NavigationCardData.contracts() {
    return NavigationCardData(
      emoji: '⚡',
      title: 'Smart Contracts',
      description: 'Deploy, interact with, and manage smart contracts on the blockchain.',
      route: '/contracts',
    );
  }

  /// Factory constructor for social card
  factory NavigationCardData.social() {
    return NavigationCardData(
      emoji: '📱',
      title: 'Social Platform',
      description: 'Connect, share, and engage with the ATLAS community.',
      route: '/social',
    );
  }

  /// Factory constructor for defi card
  factory NavigationCardData.defi() {
    return NavigationCardData(
      emoji: '💰',
      title: 'DeFi Platform',
      description: 'Lend, borrow, trade, and earn with DeFi protocols.',
      route: '/defi',
    );
  }

  /// Factory constructor for identity card
  factory NavigationCardData.identity() {
    return NavigationCardData(
      emoji: '👤',
      title: 'Identity Management',
      description: 'Manage your profile, KYC, privacy, and reputation.',
      route: '/identity',
    );
  }

  /// Get all navigation cards
  static List<NavigationCardData> getAll() {
    return [
      NavigationCardData.explorer(),
      NavigationCardData.wallet(),
      NavigationCardData.network(),
      NavigationCardData.health(),
      NavigationCardData.governance(),
      NavigationCardData.contracts(),
      NavigationCardData.social(),
      NavigationCardData.defi(),
      NavigationCardData.identity(),
    ];
  }
}