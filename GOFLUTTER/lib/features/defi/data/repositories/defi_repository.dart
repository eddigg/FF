import '../models/portfolio_data_model.dart';
import '../models/lending_pool_model.dart';
import '../models/trading_pair_model.dart';
import '../models/staking_option_model.dart';
import '../models/liquidity_pool_model.dart';
import '../models/yield_farm_model.dart';

abstract class DeFiRepository {
  Future<PortfolioDataModel> getPortfolioData();
  Future<List<LendingPoolModel>> getLendingPools();
  Future<List<TradingPairModel>> getTradingPairs();
  Future<List<StakingOptionModel>> getStakingOptions();
  Future<List<LiquidityPoolModel>> getLiquidityPools();
  Future<List<YieldFarmModel>> getYieldFarms();
  Future<Map<String, dynamic>> stakeTokens({
    required String address,
    required String poolId,
    required double amount,
  });
  Future<Map<String, dynamic>> unstakeTokens({
    required String address,
    required String poolId,
    required double amount,
  });
  Future<Map<String, dynamic>> claimRewards({
    required String address,
    required String poolId,
  });
}
