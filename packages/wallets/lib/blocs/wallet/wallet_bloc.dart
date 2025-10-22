import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

import '../../models/wallet.dart';
import '../../models/transaction.dart';
import '../../repositories/wallet_repository.dart';
import '../../repositories/blockchain_repository.dart';
import '../../services/connectivity_service.dart';

part 'wallet_state.dart';
part 'wallet_event.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final WalletRepository _walletRepository;
  final BlockchainRepository _blockchainRepository;
  final ConnectivityService _connectivityService;

  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  StreamSubscription<bool>? _blockchainSubscription;

  WalletBloc({
    required WalletRepository walletRepository,
    required BlockchainRepository blockchainRepository,
    required ConnectivityService connectivityService,
  })  : _walletRepository = walletRepository,
        _blockchainRepository = blockchainRepository,
        _connectivityService = connectivityService,
        super(const WalletInitial()) {
    on<LoadWallet>(_onLoadWallet);
    on<RefreshWallet>(_onRefreshWallet);
    on<SendCoins>(_onSendCoins);
    on<RequestCoinsToWallet>(_onRequestCoins);
    on<UpdateWalletBalance>(_onUpdateBalance);
    on<WalletConnectionChanged>(_onConnectionChanged);
    on<RetryFailedOperation>(_onRetryFailedOperation);
    on<ClearWalletError>(_onClearError);
    on<ExportWallet>(_onExportWallet);
    on<ImportWallet>(_onImportWallet);
    on<SwitchToOfflineMode>(_onSwitchToOffline);
    on<SwitchToOnlineMode>(_onSwitchToOnline);

    _setupConnectivityMonitoring();
    _setupBlockchainMonitoring();
  }

  void _setupConnectivityMonitoring() {
    _connectivitySubscription = _connectivityService.connectivityStream.listen(
      (result) {
        final isConnected = result != ConnectivityResult.none;
        add(WalletConnectionChanged(isConnected: isConnected));
      },
    );
  }

  void _setupBlockchainMonitoring() {
    _blockchainSubscription = _blockchainRepository.connectionStatus.listen(
      (isConnected) {
        if (!isConnected && state is! WalletOfflineMode) {
          add(const SwitchToOfflineMode());
        } else if (isConnected && state is WalletOfflineMode) {
          add(const SwitchToOnlineMode());
        }
      },
    );
  }

  Future<void> _onLoadWallet(LoadWallet event, Emitter<WalletState> emit) async {
    emit(const WalletLoading());

    try {
      // Try to load cached wallet first for immediate UI
      final cachedWallet = await _walletRepository.getCachedWallet(event.userId);

      if (cachedWallet != null) {
        final recentTxs = await _walletRepository.getRecentTransactions();
        emit(WalletLoaded(
          wallet: cachedWallet,
          recentTransactions: recentTxs,
          isConnected: await _connectivityService.isOnline(),
        ));
      }

      // Then sync with blockchain in background
      await _syncWalletWithBlockchain(event.userId, emit);
    } catch (error) {
      emit(WalletError(
        message: 'Failed to load wallet',
        error: error,
        isNetworkError: error is Exception && error.toString().contains('network'),
      ));
    }
  }

  Future<void> _syncWalletWithBlockchain(String? userId, Emitter<WalletState> emit) async {
    try {
      final syncedWallet = await _blockchainRepository.getWallet(userId);
      final recentTxs = await _blockchainRepository.getRecentTransactions();

      // Cache the updated data
      await _walletRepository.saveWallet(syncedWallet);

      if (state is WalletLoaded) {
        emit((state as WalletLoaded).copyWith(
          wallet: syncedWallet,
          recentTransactions: recentTxs,
          isConnected: true,
        ));
      } else {
        emit(WalletLoaded(
          wallet: syncedWallet,
          recentTransactions: recentTxs,
          isConnected: true,
        ));
      }
    } catch (error) {
      // If blockchain sync fails but we have cached data, stay in loaded state
      if (state is WalletLoaded) {
        emit((state as WalletLoaded).copyWith(isConnected: false));
      }
    }
  }

  Future<void> _onRefreshWallet(RefreshWallet event, Emitter<WalletState> emit) async {
    if (state is! WalletLoaded) return;

    final currentState = state as WalletLoaded;
    emit(currentState.copyWith()); // Trigger loading state

    try {
      final wallet = await _blockchainRepository.getWallet(currentState.wallet.userId);
      final recentTxs = await _blockchainRepository.getRecentTransactions();

      // Update cache
      await _walletRepository.saveWallet(wallet);

      emit(currentState.copyWith(
        wallet: wallet,
        recentTransactions: recentTxs,
        isConnected: true,
      ));
    } catch (error) {
      emit(WalletError(
        message: 'Failed to refresh wallet',
        error: error,
        isNetworkError: true,
      ));
    }
  }

  Future<void> _onSendCoins(SendCoins event, Emitter<WalletState> emit) async {
    if (state is! WalletLoaded) return;

    final currentState = state as WalletLoaded;

    try {
      // Validate sender balance
      if (currentState.wallet.balance < (event.amount + (event.fee ?? 0.01))) {
        emit(const WalletError(message: 'Insufficient balance for transaction'));
        return;
      }

      // Check recipient address format
      if (!await _walletRepository.isValidAddress(event.recipientAddress)) {
        emit(const WalletError(message: 'Invalid recipient address'));
        return;
      }

      // Create transaction
      emit(const WalletBalanceUpdating());

      final transaction = Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        from: currentState.wallet.address,
        to: event.recipientAddress,
        amount: event.amount,
        fee: event.fee ?? 0.01,
        timestamp: DateTime.now(),
        type: TransactionType.send,
        status: TransactionStatus.pending,
        memo: event.memo,
      );

      emit(WalletSendingCoins(pendingTransaction: transaction));

      // Submit to blockchain
      final confirmedTx = await _blockchainRepository.submitTransaction(
        transaction,
        currentState.wallet.privateKey,
      );

      emit(WalletTransactionSuccess(
        transaction: confirmedTx,
        message: 'Transaction sent successfully!',
      ));

    } catch (error) {
      emit(WalletError(
        message: 'Failed to send coins',
        error: error,
        isNetworkError: error.toString().contains('network'),
      ));
    }
  }

  Future<void> _onRequestCoins(RequestCoinsToWallet event, Emitter<WalletState> emit) async {
    if (state is! WalletLoaded) return;

    final currentState = state as WalletLoaded;

    try {
      // Generate payment request for specified amount
      final requestId = await _blockchainRepository.createPaymentRequest(
        currentState.wallet.address,
        event.amount,
        event.description,
      );

      emit(WalletTransactionSuccess(
        transaction: Transaction(
          id: requestId,
          from: 'FAUCET',
          to: currentState.wallet.address,
          amount: event.amount,
          fee: 0,
          timestamp: DateTime.now(),
          type: TransactionType.receive,
          status: TransactionStatus.requested,
          memo: event.description,
        ),
        message: 'Payment request created successfully!',
      ));
    } catch (error) {
      emit(WalletError(
        message: 'Failed to create payment request',
        error: error,
      ));
    }
  }

  Future<void> _onUpdateBalance(UpdateWalletBalance event, Emitter<WalletState> emit) async {
    if (state is! WalletLoaded) return;

    final currentState = state as WalletLoaded;
    final updatedWallet = currentState.wallet.copyWith(balance: event.newBalance);

    // Update cache
    await _walletRepository.saveWallet(updatedWallet);

    emit(currentState.copyWith(wallet: updatedWallet));
  }

  Future<void> _onConnectionChanged(WalletConnectionChanged event, Emitter<WalletState> emit) async {
    if (state is WalletLoaded) {
      emit((state as WalletLoaded).copyWith(isConnected: event.isConnected));
    }
  }

  Future<void> _onRetryFailedOperation(RetryFailedOperation event, Emitter<WalletState> emit) async {
    // Retry based on last error
    add(const RefreshWallet());
  }

  void _onClearError(ClearWalletError event, Emitter<WalletState> emit) {
    emit(const WalletInitial());
  }

  Future<void> _onExportWallet(ExportWallet event, Emitter<WalletState> emit) async {
    if (state is! WalletLoaded) return;

    try {
      final wallet = (state as WalletLoaded).wallet;
      final exportData = {
        'address': wallet.address,
        'publicKey': wallet.publicKey,
        'encryptedPrivateKey': wallet.encryptedPrivateKey,
        'balance': wallet.balance,
        'createdAt': wallet.createdAt.toIso8601String(),
      };

      final jsonData = jsonEncode(exportData);
      // In a real implementation, this would be saved to secure storage
      // or shared via platform-specific APIs

      emit(WalletTransactionSuccess(
        transaction: Transaction.dummy(),
        message: 'Wallet export data prepared (not yet saved to file)',
      ));
    } catch (error) {
      emit(WalletError(
        message: 'Failed to export wallet',
        error: error,
      ));
    }
  }

  Future<void> _onImportWallet(ImportWallet event, Emitter<WalletState> emit) async {
    try {
      final walletData = jsonDecode(event.walletData) as Map<String, dynamic>;

      final importedWallet = Wallet(
        userId: walletData['userId'] as String? ?? 'imported',
        address: walletData['address'] as String,
        privateKey: '', // Would be decrypted separately
        publicKey: walletData['publicKey'] as String,
        encryptedPrivateKey: walletData['encryptedPrivateKey'] as String,
        balance: (walletData['balance'] as num).toDouble(),
        createdAt: DateTime.parse(walletData['createdAt'] as String),
      );

      await _walletRepository.saveWallet(importedWallet);

      emit(WalletLoaded(
        wallet: importedWallet,
        recentTransactions: [],
        isConnected: await _connectivityService.isOnline(),
      ));

      emit(WalletTransactionSuccess(
        transaction: Transaction.dummy(),
        message: 'Wallet imported successfully!',
      ));
    } catch (error) {
      emit(WalletError(
        message: 'Failed to import wallet - invalid data format',
        error: error,
      ));
    }
  }

  Future<void> _onSwitchToOffline(SwitchToOfflineMode event, Emitter<WalletState> emit) async {
    if (state is! WalletLoaded) return;

    final currentState = state as WalletLoaded;
    final cachedWallet = await _walletRepository.getCachedWallet(currentState.wallet.userId);

    if (cachedWallet != null) {
      emit(WalletOfflineMode(cachedWallet: cachedWallet));
    }
  }

  Future<void> _onSwitchToOnline(SwitchToOnlineMode event, Emitter<WalletState> emit) async {
    if (state is! WalletOfflineMode) return;

    final offlineState = state as WalletOfflineMode;
    emit(const WalletBalanceUpdating());

    try {
      final syncedWallet = await _blockchainRepository.getWallet(offlineState.cachedWallet.userId);
      final recentTxs = await _blockchainRepository.getRecentTransactions();

      emit(WalletLoaded(
        wallet: syncedWallet,
        recentTransactions: recentTxs,
        isConnected: true,
      ));
    } catch (error) {
      emit(WalletError(
        message: 'Failed to sync with blockchain',
        error: error,
      ));
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    _blockchainSubscription?.cancel();
    return super.close();
  }
}
