import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/contracts_bloc.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/common_widgets.dart';
import '../../../../shared/widgets/custom_widgets.dart';

class ContractDeploymentSection extends StatefulWidget {
  const ContractDeploymentSection({Key? key}) : super(key: key);

  @override
  State<ContractDeploymentSection> createState() => _ContractDeploymentSectionState();
}

class _ContractDeploymentSectionState extends State<ContractDeploymentSection> {
  final _contractNameController = TextEditingController();
  final _contractVersionController = TextEditingController(text: '1.0');
  final _contractOwnerController = TextEditingController();
  final _contractCodeController = TextEditingController();
  String? _deploymentStatus;

  static String _getSimpleTokenCode() {
    return '''{
  "functions": {
    "transfer": {
      "params": ["to", "amount"],
      "code": [
        {"op": "LOAD", "key": "balance"},
        {"op": "PUSH", "value": "amount"},
        {"op": "SUB"},
        {"op": "STORE", "key": "balance"}
      ]
    },
    "balance": {
      "params": [],
      "code": [
        {"op": "LOAD", "key": "balance"},
        {"op": "RETURN"}
      ]
    },
    "mint": {
      "params": ["amount"],
      "code": [
        {"op": "LOAD", "key": "balance"},
        {"op": "PUSH", "value": "amount"},
        {"op": "ADD"},
        {"op": "STORE", "key": "balance"}
      ]
    }
  },
  "storage": {
    "balance": 1000,
    "owner": "0x1234567890abcdef"
  }
}''';
  }

  static String _getVotingContractCode() {
    return '''{
  "functions": {
    "vote": {
      "params": ["proposal", "choice"],
      "code": [
        {"op": "PUSH", "value": "choice"},
        {"op": "STORE", "key": "vote"},
        {"op": "LOAD", "key": "votes"},
        {"op": "PUSH", "value": 1},
        {"op": "ADD"},
        {"op": "STORE", "key": "votes"}
      ]
    },
    "getVotes": {
      "params": [],
      "code": [
        {"op": "LOAD", "key": "votes"},
        {"op": "RETURN"}
      ]
    },
    "getVote": {
      "params": [],
      "code": [
        {"op": "LOAD", "key": "vote"},
        {"op": "RETURN"}
      ]
    }
  },
  "storage": {
    "votes": 0,
    "vote": 0
  }
}''';
  }

  static String _getEscrowContractCode() {
    return '''{
  "functions": {
    "deposit": {
      "params": ["amount"],
      "code": [
        {"op": "LOAD", "key": "balance"},
        {"op": "PUSH", "value": "amount"},
        {"op": "ADD"},
        {"op": "STORE", "key": "balance"}
      ]
    },
    "withdraw": {
      "params": ["amount"],
      "code": [
        {"op": "LOAD", "key": "balance"},
        {"op": "PUSH", "value": "amount"},
        {"op": "SUB"},
        {"op": "STORE", "key": "balance"}
      ]
    },
    "getBalance": {
      "params": [],
      "code": [
        {"op": "LOAD", "key": "balance"},
        {"op": "RETURN"}
      ]
    }
  },
  "storage": {
    "balance": 0
  }
}''';
  }

  @override
  void dispose() {
    _contractNameController.dispose();
    _contractVersionController.dispose();
    _contractOwnerController.dispose();
    _contractCodeController.dispose();
    super.dispose();
  }

