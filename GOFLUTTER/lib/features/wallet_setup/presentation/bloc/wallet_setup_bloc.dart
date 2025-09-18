
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/repositories/wallet_setup_repository.dart';

// Events
abstract class WalletSetupEvent extends Equatable {
  const WalletSetupEvent();

  @override
  List<Object> get props => [];
}

class CreateWallet extends WalletSetupEvent {
  final String password;

  const CreateWallet({required this.password});

  @override
  List<Object> get props => [password];
}

class ImportWallet extends WalletSetupEvent {
  final String? privateKey;
  final String? fileContent;
  final String? password;

  const ImportWallet({
    this.privateKey,
    this.fileContent,
    this.password,
  });

  @override
  List<Object> get props => [privateKey ?? '', fileContent ?? '', password ?? ''];
}

// States
abstract class WalletSetupState extends Equatable {
  const WalletSetupState();

  @override
  List<Object> get props => [];
}

class WalletSetupInitial extends WalletSetupState {}

class WalletSetupLoading extends WalletSetupState {}

class WalletSetupSuccess extends WalletSetupState {
  final String message;

  const WalletSetupSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class WalletSetupError extends WalletSetupState {
  final String message;

  const WalletSetupError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class WalletSetupBloc extends Bloc<WalletSetupEvent, WalletSetupState> {
  final WalletSetupRepository walletSetupRepository;

  WalletSetupBloc({required this.walletSetupRepository}) : super(WalletSetupInitial()) {
    on<CreateWallet>(_onCreateWallet);
    on<ImportWallet>(_onImportWallet);
  }

  Future<void> _onCreateWallet(
    CreateWallet event,
    Emitter<WalletSetupState> emit,
  ) async {
    emit(WalletSetupLoading());
    try {
      await walletSetupRepository.createWallet(event.password);
      emit(const WalletSetupSuccess(message: 'Wallet created successfully!'));
    } catch (e) {
      emit(WalletSetupError(e.toString()));
    }
  }

  Future<void> _onImportWallet(
    ImportWallet event,
    Emitter<WalletSetupState> emit,
  ) async {
    emit(WalletSetupLoading());
    try {
      await walletSetupRepository.importWallet(event.privateKey, event.fileContent, event.password);
      emit(const WalletSetupSuccess(message: 'Wallet imported successfully!'));
    } catch (e) {
      emit(WalletSetupError(e.toString()));
    }
  }
}
