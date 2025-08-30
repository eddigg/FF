// Imports
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:cercaend/backend/models/status_model.dart';
import 'package:cercaend/backend/models/wallet_info_model.dart';
import 'package:cercaend/backend/api_client.dart'; 

//This annotation will generate a mock http.Client class in the same directory with the name 'api_client_test.mocks.dart'
@GenerateMocks([http.Client])
import 'api_client_test.mocks.dart';

void main() {
  group('ApiClient', () {
    late MockClient mockClient;
    late ApiClient apiClient;

    setUp(() {
      mockClient = MockClient();
      apiClient = ApiClient(mockClient);
    });

    test('fetches status successfully', () async {
      // 1. Arrange
      final jsonResponse = '''
      {
        "blockHeight": 8675309,
        "txPoolSize": 42,
        "isValidator": true,
        "validatorAddress": "atlasvaloper1abcdefghijklmnopqrstuvwxyz123456",
        "stakeAmount": 1000000,
        "totalValidators": 100,
        "walletBalance": 5000,
        "walletStaked": 1000000,
        "totalBalance": 1005000,
        "mode": "validator"
      }
      ''';
      when(mockClient.get(Uri.parse('http://localhost:8080/status')))
          .thenAnswer((_) async => http.Response(jsonResponse, 200));

      // 2. Act
      final status = await apiClient.getStatus();

      // 3. Assert
      expect(status, isA<AppStatus>());
      expect(status.blockHeight, 8675309);
      expect(status.txPoolSize, 42);
      expect(status.isValidator, true);
      expect(status.totalValidators, 100);
    });

    test('throws an exception if the http call completes with an error', () {
       // Arrange
      when(mockClient.get(Uri.parse('http://localhost:8080/status')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      // Act & Assert
      expect(apiClient.getStatus(), throwsException);
    });

    test('fetches wallet info successfully', () async {
      // Arrange
      final walletAddress = '0x12345';
      final jsonResponse = '''
      {
        "success": true,
        "data": {
          "address": "0x12345",
          "balance": 5000,
          "isValidator": false,
          "nonce": 1
        }
      }
      ''';
      when(mockClient.get(Uri.parse('http://localhost:8080/flutterflow/wallet-info?address=$walletAddress')))
          .thenAnswer((_) async => http.Response(jsonResponse, 200));

      // Act
      final walletInfo = await apiClient.getWalletInfo(walletAddress);

      // Assert
      expect(walletInfo, isA<AppWalletInfo>());
      expect(walletInfo.address, walletAddress);
      expect(walletInfo.balance, 5000);
    });
  });
}
