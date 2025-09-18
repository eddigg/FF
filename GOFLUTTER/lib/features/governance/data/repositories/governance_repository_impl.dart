import '../models/proposal_model.dart';
import '../models/governance_stats_model.dart';
import '../models/governance_parameters_model.dart';
import '../models/treasury_info_model.dart';
import 'governance_repository.dart';
import '../data_sources/governance_api_client.dart';

class GovernanceRepositoryImpl implements GovernanceRepository {
  final GovernanceApiClient apiClient;

  GovernanceRepositoryImpl({required this.apiClient});

  @override
  Future<List<ProposalModel>> getProposals() async {
    final data = await apiClient.fetchProposals();
    return data.map((item) => ProposalModel.fromJson(item)).toList();
  }

  @override
  Future<GovernanceStatsModel> getGovernanceStats() async {
    final data = await apiClient.fetchGovernanceStats();
    return GovernanceStatsModel.fromJson(data);
  }

  @override
  Future<GovernanceParametersModel> getGovernanceParameters() async {
    final data = await apiClient.fetchGovernanceParameters();
    return GovernanceParametersModel.fromJson(data);
  }

  @override
  Future<TreasuryInfoModel> getTreasuryInfo() async {
    final data = await apiClient.fetchTreasuryInfo();
    return TreasuryInfoModel.fromJson(data);
  }

  @override
  Future<ProposalModel> submitProposal({
    required String proposer,
    required String description,
    required String actions,
    required int duration,
  }) async {
    final data = await apiClient.submitProposal(
      proposer: proposer,
      description: description,
      actions: actions,
      duration: duration,
    );
    return ProposalModel.fromJson(data);
  }

  @override
  Future<void> castVote({
    required String proposalID,
    required String voter,
    required String choice,
    required int weight,
  }) async {
    await apiClient.castVote(
      proposalID: proposalID,
      voter: voter,
      choice: choice,
      weight: weight,
    );
  }
}