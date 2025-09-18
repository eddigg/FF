import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/transaction_model.dart';
import '../../data/repositories/wallet_repository.dart';
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

  const WalletLoaded({
    required this.address,
    required this.balance,
    required this.transactions,
    required this.accounts,
    this.selectedAccount,
  });

  @override
  List<Object?> get props => [address, balance, transactions, accounts, selectedAccount];

  WalletLoaded copyWith({
    String? address,
    double? balance,
    List<TransactionModel>? transactions,
    List<WalletAccount>? accounts,
    WalletAccount? selectedAccount,
  }) {
    return WalletLoaded(
      address: address ?? this.address,
      balance: balance ?? this.balance,
      transactions: transactions ?? this.transactions,
      accounts: accounts ?? this.accounts,
      selectedAccount: selectedAccount ?? this.selectedAccount,
    );
  }
}

class WalletError extends WalletState {
  final String message;

  const WalletError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final WalletRepository walletRepository;
  final WalletService walletService;

  WalletBloc({required this.walletRepository, required this.walletService}) : super(WalletInitial()) {
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
      final wallet = await walletRepository.getWallet();
      final accounts = await walletService.loadAccounts();
      final selectedAccount = await walletService.getSelectedAccount();
      emit(WalletLoaded(
        address: wallet.address,
        balance: wallet.balance,
        transactions: wallet.transactions,
        accounts: accounts,
        selectedAccount: selectedAccount,
      ));
    } catch (e) {
      emit(WalletError(e.toString()));
    }
  }

  Future<void> _onSendTransaction(
    SendTransaction event,
    Emitter<WalletState> emit,
  ) async {
    try {
      await walletRepository.sendTransaction(event.recipient, event.amount, event.message);
      final wallet = await walletRepository.getWallet(); // Refresh wallet data after sending transaction
      if (state is WalletLoaded) {
        final currentState = state as WalletLoaded;
        emit(currentState.copyWith(
          address: wallet.address,
          balance: wallet.balance,
          transactions: wallet.transactions,
        ));
      }
    } catch (e) {
      emit(WalletError(e.toString()));
    }
  }

  Future<void> _onRequestTestTokens(
    RequestTestTokens event,
    Emitter<WalletState> emit,
  ) async {
    // For now, we'll just reload the wallet to show updated balance
    // In a real implementation, this would call the repository method
    try {
      final wallet = await walletRepository.getWallet();
      if (state is WalletLoaded) {
        final currentState = state as WalletLoaded;
        emit(currentState.copyWith(
          address: wallet.address,
          balance: wallet.balance,
          transactions: wallet.transactions,
        ));
      }
    } catch (e) {
      emit(WalletError(e.toString()));
    }
  }

  Future<void> _onCreateAccount(
    CreateAccount event,
    Emitter<WalletState> emit,
  ) async {
    try {
      final account = await walletService.createAccount(name: event.name);
      final accounts = await walletService.loadAccounts();
      accounts.add(account);
      await walletService.saveAccounts(accounts);
      
      if (state is WalletLoaded) {
        final currentState = state as WalletLoaded;
        emit(currentState.copyWith(accounts: accounts));
      }
    } catch (e) {
      emit(WalletError(e.toString()));
    }
  }

  Future<void> _onImportAccount(
    ImportAccount event,
    Emitter<WalletState> emit,
  ) async {
    try {
      // Import the account
      final walletResponse = await walletService.importWallet(event.privateKey);
      
      // Create a new account object
      final account = WalletAccount(
        name: 'Imported Account',
        privateKeyJwk: walletResponse.privateKey,
        publicKeyJwk: '', // In a real implementation, we'd derive this
        address: walletResponse.address,
      );
      
      // Add to accounts list
      final accounts = await walletService.loadAccounts();
      accounts.add(account);
      await walletService.saveAccounts(accounts);
      
      if (state is WalletLoaded) {
        final currentState = state as WalletLoaded;
        emit(currentState.copyWith(accounts: accounts));
      }
    } catch (e) {
      emit(WalletError(e.toString()));
    }
  }

  Future<void> _onExportAccount(
    ExportAccount event,
    Emitter<WalletState> emit,
  ) async {
    // Export functionality would typically be handled at the UI level
    // since it involves file system operations
    // Just emit the current state to indicate the action was processed
    emit(state);
  }

  Future<void> _onDeleteAccount(
    DeleteAccount event,
    Emitter<WalletState> emit,
  ) async {
    try {
      final accounts = await walletService.loadAccounts();
      accounts.removeWhere((account) => account.privateKeyJwk == event.account.privateKeyJwk);
      await walletService.saveAccounts(accounts);
      
      if (state is WalletLoaded) {
        final currentState = state as WalletLoaded;
        emit(currentState.copyWith(accounts: accounts));
      }
    } catch (e) {
      emit(WalletError(e.toString()));
    }
  }

  Future<void> _onSelectAccount(
    SelectAccount event,
    Emitter<WalletState> emit,
  ) async {
    try {
      await walletService.selectAccount(event.account);
      
      if (state is WalletLoaded) {
        final currentState = state as WalletLoaded;
        emit(currentState.copyWith(selectedAccount: event.account));
      }
    } catch (e) {
      emit(WalletError(e.toString()));
    }
  }

  Future<void> _onLoadAccounts(
    LoadAccounts event,
    Emitter<WalletState> emit,
  ) async {
    try {
      final accounts = await walletService.loadAccounts();
      final selectedAccount = await walletService.getSelectedAccount();
      
      if (state is WalletLoaded) {
        final currentState = state as WalletLoaded;
        emit(currentState.copyWith(accounts: accounts, selectedAccount: selectedAccount));
      }
    } catch (e) {
      emit(WalletError(e.toString()));
    }
  }

  Future<void> _onRegisterAsValidator(
    RegisterAsValidator event,
    Emitter<WalletState> emit,
  ) async {
    try {
      await walletService.registerAsValidator(
        stake: event.stake,
        fullName: event.fullName,
        country: event.country,
        idNumber: event.idNumber,
      );
      
      // Show success message
      if (state is WalletLoaded) {
        final currentState = state as WalletLoaded;
        emit(currentState.copyWith());
      }
    } catch (e) {
      emit(WalletError(e.toString()));
    }
  }
}