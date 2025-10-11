import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/contract_model.dart';
import '../../data/models/contract_example_model.dart';
import '../../data/repositories/contracts_repository.dart';

// Events
abstract class ContractsEvent extends Equatable {
  const ContractsEvent();

  @override
  List<Object> get props => [];
}

class LoadContractsData extends ContractsEvent {}

class DeployContract extends ContractsEvent {
  final String name;
  final String version;
  final String owner;
  final String code;

  const DeployContract({
    required this.name,
    required this.version,
    required this.owner,
    required this.code,
  });

  @override
  List<Object> get props => [name, version, owner, code];
}

class LoadContractInfo extends ContractsEvent {
  final String address;

  const LoadContractInfo({required this.address});

  @override
  List<Object> get props => [address];
}

class CallContractFunction extends ContractsEvent {
  final String address;
  final String functionName;
  final List<dynamic> args;
  final String caller;
  final int gasLimit;

  const CallContractFunction({
    required this.address,
    required this.functionName,
    required this.args,
    required this.caller,
    required this.gasLimit,
  });

  @override
  List<Object> get props => [address, functionName, args, caller, gasLimit];
}

class LoadExampleContract extends ContractsEvent {
  final String example;

  const LoadExampleContract(this.example);

  @override
  List<Object> get props => [example];
}

// States
abstract class ContractsState extends Equatable {
  const ContractsState();

  @override
  List<Object> get props => [];
}

class ContractsInitial extends ContractsState {}

class ContractsLoading extends ContractsState {}

class ContractsLoaded extends ContractsState {
  final List<ContractModel> deployedContracts;
  final List<ContractExampleModel> contractExamples;
  final ContractModel? selectedContract;
  final String? deploymentStatus;
  final ContractExampleModel? exampleToLoad;

  const ContractsLoaded({
    required this.deployedContracts,
    required this.contractExamples,
    this.selectedContract,
    this.deploymentStatus,
    this.exampleToLoad,
  });

  @override
  List<Object> get props => [deployedContracts, contractExamples, selectedContract ?? '', deploymentStatus ?? '', exampleToLoad ?? ''];
}

class ContractsError extends ContractsState {
  final String message;

  const ContractsError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class ContractsBloc extends Bloc<ContractsEvent, ContractsState> {
  final ContractsRepository contractsRepository;

  ContractsBloc({required this.contractsRepository}) : super(ContractsInitial()) {
    on<LoadContractsData>(_onLoadContractsData);
    on<DeployContract>(_onDeployContract);
    on<LoadContractInfo>(_onLoadContractInfo);
    on<CallContractFunction>(_onCallContractFunction);
    on<LoadExampleContract>(_onLoadExampleContract);
  }

  Future<void> _onLoadContractsData(
    LoadContractsData event,
    Emitter<ContractsState> emit,
  ) async {
    emit(ContractsLoading());
    try {
      final deployedContracts = await contractsRepository.getDeployedContracts();
      final contractExamples = await contractsRepository.getContractExamples();
      emit(ContractsLoaded(
        deployedContracts: deployedContracts,
        contractExamples: contractExamples,
        deploymentStatus: null,
      ));
    } catch (e) {
      emit(ContractsError(e.toString()));
    }
  }

  Future<void> _onDeployContract(
    DeployContract event,
    Emitter<ContractsState> emit,
  ) async {
    try {
      await contractsRepository.deployContract(
        event.name,
        event.version,
        event.owner,
        event.code,
      );
      // Reload contracts after deployment
      add(LoadContractsData());
      // Emit success status
      if (state is ContractsLoaded) {
        final currentState = state as ContractsLoaded;
        emit(ContractsLoaded(
          deployedContracts: currentState.deployedContracts,
          contractExamples: currentState.contractExamples,
          deploymentStatus: 'Contract deployed successfully!',
        ));
      }
    } catch (e) {
      emit(ContractsError(e.toString()));
    }
  }

  Future<void> _onLoadContractInfo(
    LoadContractInfo event,
    Emitter<ContractsState> emit,
  ) async {
    try {
      final contract = await contractsRepository.getContractInfo(event.address);
      if (state is ContractsLoaded) {
        final currentState = state as ContractsLoaded;
        emit(ContractsLoaded(
          deployedContracts: currentState.deployedContracts,
          contractExamples: currentState.contractExamples,
          selectedContract: contract,
        ));
      }
    } catch (e) {
      emit(ContractsError(e.toString()));
    }
  }

  Future<void> _onCallContractFunction(
    CallContractFunction event,
    Emitter<ContractsState> emit,
  ) async {
    try {
      await contractsRepository.callContractFunction(
        event.address,
        event.functionName,
        event.args,
        event.caller,
        event.gasLimit,
      );
      // Emit success or update state as needed
      if (state is ContractsLoaded) {
        emit(state);
      }
    } catch (e) {
      emit(ContractsError(e.toString()));
    }
  }

  Future<void> _onLoadExampleContract(
    LoadExampleContract event,
    Emitter<ContractsState> emit,
  ) async {
    if (state is ContractsLoaded) {
      final currentState = state as ContractsLoaded;
      final example = currentState.contractExamples.firstWhere(
        (ex) => ex.name.toLowerCase().contains(event.example.toLowerCase()),
        orElse: () => ContractExampleModel(
          name: event.example,
          description: 'Example contract',
          code: 'pragma solidity ^0.8.0; contract ${event.example} {}',
        ),
      );

      emit(ContractsLoaded(
        deployedContracts: currentState.deployedContracts,
        contractExamples: currentState.contractExamples,
        selectedContract: currentState.selectedContract,
        deploymentStatus: currentState.deploymentStatus,
        exampleToLoad: example,
      ));
    }
  }
}
