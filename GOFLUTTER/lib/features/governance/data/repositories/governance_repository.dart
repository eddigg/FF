import '../models/proposal_model.dart';
import '../models/governance_stats_model.dart';
import '../models/governance_parameters_model.dart';
import '../models/treasury_info_model.dart';

abstract class GovernanceRepository {
  Future<List<ProposalModel>> getProposals();
  Future<GovernanceStatsModel> getGovernanceStats();
  Future<GovernanceParametersModel> getGovernanceParameters();
  Future<TreasuryInfoModel> getTreasuryInfo();
  Future<ProposalModel> submitProposal({
    required String proposer,
    required String description,
    required String actions,
    required int duration,
  });
  Future<void> castVote({
    required String proposalID,
    required String voter,
    required String choice,
    required int weight,
  });
}
