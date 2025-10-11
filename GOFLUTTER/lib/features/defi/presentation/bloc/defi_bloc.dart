import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/portfolio_data_model.dart';
import '../../data/models/lending_pool_model.dart';
import '../../data/models/trading_pair_model.dart';
import '../../data/models/staking_option_model.dart';
import '../../data/models/liquidity_pool_model.dart';
import '../../data/models/yield_farm_model.dart';
import '../../data/repositories/defi_repository.dart';

// Events
abstract class DeFiEvent extends Equatable {
  const DeFiEvent();

  @override
  List<Object> get props => [];
}

class LoadDeFiData extends DeFiEvent {}

class StakeTokens extends DeFiEvent {
  final String address;
  final String poolId;
  final double amount;

  const StakeTokens({
    required this.address,
    required this.poolId,
    required this.amount,
  });

  @override
  List<Object> get props => [address, poolId, amount];
}

class UnstakeTokens extends DeFiEvent {
  final String address;
  final String poolId;
  final double amount;

  const UnstakeTokens({
    required this.address,
    required this.poolId,
    required this.amount,
  });

  @override
  List<Object> get props => [address, poolId, amount];
}

class ClaimRewards extends DeFiEvent {
  final String address;
  final String poolId;

  const ClaimRewards({
    required this.address,
    required this.poolId,
  });

  @override
  List<Object> get props => [address, poolId];
}

// States
abstract class DeFiState extends Equatable {
  const DeFiState();

  @override
  List<Object> get props => [];
}

class DeFiInitial extends DeFiState {}

class DeFiLoading extends DeFiState {}

class DeFiLoaded extends DeFiState {
  final PortfolioDataModel portfolioData;
  final List<LendingPoolModel> lendingPools;
  final List<TradingPairModel> tradingPairs;
  final List<StakingOptionModel> stakingOptions;
  final List<LiquidityPoolModel> liquidityPools;
  final List<YieldFarmModel> yieldFarms;

  const DeFiLoaded({
    required this.portfolioData,
    required this.lendingPools,
    required this.tradingPairs,
    required this.stakingOptions,
    required this.liquidityPools,
    required this.yieldFarms,
  });

  @override
  List<Object> get props => [
        portfolioData,
        lendingPools,
        tradingPairs,
        stakingOptions,
        liquidityPools,
        yieldFarms,
      ];
}

class DeFiError extends DeFiState {
  final String message;

  const DeFiError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class DeFiBloc extends Bloc<DeFiEvent, DeFiState> {
  final DeFiRepository defiRepository;

  DeFiBloc({required this.defiRepository}) : super(DeFiInitial()) {
    on<LoadDeFiData>(_onLoadDeFiData);
    on<StakeTokens>(_onStakeTokens);
    on<UnstakeTokens>(_onUnstakeTokens);
    on<ClaimRewards>(_onClaimRewards);
  }

  Future<void> _onLoadDeFiData(
    LoadDeFiData event,
    Emitter<DeFiState> emit,
  ) async {
    emit(DeFiLoading());
    try {
      // Load actual data from repository
      final portfolioData = await defiRepository.getPortfolioData();
      final lendingPools = await defiRepository.getLendingPools();
      final tradingPairs = await defiRepository.getTradingPairs();
      final stakingOptions = await defiRepository.getStakingOptions();
      final liquidityPools = await defiRepository.getLiquidityPools();
      final yieldFarms = await defiRepository.getYieldFarms();
      
      emit(DeFiLoaded(
        portfolioData: portfolioData,
        lendingPools: lendingPools,
        tradingPairs: tradingPairs,
        stakingOptions: stakingOptions,
        liquidityPools: liquidityPools,
        yieldFarms: yieldFarms,
      ));
    } catch (e) {
      emit(DeFiError(e.toString()));
    }
  }

  Future<void> _onStakeTokens(
    StakeTokens event,
    Emitter<DeFiState> emit,
  ) async {
    try {
      await defiRepository.stakeTokens(
        address: event.address,
        poolId: event.poolId,
        amount: event.amount,
      );
      
      // Reload the data to show updated staking information
      add(LoadDeFiData());
    } catch (e) {
      emit(DeFiError(e.toString()));
    }
  }

  Future<void> _onUnstakeTokens(
    UnstakeTokens event,
    Emitter<DeFiState> emit,
  ) async {
    try {
      await defiRepository.unstakeTokens(
        address: event.address,
        poolId: event.poolId,
        amount: event.amount,
      );
      
      // Reload the data to show updated staking information
      add(LoadDeFiData());
    } catch (e) {
      emit(DeFiError(e.toString()));
    }
  }

  Future<void> _onClaimRewards(
    ClaimRewards event,
    Emitter<DeFiState> emit,
  ) async {
    try {
      await defiRepository.claimRewards(
        address: event.address,
        poolId: event.poolId,
      );
      
      // Reload the data to show updated staking information
      add(LoadDeFiData());
    } catch (e) {
      emit(DeFiError(e.toString()));
    }
  }
}
