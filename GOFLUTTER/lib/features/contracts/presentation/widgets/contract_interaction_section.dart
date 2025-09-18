import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/contracts_bloc.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/common_widgets.dart';
import '../../../../shared/widgets/custom_widgets.dart';

class ContractInteractionSection extends StatefulWidget {
  const ContractInteractionSection({Key? key}) : super(key: key);

  @override
  State<ContractInteractionSection> createState() => _ContractInteractionSectionState();
}

class _ContractInteractionSectionState extends State<ContractInteractionSection> {
  final _contractAddressController = TextEditingController();
  final _callerAddressController = TextEditingController();
  final _gasLimitController = TextEditingController(text: '1000');
  final Map<String, List<TextEditingController>> _functionParamControllers = {};

  @override
  void dispose() {
    _contractAddressController.dispose();
    _callerAddressController.dispose();
    _gasLimitController.dispose();
    // Dispose all function parameter controllers
    _functionParamControllers.values.expand((list) => list).forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _loadContractInfo() {
    if (_contractAddressController.text.isNotEmpty) {
      context.read<ContractsBloc>().add(LoadContractInfo(address: _contractAddressController.text));
    }
  }

  void _callFunction(String functionName, List<String> paramNames) {
    final args = <dynamic>[];
    if (_functionParamControllers.containsKey(functionName)) {
      for (int i = 0; i < _functionParamControllers[functionName]!.length; i++) {
        final value = _functionParamControllers[functionName]![i].text;
        // Try to parse as number, otherwise keep as string
        final numValue = num.tryParse(value);
        args.add(numValue ?? value);
      }
    }

    context.read<ContractsBloc>().add(CallContractFunction(
      address: _contractAddressController.text,
      functionName: functionName,
      args: args,
      caller: _callerAddressController.text,
      gasLimit: int.tryParse(_gasLimitController.text) ?? 1000,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return EnhancedGlassCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Contract Interaction', style: AppTextStyles.h4),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _contractAddressController,
              style: AppTextStyles.body1,
              decoration: InputDecoration(
                labelText: 'Contract Address',
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
            GradientButton(
              text: 'Load Contract Info',
              onPressed: _loadContractInfo,
              gradient: AppColors.secondaryGradient,
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _callerAddressController,
              style: AppTextStyles.body1,
              decoration: InputDecoration(
                labelText: 'Caller Address',
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
              controller: _gasLimitController,
              keyboardType: TextInputType.number,
              style: AppTextStyles.body1,
              decoration: InputDecoration(
                labelText: 'Gas Limit',
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
            BlocBuilder<ContractsBloc, ContractsState>(
              builder: (context, state) {
                if (state is ContractsLoaded && state.selectedContract != null) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Available Functions:', style: AppTextStyles.h5),
                      const SizedBox(height: AppSpacing.sm),
                      ...state.selectedContract!.functions.map<Widget>((func) {
                        // Create controllers for function parameters if they don't exist
                        if (!_functionParamControllers.containsKey(func['name'])) {
                          _functionParamControllers[func['name']] = [];
                        }
                        
                        final paramNames = List<String>.from(func['params'] ?? []);
                        // Ensure we have the right number of controllers
                        while (_functionParamControllers[func['name']]!.length < paramNames.length) {
                          _functionParamControllers[func['name']]!.add(TextEditingController());
                        }
                        while (_functionParamControllers[func['name']]!.length > paramNames.length) {
                          _functionParamControllers[func['name']]!.removeLast().dispose();
                        }
                        
                        return _buildFunctionCard(func['name'], paramNames, func['name']);
                      }).toList(),
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFunctionCard(String functionName, List<String> paramNames, String functionKey) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: EnhancedGlassCard(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(functionName, style: AppTextStyles.h5),
              if (paramNames.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                Text('Parameters: ${paramNames.join(', ')}', style: AppTextStyles.body2),
                const SizedBox(height: AppSpacing.sm),
                ...List.generate(paramNames.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: TextField(
                      controller: _functionParamControllers[functionKey]![index],
                      style: AppTextStyles.body1,
                      decoration: InputDecoration(
                        labelText: paramNames[index],
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
                  );
                }),
              ],
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  GradientButton(
                    text: 'Call Function',
                    onPressed: () => _callFunction(functionName, paramNames),
                    gradient: AppColors.successGradient,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.info.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Text(
                      'Gas Limit: ${_gasLimitController.text}',
                      style: AppTextStyles.caption.copyWith(color: AppColors.info),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}