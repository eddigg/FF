// products/wallets/mobile/lib/blocs/wallet_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../shared/models/wallet_model.dart';
import '../services/cache_service.dart';
import '../repositories/blockchain_repository.dart';
import '../services/light_node_service.dart';

part 'wallet_event.dart';
part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletModel? _currentWallet;
  final CacheService _cacheService = CacheService();
  final BlockchainRepository _repository = BlockchainRepository();
  final LightNodeService _lightNodeService = LightNodeService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  WalletBloc() : super(WalletInitial()) {
    on<LoadWallet>((event, emit) async {
      emit(WalletLoading());
      try {
        // Check authentication
        final user = _auth.currentUser;
        if (user == null) {
          emit(WalletError('User not authenticated'));
          return;
        }

        // Check cache first for offline support
        final cachedData = await _cacheService.getCachedWalletData();
        if (cachedData != null) {
          _currentWallet = WalletModel.fromJson(cachedData);
          emit(WalletLoaded(_currentWallet!));
        }

        // Start light node for essential syncing
        await _lightNodeService.startLightNode(user.uid, await user.getIdToken());

        // Fetch from API with user token
        final idToken = await user.getIdToken();
        final balance = await _repository.getWalletBalance(user.uid, idToken);
        final transactions = await _repository.getTransactions(user.uid, idToken);
        _currentWallet = WalletModel(
          address: user.uid,
          balance: balance.balance,
          transactions: transactions,
        );
        await _cacheService.cacheWalletData(_currentWallet!.toJson());
        emit(WalletLoaded(_currentWallet!));
      } catch (e) {
        emit(WalletError(e.toString()));
      }
    });

    on<SendTransaction>((event, emit) async {
      if (state is WalletLoaded) {
        emit(WalletLoading());
        try {
          final user = _auth.currentUser;
          if (user == null) {
            emit(WalletError('User not authenticated'));
            return;
          }
          final idToken = await user.getIdToken();
          final txData = {
            'from': (state as WalletLoaded).wallet.address,
            'to': event.to,
            'amount': event.amount,
          };
          final hash = await _repository.submitTransaction(txData, idToken);
          add(RefreshBalance());
        } catch (e) {
          emit(WalletError(e.toString()));
        }
      }
    });

    on<RefreshBalance>((event, emit) async {
      if (state is WalletLoaded && _currentWallet != null) {
        emit(WalletLoading());
        try {
          final user = _auth.currentUser;
          if (user == null) {
            emit(WalletError('User not authenticated'));
            return;
          }
          final idToken = await user.getIdToken();
          final refreshedBalance = await _repository.getWalletBalance(_currentWallet!.address, idToken);
          final refreshedTransactions = await _repository.getTransactions(_currentWallet!.address, idToken);
          final refreshedWallet = WalletModel(
            address: refreshedBalance.address,
            balance: refreshedBalance.balance,
            transactions: refreshedTransactions,
          );
          _currentWallet = refreshedWallet;
          await _cacheService.cacheWalletData(refreshedWallet.toJson());
          emit(WalletLoaded(refreshedWallet));
        } catch (e) {
          emit(WalletError(e.toString()));
        }
      }
    });
  }

  @override
  Future<void> close() {
    _lightNodeService.stopLightNode();
    return super.close();
  }
}
