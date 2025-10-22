part of 'wallet_bloc.dart';

abstract class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object?> get props => [];
}

class WalletInitial extends WalletState {
  const WalletInitial();
}

class WalletLoading extends WalletState {
  const WalletLoading();
}

class WalletLoaded extends WalletState {
  final Wallet wallet;
  final List<Transaction> recentTransactions;
  final bool isConnected;

  const WalletLoaded({
    required this.wallet,
    required this.recentTransactions,
    this.isConnected = true,
  });

  @override
  List<Object?> get props => [wallet, recentTransactions, isConnected];

  WalletLoaded copyWith({
    Wallet? wallet,
    List<Transaction>? recentTransactions,
    bool? isConnected,
  }) {
    return WalletLoaded(
      wallet: wallet ?? this.wallet,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      isConnected: isConnected ?? this.isConnected,
    );
  }
}

class WalletError extends WalletState {
  final String message;
  final Object? error;
  final bool isNetworkError;

  const WalletError({
    required this.message,
    this.error,
    this.isNetworkError = false,
  });

  @override
  List<Object?> get props => [message, error, isNetworkError];
}

class WalletSendingCoins extends WalletState {
  final Transaction pendingTransaction;

  const WalletSendingCoins({required this.pendingTransaction});

  @override
  List<Object?> get props => [pendingTransaction];
}

class WalletTransactionSuccess extends WalletState {
  final Transaction transaction;
  final String? message;

  const WalletTransactionSuccess({
    required this.transaction,
    this.message,
  });

  @override
  List<Object?> get props => [transaction, message];
}

class WalletBalanceUpdating extends WalletState {
  const WalletBalanceUpdating();
}

class WalletOfflineMode extends WalletState {
  final Wallet cachedWallet;
  final String offlineMessage;

  const WalletOfflineMode({
    required this.cachedWallet,
    this.offlineMessage = 'Working offline - blockchain not available',
  });

  @override
  List<Object?> get props => [cachedWallet, offlineMessage];
}
