import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/proposal_model.dart';
import '../../data/models/governance_stats_model.dart';
import '../../data/models/governance_parameters_model.dart';
import '../../data/models/treasury_info_model.dart';
import '../../data/repositories/governance_repository.dart';

part 'governance_event.dart';
part 'governance_state.dart';

// Events
abstract class GovernanceEvent extends Equatable {
  const GovernanceEvent();

  @override
  List<Object> get props => [];
}

class LoadGovernanceData extends GovernanceEvent {}

class SubmitProposal extends GovernanceEvent {
  final String proposer;
  final String description;
  final String actions;
  final int duration;

  const SubmitProposal({
    required this.proposer,
    required this.description,
    required this.actions,
    required this.duration,
  });

  @override
  List<Object> get props => [proposer, description, actions, duration];
}

class CastVote extends GovernanceEvent {
  final String proposalID;
  final String voter;
  final String choice;
  final int weight;

  const CastVote({
    required this.proposalID,
    required this.voter,
    required this.choice,
    required this.weight,
  });

  @override
  List<Object> get props => [proposalID, voter, choice, weight];
}

// States
abstract class GovernanceState extends Equatable {
  const GovernanceState();

  @override
  List<Object> get props => [];
}

class GovernanceInitial extends GovernanceState {}

class GovernanceLoading extends GovernanceState {}

class GovernanceLoaded extends GovernanceState {
  final List<ProposalModel> proposals;
  final GovernanceStatsModel governanceStats;
  final GovernanceParametersModel governanceParams;
  final TreasuryInfoModel treasuryInfo;

  const GovernanceLoaded({
    required this.proposals,
    required this.governanceStats,
    required this.governanceParams,
    required this.treasuryInfo,
  });

  @override
  List<Object> get props => [
        proposals,
        governanceStats,
        governanceParams,
        treasuryInfo,
      ];
}

class GovernanceError extends GovernanceState {
  final String message;

  const GovernanceError(this.message);

  @override
  List<Object> get props => [message];
}

class ProposalDetailLoaded extends GovernanceState {
  final ProposalModel proposal;

  const ProposalDetailLoaded({required this.proposal});

  @override
  List<Object> get props => [proposal];
}

class ProposalCreated extends GovernanceState {
  final ProposalModel proposal;

  const ProposalCreated({required this.proposal});

  @override
  List<Object> get props => [proposal];
}

class VoteCastSuccess extends GovernanceState {}

class ProposalExecuted extends GovernanceState {}

// BLoC
class GovernanceBloc extends Bloc<GovernanceEvent, GovernanceState> {
  final GovernanceRepository governanceRepository;

  GovernanceBloc({required this.governanceRepository}) : super(GovernanceInitial()) {
    on<LoadGovernanceData>(_onLoadGovernanceData);
    on<SubmitProposal>(_onSubmitProposal);
    on<CastVote>(_onCastVote);
  }

  Future<void> _onLoadGovernanceData(
    LoadGovernanceData event,
    Emitter<GovernanceState> emit,
  ) async {
    emit(GovernanceLoading());
    try {
      // Load actual data from repository
      final proposals = await governanceRepository.getProposals();
      final governanceStats = await governanceRepository.getGovernanceStats();
      final governanceParams = await governanceRepository.getGovernanceParameters();
      final treasuryInfo = await governanceRepository.getTreasuryInfo();
      
      emit(GovernanceLoaded(
        proposals: proposals,
        governanceStats: governanceStats,
        governanceParams: governanceParams,
        treasuryInfo: treasuryInfo,
      ));
    } catch (e) {
      emit(GovernanceError(e.toString()));
    }
  }

  Future<void> _onSubmitProposal(
    SubmitProposal event,
    Emitter<GovernanceState> emit,
  ) async {
    try {
      // Submit the proposal through the repository
      await governanceRepository.submitProposal(
        proposer: event.proposer,
        description: event.description,
        actions: event.actions,
        duration: event.duration,
      );
      
      // Reload the data to show the new proposal
      add(LoadGovernanceData());
    } catch (e) {
      emit(GovernanceError(e.toString()));
    }
  }

  Future<void> _onCastVote(
    CastVote event,
    Emitter<GovernanceState> emit,
  ) async {
    try {
      // Cast the vote through the repository
      await governanceRepository.castVote(
        proposalID: event.proposalID,
        voter: event.voter,
        choice: event.choice,
        weight: event.weight,
      );
      
      // Reload the data to show the updated vote count
      add(LoadGovernanceData());
    } catch (e) {
      emit(GovernanceError(e.toString()));
    }
  }
}
