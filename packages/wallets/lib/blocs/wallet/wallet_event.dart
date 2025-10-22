part of 'wallet_bloc.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object?> get props => [];
}

class LoadWallet extends WalletEvent {
  final String? userId;

  const LoadWallet({this.userId});

  @override
  List<Object?> get props => [userId];
}

class RefreshWallet extends WalletEvent {
  const RefreshWallet();
}

class SendCoins extends WalletEvent {
  final String recipientAddress;
  final double amount;
  final String? memo;
  final double? fee;

  const SendCoins({
    required this.recipientAddress,
    required this.amount,
    this.memo,
    this.fee,
  });

  @override
  List<Object?> get props => [recipientAddress, amount, memo, fee];
}

class RequestCoinsToWallet extends WalletEvent {
  final double amount;
  final String? description;

  const RequestCoinsToWallet({
    required this.amount,
    this.description,
  });

  @override
  List<Object?> get props => [amount, description];
}

class UpdateWalletBalance extends WalletEvent {
  final double newBalance;

  const UpdateWalletBalance({required this.newBalance});

  @override
  List<Object?> get props => [newBalance];
}

class WalletConnectionChanged extends WalletEvent {
  final bool isConnected;

  const WalletConnectionChanged({required this.isConnected});

  @override
  List<Object?> get props => [isConnected];
}

class RetryFailedOperation extends WalletEvent {
  const RetryFailedOperation();
}

class ClearWalletError extends WalletEvent {
  const ClearWalletError();
}

class ExportWallet extends WalletEvent {
  const ExportWallet();
}

class ImportWallet extends WalletEvent {
  final String walletData;

  const ImportWallet({required this.walletData});

  @override
  List<Object?> get props => [walletData];
}

class SwitchToOfflineMode extends WalletEvent {
  const SwitchToOfflineMode();
}

class SwitchToOnlineMode extends WalletEvent {
  const SwitchToOnlineMode();
}