  void _deployContract() {
    if (_contractNameController.text.isEmpty ||
        _contractOwnerController.text.isEmpty ||
        _contractCodeController.text.isEmpty) {
      // Show error
      return;
    }

    context.read<ContractsBloc>().add(DeployContract(
      name: _contractNameController.text,
      version: _contractVersionController.text,
      owner: _contractOwnerController.text,
      code: _contractCodeController.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContractsBloc, ContractsState>(
      listener: (context, state) {
        // Listen for LoadExampleContract events
        if (state is ContractsLoaded) {
          // Check if there's a deployment status to show
          if (state.deploymentStatus != null) {
            setState(() {
              _deploymentStatus = state.deploymentStatus;
            });
          }
        }
      },
      builder: (context, state) {
        // Handle LoadExampleContract event
        if (state is ContractsLoaded) {
          // This is a workaround - in a real app, we'd use a proper state management solution
          // to communicate between widgets
        }
        
        return EnhancedGlassCard(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Deploy New Contract', style: AppTextStyles.h4),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _contractNameController,
                  style: AppTextStyles.body1,
                  decoration: InputDecoration(
                    labelText: 'Contract Name',
                    labelStyle: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      borderSide: const BorderSide(color: AppColors.border, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      borderSide: const BorderSide(color: AppColors.border, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      borderSide: const BorderSide(color: AppColors.primary, width: 2),
                    ),
                    filled: true,
                    fillColor: AppColors.surface,
                    contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextField(
                  controller: _contractVersionController,
                  style: AppTextStyles.body1,
                  decoration: InputDecoration(
                    labelText: 'Version',
                    labelStyle: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      borderSide: const BorderSide(color: AppColors.border, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      borderSide: const BorderSide(color: AppColors.border, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      borderSide: const BorderSide(color: AppColors.primary, width: 2),
                    ),
                    filled: true,
                    fillColor: AppColors.surface,
                    contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextField(
                  controller: _contractOwnerController,
                  style: AppTextStyles.body1,
                  decoration: InputDecoration(
                    labelText: 'Owner Address',
                    labelStyle: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      borderSide: const BorderSide(color: AppColors.border, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      borderSide: const BorderSide(color: AppColors.border, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      borderSide: const BorderSide(color: AppColors.primary, width: 2),
                    ),
                    filled: true,
                    fillColor: AppColors.surface,
                    contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextField(
                  controller: _contractCodeController,
                  maxLines: 10,
                  style: AppTextStyles.body1.copyWith(fontFamily: 'monospace'),
                  decoration: InputDecoration(
                    labelText: 'Contract Code (JSON)',
                    labelStyle: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      borderSide: const BorderSide(color: AppColors.border, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      borderSide: const BorderSide(color: AppColors.border, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      borderSide: const BorderSide(color: AppColors.primary, width: 2),
                    ),
                    filled: true,
                    fillColor: AppColors.surface,
                    contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    GradientButton(
                      text: 'Deploy Contract',
                      onPressed: _deployContract,
                      gradient: AppColors.successGradient,
                      width: 150,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    GradientButton(
                      text: 'Load Example',
                      onPressed: () {
                        // Show a dialog or bottom sheet with examples
                        _showExampleDialog(context);
                      },
                      gradient: AppColors.secondaryGradient,
                      width: 150,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                if (_deploymentStatus != null)
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      border: Border.all(color: AppColors.success),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: AppColors.success),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            _deploymentStatus!,
                            style: AppTextStyles.body1.copyWith(color: AppColors.success),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showExampleDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Load Example Contract', style: AppTextStyles.h4),
              const SizedBox(height: AppSpacing.md),
              ListTile(
                title: const Text('🪙 Simple Token', style: AppTextStyles.h5),
                subtitle: const Text('A basic token contract with transfer and balance functions'),
                onTap: () {
                  Navigator.pop(context);
                  _loadExampleContract(_getSimpleTokenCode(), 'SimpleToken');
                },
              ),
              ListTile(
                title: const Text('🗳️ Voting System', style: AppTextStyles.h5),
                subtitle: const Text('A simple voting contract for proposals'),
                onTap: () {
                  Navigator.pop(context);
                  _loadExampleContract(_getVotingContractCode(), 'SimpleVoting');
                },
              ),
              ListTile(
                title: const Text('🔒 Escrow Service', style: AppTextStyles.h5),
                subtitle: const Text('An escrow contract for secure transactions'),
                onTap: () {
                  Navigator.pop(context);
                  _loadExampleContract(_getEscrowContractCode(), 'SimpleEscrow');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _loadExampleContract(String code, String name) {
    setState(() {
      _contractNameController.text = name;
      _contractCodeController.text = code;
    });
  }
}