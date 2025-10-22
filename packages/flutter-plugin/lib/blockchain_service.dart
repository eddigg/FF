// integrations/flutter-plugin/lib/blockchain_service.dart
import 'package:grpc/grpc.dart';
import 'package:shared/proto/blockchain.pbgrpc.dart';

class BlockchainService {
  final BlockchainClient _client;

  BlockchainService({String nodeUrl = 'localhost:50051'})
      : _client = BlockchainClient(
          ClientChannel(
            nodeUrl,
            options: const ChannelOptions(
              credentials: ChannelCredentials.insecure(),
            ),
          ),
        );

  Future<Wallet> createWallet() async {
    final request = CreateWalletRequest();
    final response = await _client.createWallet(request);
    return Wallet.fromProtobuf(response.wallet);
  }

  Future<Transaction> sendTransaction({
    required String to,
    required double amount,
    Map<String, String>? metadata,
  }) async {
    final request = SendTransactionRequest()
      ..to = to
      ..amount = amount
      ..metadata.addAll(metadata ?? {});

    final response = await _client.sendTransaction(request);
    return Transaction.fromProtobuf(response.transaction);
  }

  Stream<Transaction> subscribeToTransactions(String address) {
    final request = SubscriptionRequest()..address = address;
    return _client.subscribeToTransactions(request)
        .map((event) => Transaction.fromProtobuf(event.transaction));
  }
}
