import 'package:equatable/equatable.dart';
import 'asset_model.dart';

class PortfolioDataModel extends Equatable {
  final double totalValue;
  final double change;
  final double staked;
  final double lent;
  final double rewards;
  final double apy;
  final List<AssetModel> assets;

  const PortfolioDataModel({
    required this.totalValue,
    required this.change,
    required this.staked,
    required this.lent,
    required this.rewards,
    required this.apy,
    required this.assets,
  });

  @override
  List<Object> get props => [
        totalValue,
        change,
        staked,
        lent,
        rewards,
        apy,
        assets,
      ];

  factory PortfolioDataModel.fromJson(Map<String, dynamic> json) {
    List<AssetModel> assetsList = [];
    if (json['assets'] != null) {
      assetsList = (json['assets'] as List)
          .map((item) => AssetModel.fromJson(item))
          .toList();
    }

    return PortfolioDataModel(
      totalValue: (json['totalValue'] ?? 0.0).toDouble(),
      change: (json['change'] ?? 0.0).toDouble(),
      staked: (json['staked'] ?? 0.0).toDouble(),
      lent: (json['lent'] ?? 0.0).toDouble(),
      rewards: (json['rewards'] ?? 0.0).toDouble(),
      apy: (json['apy'] ?? 0.0).toDouble(),
      assets: assetsList,
    );
  }
}