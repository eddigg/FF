import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/wallet_setup_bloc.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/common_widgets.dart';

class ImportWalletTab extends StatefulWidget {
  const ImportWalletTab({Key? key}) : super(key: key);

  @override
  State<ImportWalletTab> createState() => _ImportWalletTabState();
}

class _ImportWalletTabState extends State<ImportWalletTab> {
  int _selectedImportMethod = 0; // 0 for file, 1 for private key
  final _privateKeyController = TextEditingController();
  final _importPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Import an existing wallet using a JSON file or enter your private key.',
          style: AppTextStyles.body1,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: GradientButton(
                text: 'File',
                onPressed: () {
                  setState(() {
                    _selectedImportMethod = 0;
                  });
                },
                gradient: _selectedImportMethod == 0
                    ? AppColors.primaryGradient
                    : AppColors.secondaryGradient,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: GradientButton(
                text: 'Private Key',
                onPressed: () {
                  setState(() {
                    _selectedImportMethod = 1;
                  });
                },
                gradient: _selectedImportMethod == 1
                    ? AppColors.primaryGradient
                    : AppColors.secondaryGradient,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        if (_selectedImportMethod == 0)
          Column(
            children: [
              // TODO: Implement file picker
              Container(
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border, width: 2),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: const Center(
                  child: Text('Choose wallet file or drag and drop here',
                      style: AppTextStyles.body2),
                ),
              ),
            ],
          )
        else
          TextField(
            controller: _privateKeyController,
            maxLines: 4,
            style: AppTextStyles.body1,
            decoration: InputDecoration(
              labelText: 'Private Key',
              labelStyle:
                  AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
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
                borderSide:
                    const BorderSide(color: AppColors.primary, width: 2),
              ),
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            ),
          ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: _importPasswordController,
          obscureText: true,
          style: AppTextStyles.body1,
          decoration: InputDecoration(
            labelText: 'Password (if encrypted)',
            labelStyle:
                AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
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
            contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        GradientButton(
          text: 'Import Wallet',
          onPressed: () {
            context.read<WalletSetupBloc>().add(ImportWallet(
                  privateKey: _privateKeyController.text,
                  password: _importPasswordController.text,
                  // TODO: Pass file content if file import is selected
                ));
          },
        ),
        BlocBuilder<WalletSetupBloc, WalletSetupState>(
          builder: (context, state) {
            if (state is WalletSetupLoading) {
              return const CircularProgressIndicator();
            } else if (state is WalletSetupSuccess) {
              return Text(state.message,
                  style: const TextStyle(color: AppColors.success));
            } else if (state is WalletSetupError) {
              return Text(state.message,
                  style: const TextStyle(color: AppColors.error));
            }
            return Container();
          },
        ),
      ],
    );
  }
}
