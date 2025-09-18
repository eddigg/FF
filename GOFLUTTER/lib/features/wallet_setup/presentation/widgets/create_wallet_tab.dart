import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/wallet_setup_bloc.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/common_widgets.dart';

class CreateWalletTab extends StatelessWidget {
  const CreateWalletTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final passwordController = TextEditingController();

    return Column(
      children: [
        const Text(
          'Create a new wallet to get started with ATLAS B.C.',
          style: AppTextStyles.body1,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: passwordController,
          obscureText: true,
          style: AppTextStyles.body1,
          decoration: InputDecoration(
            labelText: 'Password',
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
        GradientButton(
          text: 'Create New Wallet',
          onPressed: () {
            context.read<WalletSetupBloc>().add(CreateWallet(password: passwordController.text));
          },
        ),
        BlocBuilder<WalletSetupBloc, WalletSetupState>(
          builder: (context, state) {
            if (state is WalletSetupLoading) {
              return const CircularProgressIndicator();
            } else if (state is WalletSetupSuccess) {
              // Navigate to wallet page after successful creation
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.go('/wallet');
              });
              return Text(state.message, style: const TextStyle(color: AppColors.success));
            } else if (state is WalletSetupError) {
              return Text(state.message, style: const TextStyle(color: AppColors.error));
            }
            return Container();
          },
        ),
      ],
    );
  }
}