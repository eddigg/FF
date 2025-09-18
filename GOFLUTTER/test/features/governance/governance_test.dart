import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:atlas_blockchain_flutter/features/governance/presentation/bloc/governance_bloc.dart';
import 'package:atlas_blockchain_flutter/features/governance/data/repositories/governance_repository.dart';
import 'package:atlas_blockchain_flutter/features/governance/data/models/proposal_model.dart';
import 'package:atlas_blockchain_flutter/features/governance/data/models/governance_stats_model.dart';
import 'package:atlas_blockchain_flutter/features/governance/data/models/governance_parameters_model.dart';
import 'package:atlas_blockchain_flutter/features/governance/data/models/treasury_info_model.dart';

// Manual mock
class MockGovernanceRepository extends Mock implements GovernanceRepository {}

void main() {
  group('Governance Feature Tests', () {
    late MockGovernanceRepository mockRepository;
    late GovernanceBloc governanceBloc;

    setUp(() {
      mockRepository = MockGovernanceRepository();
      governanceBloc = GovernanceBloc(governanceRepository: mockRepository);
    });

    tearDown(() {
      governanceBloc.close();
    });

    test('GovernanceBloc initializes correctly', () {
      expect(governanceBloc.state, isA<GovernanceInitial>());
    });

    test('GovernanceBloc emits GovernanceLoading and GovernanceLoaded when loading data succeeds', () {
      final proposals = [
        const ProposalModel(
          id: '1',
          description: 'Test Proposal',
          state: 'Active',
          votesFor: 100,
          votesAgainst: 50,
          startBlock: 1000,
          endBlock: 2000,
        )
      ];
      
      const stats = GovernanceStatsModel(
        activeProposals: 5,
        totalVoters: 1000,
        totalVotingPower: 50000,
        quorumRequired: 10000,
      );
      
      const params = GovernanceParametersModel(
        minDuration: 100,
        maxDuration: 1000,
        minStake: 1000,
        votingThreshold: 0.5,
      );
      
      const treasury = TreasuryInfoModel(
        balance: 100000.0,
        pendingProposals: 3,
        executedThisMonth: 2,
      );

      when(mockRepository.getProposals()).thenAnswer((_) async => proposals);
      when(mockRepository.getGovernanceStats()).thenAnswer((_) async => stats);
      when(mockRepository.getGovernanceParameters()).thenAnswer((_) async => params);
      when(mockRepository.getTreasuryInfo()).thenAnswer((_) async => treasury);

      expectLater(
        governanceBloc.stream,
        emitsInOrder([
          isA<GovernanceInitial>(),
          isA<GovernanceLoading>(),
          isA<GovernanceLoaded>(),
        ]),
      );

      governanceBloc.add(LoadGovernanceData());
    });
  });
}