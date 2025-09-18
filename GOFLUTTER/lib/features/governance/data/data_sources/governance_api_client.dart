import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';

class GovernanceApiClient {
  final ApiClient _apiClient;

  GovernanceApiClient(this._apiClient);

  Future<List<dynamic>> fetchProposals() async {
    try {
      final response = await _apiClient.dio.get('/governance/proposals');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch proposals: $e');
    }
  }

  Future<Map<String, dynamic>> fetchGovernanceStats() async {
    try {
      final response = await _apiClient.dio.get('/governance/stats');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch governance stats: $e');
    }
  }

  Future<Map<String, dynamic>> fetchGovernanceParameters() async {
    try {
      final response = await _apiClient.dio.get('/governance/parameters');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch governance parameters: $e');
    }
  }

  Future<Map<String, dynamic>> fetchTreasuryInfo() async {
    try {
      final response = await _apiClient.dio.get('/governance/treasury');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch treasury info: $e');
    }
  }

  Future<Map<String, dynamic>> submitProposal({
    required String proposer,
    required String description,
    required String actions,
    required int duration,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '/governance/proposals',
        data: {
          'proposer': proposer,
          'description': description,
          'actions': actions,
          'duration': duration,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to submit proposal: $e');
    }
  }

  Future<Map<String, dynamic>> castVote({
    required String proposalID,
    required String voter,
    required String choice,
    required int weight,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '/governance/votes',
        data: {
          'proposalID': proposalID,
          'voter': voter,
          'choice': choice,
          'weight': weight,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to cast vote: $e');
    }
  }
}