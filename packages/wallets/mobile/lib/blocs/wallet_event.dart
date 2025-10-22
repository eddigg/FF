// products/wallets/mobile/lib/blocs/wallet_event.dart
part of 'wallet_bloc.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object> get props => [];
}

class LoadWallet extends WalletEvent {}

class SendTransaction extends WalletEvent {
  final String to;
  final double amount;

  const SendTransaction(this.to, this.amount);

  @override
  List<Object> get props => [to, amount];
}

class RefreshBalance extends WalletEvent {}
