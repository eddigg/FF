import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';

import 'package:atlas_blockchain_flutter/core/network/api_client.dart';
import 'package:atlas_blockchain_flutter/core/services/data_fetching_service.dart';
import 'package:atlas_blockchain_flutter/core/services/wallet_management_service.dart';

// Manual mocks
class MockApiClient extends Mock implements ApiClient {}
class MockWalletManagementService extends Mock implements WalletManagementService {}
class MockDio extends Mock implements Dio {}
void main() {
  group('DataFetchingService Tests', () {
    late MockApiClient mockApiClient;
    late MockWalletManagementService mockWalletService;
    late DataFetchingService dataFetchingService;
    late MockDio mockDio;

    setUp(() {
      mockApiClient = MockApiClient();
      mockWalletService = MockWalletManagementService();
      mockDio = MockDio();
      
      // Override the dio getter to return our mock
      when(mockApiClient.dio).thenReturn(mockDio);
      
      dataFetchingService = DataFetchingService(mockApiClient, mockWalletService);
    });

    test('fetchWalletBalance returns balance when API call succeeds', () async {
      const testAddress = 'test_address';
      const expectedBalance = '1000';
      
      final response = Response(
        statusCode: 200,
        data: {'balance': expectedBalance},
        requestOptions: RequestOptions(path: '/balance'),
      );
      
      when(mockDio.get('/balance?address=$testAddress')).thenAnswer((_) async => response);
      
      final result = await dataFetchingService.fetchWalletBalance(testAddress);
      
      expect(result, expectedBalance);
    });

    test('fetchWalletBalance returns Error when API call fails', () async {
      const testAddress = 'test_address';
      
      when(mockDio.get('/balance?address=$testAddress')).thenThrow(Exception('API Error'));
      
      final result = await dataFetchingService.fetchWalletBalance(testAddress);
      
      expect(result, 'Error');
    });

    test('fetchRecentTransactions returns transactions when API call succeeds', () async {
      const limit = 5;
      final expectedTransactions = [
        {'id': '1', 'amount': 100},
        {'id': '2', 'amount': 200},
      ];
      
      final response = Response(
        statusCode: 200,
        data: expectedTransactions,
        requestOptions: RequestOptions(path: '/mempool'),
      );
      
      when(mockDio.get('/mempool?limit=$limit')).thenAnswer((_) async => response);
      
      final result = await dataFetchingService.fetchRecentTransactions(limit: limit);
      
      expect(result, expectedTransactions);
    });

    test('fetchRecentTransactions returns empty list when API call fails', () async {
      const limit = 5;
      
      when(mockDio.get('/mempool?limit=$limit')).thenThrow(Exception('API Error'));
      
      final result = await dataFetchingService.fetchRecentTransactions(limit: limit);
      
      expect(result, isEmpty);
    });

    test('fetchNetworkData returns peers when API call succeeds', () async {
      final expectedPeers = ['peer1', 'peer2', 'peer3'];
      
      final response = Response(
        statusCode: 200,
        data: expectedPeers,
        requestOptions: RequestOptions(path: '/peers'),
      );
      
      when(mockDio.get('/peers')).thenAnswer((_) async => response);
      
      final result = await dataFetchingService.fetchNetworkData();
      
      expect(result['peers'], expectedPeers);
      expect(result['count'], expectedPeers.length);
    });

    test('fetchNetworkData returns empty data when API call fails', () async {
      when(mockDio.get('/peers')).thenThrow(Exception('API Error'));
      
      final result = await dataFetchingService.fetchNetworkData();
      
      expect(result['peers'], isEmpty);
      expect(result['count'], 0);
    });

    test('fetchBlockchainData returns blocks when API call succeeds', () async {
      const limit = 10;
      final expectedBlocks = [
        {
          'Index': 1,
          'Hash': 'hash1',
          'Transactions': [
            {'id': 'tx1'},
            {'id': 'tx2'},
          ],
        },
        {
          'Index': 2,
          'Hash': 'hash2',
          'Transactions': [
            {'id': 'tx3'},
          ],
        },
      ];
      
      final response = Response(
        statusCode: 200,
        data: expectedBlocks,
        requestOptions: RequestOptions(path: '/blocks'),
      );
      
      when(mockDio.get('/blocks?limit=$limit')).thenAnswer((_) async => response);
      
      final result = await dataFetchingService.fetchBlockchainData(limit: limit);
      
      expect(result['blocks'], expectedBlocks);
      expect(result['blockCount'], expectedBlocks.length);
      expect(result['transactionCount'], 3); // 2 + 1 transactions
    });

    test('fetchBlockchainData returns empty data when API call fails', () async {
      const limit = 10;
      
      when(mockDio.get('/blocks?limit=$limit')).thenThrow(Exception('API Error'));
      
      final result = await dataFetchingService.fetchBlockchainData(limit: limit);
      
      expect(result['blocks'], isEmpty);
      expect(result['blockCount'], 0);
      expect(result['transactionCount'], 0);
    });

    test('fetchValidatorInfo returns validator data when API call succeeds', () async {
      const testAddress = 'validator_address';
      const expectedStake = '5000';
      const expectedRank = '1';
      
      when(mockWalletService.getWalletAddress()).thenAnswer((_) async => testAddress);
      
      final response = Response(
        statusCode: 200,
        data: {
          'stake': expectedStake,
          'rank': expectedRank,
        },
        requestOptions: RequestOptions(path: '/validator'),
      );
      
      when(mockDio.get('/validator?address=$testAddress')).thenAnswer((_) async => response);
      
      final result = await dataFetchingService.fetchValidatorInfo();
      
      expect(result['stake'], expectedStake);
      expect(result['rank'], expectedRank);
    });

    test('fetchValidatorInfo returns default values when wallet is not loaded', () async {
      when(mockWalletService.getWalletAddress()).thenAnswer((_) async => '(not loaded)');
      
      final result = await dataFetchingService.fetchValidatorInfo();
      
      expect(result['stake'], '0');
      expect(result['rank'], 'Not a validator');
    });

    test('fetchValidatorInfo returns error values when API call fails', () async {
      const testAddress = 'validator_address';
      
      when(mockWalletService.getWalletAddress()).thenAnswer((_) async => testAddress);
      when(mockDio.get('/validator?address=$testAddress')).thenThrow(Exception('API Error'));
      
      final result = await dataFetchingService.fetchValidatorInfo();
      
      expect(result['stake'], 'Error');
      expect(result['rank'], 'Error');
    });
  });
}