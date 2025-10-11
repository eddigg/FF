import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/transaction_model.dart';
import '../../domain/entities/account.dart';
import '../../services/wallet_service.dart';

// Events
abstract class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object?> get props => [];
}

class LoadWallet extends WalletEvent {}

class SendTransaction extends WalletEvent {
  final String recipient;
  final double amount;
  final String? message;

  const SendTransaction({
    required this.recipient,
    required this.amount,
    this.message,
  });

  @override
  List<Object?> get props => [recipient, amount, message];
}

class RequestTestTokens extends WalletEvent {}

// Multi-account events
class CreateAccount extends WalletEvent {
  final String? name;

  const CreateAccount({this.name});

  @override
  List<Object?> get props => [name];
}

class ImportAccount extends WalletEvent {
  final String privateKey;

  const ImportAccount(this.privateKey);

  @override
  List<Object?> get props => [privateKey];
}

class ExportAccount extends WalletEvent {
  final WalletAccount account;

  const ExportAccount(this.account);

  @override
  List<Object?> get props => [account];
}

class DeleteAccount extends WalletEvent {
  final WalletAccount account;

  const DeleteAccount(this.account);

  @override
  List<Object?> get props => [account];
}

class SelectAccount extends WalletEvent {
  final WalletAccount account;

  const SelectAccount(this.account);

  @override
  List<Object?> get props => [account];
}

class LoadAccounts extends WalletEvent {}

class RegisterAsValidator extends WalletEvent {
  final int stake;
  final String fullName;
  final String country;
  final String idNumber;

  const RegisterAsValidator({
    required this.stake,
    required this.fullName,
    required this.country,
    required this.idNumber,
  });

  @override
  List<Object?> get props => [stake, fullName, country, idNumber];
}

// States
abstract class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object?> get props => [];
}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletLoaded extends WalletState {
  final String address;
  final double balance;
  final List<TransactionModel> transactions;
  final List<WalletAccount> accounts;
  final WalletAccount? selectedAccount;
  final int selectedAccountIndex;

  const WalletLoaded({
    required this.address,
    required this.balance,
    required this.transactions,
    required this.accounts,
    this.selectedAccount,
    this.selectedAccountIndex = 0,
  });

  @override
  List<Object?> get props => [
    address,
    balance,
    transactions,
    accounts,
    selectedAccount,
    selectedAccountIndex,
  ];

  WalletLoaded copyWith({
    String? address,
    double? balance,
    List<TransactionModel>? transactions,
    List<WalletAccount>? accounts,
    WalletAccount? selectedAccount,
    int? selectedAccountIndex,
  }) {
    return WalletLoaded(
      address: address ?? this.address,
      balance: balance ?? this.balance,
      transactions: transactions ?? this.transactions,
      accounts: accounts ?? this.accounts,
      selectedAccount: selectedAccount ?? this.selectedAccount,
      selectedAccountIndex: selectedAccountIndex ?? this.selectedAccountIndex,
    );
  }
}

class WalletError extends WalletState {
  final String message;

  const WalletError(this.message);

  @override
  List<Object?> get props => [message];
}

class WalletActionSuccess extends WalletState {
  final String message;

  const WalletActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final WalletService walletService;

  WalletBloc({required this.walletService}) : super(WalletInitial()) {
    on<LoadWallet>(_onLoadWallet);
    on<SendTransaction>(_onSendTransaction);
    on<RequestTestTokens>(_onRequestTestTokens);
    on<CreateAccount>(_onCreateAccount);
    on<ImportAccount>(_onImportAccount);
    on<ExportAccount>(_onExportAccount);
    on<DeleteAccount>(_onDeleteAccount);
    on<SelectAccount>(_onSelectAccount);
    on<LoadAccounts>(_onLoadAccounts);
    on<RegisterAsValidator>(_onRegisterAsValidator);
  }

  Future<void> _onLoadWallet(
    LoadWallet event,
    Emitter<WalletState> emit,
  ) async {
    emit(WalletLoading());
    try {
      final balance = await walletService.getWalletBalance();
      final address = await walletService.getAddress();
      final transactions = await walletService.getTransactionHistory();
      emit(
        WalletLoaded(
          address: address ?? 'No address found',
          balance: balance,
          transactions: transactions
              .map((tx) => TransactionModel.fromJson(tx))
              .toList(),
          accounts: [],
        ),
      );
    } catch (e) {
      emit(WalletError(e.toString()));
    }
  }

  Future<void> _onSendTransaction(
    SendTransaction event,
    Emitter<WalletState> emit,
  ) async {
    try {
      await walletService.sendTransaction(
        event.recipient,
        event.amount.toInt(),
      );
      add(LoadWallet());
    } catch (e) {
      emit(WalletError(e.toString()));
    }
  }

  Future<void> _onRequestTestTokens(
    RequestTestTokens event,
    Emitter<WalletState> emit,
  ) async {
    // TODO: Implement request test tokens
  }

  Future<void> _onCreateAccount(
    CreateAccount event,
    Emitter<WalletState> emit,
  ) async {
    try {
      await walletService.createWallet();
      add(LoadWallet());
    } catch (e) {
      emit(WalletError(e.toString()));
    }
  }

  Future<void> _onImportAccount(
    ImportAccount event,
    Emitter<WalletState> emit,
  ) async {
    try {
      await walletService.importWallet(
        event.privateKey,
      ); // Assuming privateKey is the mnemonic
      add(LoadWallet());
    } catch (e) {
      emit(WalletError(e.toString()));
    }
  }

  Future<void> _onExportAccount(
    ExportAccount event,
    Emitter<WalletState> emit,
  ) async {
    // TODO: Implement export account
  }

  Future<void> _onDeleteAccount(
    DeleteAccount event,
    Emitter<WalletState> emit,
  ) async {
    // TODO: Implement delete account
  }

  Future<void> _onSelectAccount(
    SelectAccount event,
    Emitter<WalletState> emit,
  ) async {
    // TODO: Implement select account
  }

  Future<void> _onLoadAccounts(
    LoadAccounts event,
    Emitter<WalletState> emit,
  ) async {
    // TODO: Implement load accounts
  }

  Future<void> _onRegisterAsValidator(
    RegisterAsValidator event,
    Emitter<WalletState> emit,
  ) async {
    // TODO: Implement register as validator
  }
}
