import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/block_model.dart';
import '../../data/models/transaction_model.dart';
import '../../data/repositories/explorer_repository.dart';

// Events
abstract class ExplorerEvent extends Equatable {
  const ExplorerEvent();

  @override
  List<Object> get props => [];
}

class LoadRecentBlocks extends ExplorerEvent {}

class LoadRecentTransactions extends ExplorerEvent {}

class SearchEvent extends ExplorerEvent {
  final String query;

  const SearchEvent(this.query);

  @override
  List<Object> get props => [query];
}

class SearchByAddress extends ExplorerEvent {
  final String address;

  const SearchByAddress(this.address);

  @override
  List<Object> get props => [address];
}

class SearchByHash extends ExplorerEvent {
  final String hash;

  const SearchByHash(this.hash);

  @override
  List<Object> get props => [hash];
}

class SearchByBlockNumber extends ExplorerEvent {
  final int blockNumber;

  const SearchByBlockNumber(this.blockNumber);

  @override
  List<Object> get props => [blockNumber];
}

class RefreshData extends ExplorerEvent {}

class StartAutoRefresh extends ExplorerEvent {}

class StopAutoRefresh extends ExplorerEvent {}

// States
enum ExplorerStatus { initial, loading, success, failure }

class ExplorerState extends Equatable {
  const ExplorerState({
    this.status = ExplorerStatus.initial,
    this.blocks = const <BlockModel>[],
    this.transactions = const <TransactionModel>[],
    this.errorMessage,
  });

  final ExplorerStatus status;
  final List<BlockModel> blocks;
  final List<TransactionModel> transactions;
  final String? errorMessage;

  ExplorerState copyWith({
    ExplorerStatus? status,
    List<BlockModel>? blocks,
    List<TransactionModel>? transactions,
    String? errorMessage,
  }) {
    return ExplorerState(
      status: status ?? this.status,
      blocks: blocks ?? this.blocks,
      transactions: transactions ?? this.transactions,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, blocks, transactions, errorMessage];
}

// BLoC
class ExplorerBloc extends Bloc<ExplorerEvent, ExplorerState> {
  final ExplorerRepository explorerRepository;
  Timer? _autoRefreshTimer;

  ExplorerBloc({required this.explorerRepository}) : super(const ExplorerState()) {
    on<LoadRecentBlocks>(_onLoadRecentBlocks);
    on<LoadRecentTransactions>(_onLoadRecentTransactions);
    on<SearchEvent>(_onSearch);
    on<SearchByAddress>(_onSearchByAddress);
    on<SearchByHash>(_onSearchByHash);
    on<SearchByBlockNumber>(_onSearchByBlockNumber);
    on<RefreshData>(_onRefreshData);
    on<StartAutoRefresh>(_onStartAutoRefresh);
    on<StopAutoRefresh>(_onStopAutoRefresh);
  }

  @override
  Future<void> close() {
    _autoRefreshTimer?.cancel();
    return super.close();
  }

  Future<void> _onLoadRecentBlocks(
    LoadRecentBlocks event,
    Emitter<ExplorerState> emit,
  ) async {
    emit(state.copyWith(status: ExplorerStatus.loading));
    try {
      final blocks = await explorerRepository.getRecentBlocks();
      emit(state.copyWith(
        status: ExplorerStatus.success,
        blocks: blocks,
        transactions: [],
      ));
    } catch (e) {
      emit(state.copyWith(status: ExplorerStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadRecentTransactions(
    LoadRecentTransactions event,
    Emitter<ExplorerState> emit,
  ) async {
    emit(state.copyWith(status: ExplorerStatus.loading));
    try {
      final transactions = await explorerRepository.getRecentTransactions();
      emit(state.copyWith(
        status: ExplorerStatus.success,
        blocks: [],
        transactions: transactions,
      ));
    } catch (e) {
      emit(state.copyWith(status: ExplorerStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onSearch(
    SearchEvent event,
    Emitter<ExplorerState> emit,
  ) async {
    emit(state.copyWith(status: ExplorerStatus.loading));
    try {
      final blocks = await explorerRepository.search(event.query);
      emit(state.copyWith(
        status: ExplorerStatus.success,
        blocks: blocks,
        transactions: [],
      ));
    } catch (e) {
      emit(state.copyWith(status: ExplorerStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onSearchByAddress(
    SearchByAddress event,
    Emitter<ExplorerState> emit,
  ) async {
    emit(state.copyWith(status: ExplorerStatus.loading));
    try {
      final blocks = await explorerRepository.getBlocksByAddress(event.address);
      emit(state.copyWith(
        status: ExplorerStatus.success,
        blocks: blocks,
        transactions: [],
      ));
    } catch (e) {
      emit(state.copyWith(status: ExplorerStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onSearchByHash(
    SearchByHash event,
    Emitter<ExplorerState> emit,
  ) async {
    emit(state.copyWith(status: ExplorerStatus.loading));
    try {
      final blocks = await explorerRepository.getBlockByHash(event.hash);
      emit(state.copyWith(
        status: ExplorerStatus.success,
        blocks: blocks,
        transactions: [],
      ));
    } catch (e) {
      emit(state.copyWith(status: ExplorerStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onSearchByBlockNumber(
    SearchByBlockNumber event,
    Emitter<ExplorerState> emit,
  ) async {
    emit(state.copyWith(status: ExplorerStatus.loading));
    try {
      final blocks = await explorerRepository.getBlockByNumber(event.blockNumber);
      emit(state.copyWith(
        status: ExplorerStatus.success,
        blocks: blocks,
        transactions: [],
      ));
    } catch (e) {
      emit(state.copyWith(status: ExplorerStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onRefreshData(
    RefreshData event,
    Emitter<ExplorerState> emit,
  ) async {
    // Re-fetch the current data based on the current view
    // For now, we'll just reload recent blocks
    add(LoadRecentBlocks());
  }

  Future<void> _onStartAutoRefresh(
    StartAutoRefresh event,
    Emitter<ExplorerState> emit,
  ) async {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      add(RefreshData());
    });
  }

  Future<void> _onStopAutoRefresh(
    StopAutoRefresh event,
    Emitter<ExplorerState> emit,
  ) async {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = null;
  }
}

