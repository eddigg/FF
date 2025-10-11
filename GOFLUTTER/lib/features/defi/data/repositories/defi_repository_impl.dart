import '../models/portfolio_data_model.dart';
import '../models/lending_pool_model.dart';
import '../models/trading_pair_model.dart';
import '../models/staking_option_model.dart';
import '../models/liquidity_pool_model.dart';
import '../models/yield_farm_model.dart';
import 'defi_repository.dart';
import '../data_sources/defi_api_client.dart';

class DeFiRepositoryImpl implements DeFiRepository {
  final DeFiApiClient apiClient;

  DeFiRepositoryImpl({required this.apiClient});

  @override
  Future<PortfolioDataModel> getPortfolioData() async {
    final data = await apiClient.fetchPortfolioData();
    return PortfolioDataModel.fromJson(data);
  }

  @override
  Future<List<LendingPoolModel>> getLendingPools() async {
    final data = await apiClient.fetchLendingPools();
    return data.map((item) => LendingPoolModel.fromJson(item)).toList();
  }

  @override
  Future<List<TradingPairModel>> getTradingPairs() async {
    final data = await apiClient.fetchTradingPairs();
    return data.map((item) => TradingPairModel.fromJson(item)).toList();
  }

  @override
  Future<List<StakingOptionModel>> getStakingOptions() async {
    final data = await apiClient.fetchStakingOptions();
    return data.map((item) => StakingOptionModel.fromJson(item)).toList();
  }

  @override
  Future<List<LiquidityPoolModel>> getLiquidityPools() async {
    final data = await apiClient.fetchLiquidityPools();
    return data.map((item) => LiquidityPoolModel.fromJson(item)).toList();
  }

  @override
  Future<List<YieldFarmModel>> getYieldFarms() async {
    final data = await apiClient.fetchYieldFarms();
    return data.map((item) => YieldFarmModel.fromJson(item)).toList();
  }

  @override
  Future<Map<String, dynamic>> stakeTokens({
    required String address,
    required String poolId,
    required double amount,
  }) async {
    return await apiClient.stakeTokens(
      address: address,
      poolId: poolId,
      amount: amount,
    );
  }

  @override
  Future<Map<String, dynamic>> unstakeTokens({
    required String address,
    required String poolId,
    required double amount,
  }) async {
    return await apiClient.unstakeTokens(
      address: address,
      poolId: poolId,
      amount: amount,
    );
  }

  @override
  Future<Map<String, dynamic>> claimRewards({
    required String address,
    required String poolId,
  }) async {
    return await apiClient.claimRewards(
      address: address,
      poolId: poolId,
    );
  }
}
