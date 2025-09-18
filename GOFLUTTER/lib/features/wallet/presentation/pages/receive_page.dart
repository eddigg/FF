import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/wallet_bloc.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/common_widgets.dart';
import 'package:go_router/go_router.dart';

class ReceivePage extends StatelessWidget {
  const ReceivePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receive Tokens'),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: BlocBuilder<WalletBloc, WalletState>(
          builder: (context, state) {
            if (state is WalletLoaded) {
              return Padding(
                padding: const EdgeInsets.all(AppSpacing.containerPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GlassCard(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          children: [
                            const Text(
                              'Receive Tokens',
                              style: AppTextStyles.h3,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            // QR Code placeholder
                            Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: const Center(
                                child: Text(
                                  'QR Code\n(Placeholder)',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.body2,
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            // Address display
                            Container(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    'Your Wallet Address',
                                    style: AppTextStyles.body1,
                                  ),
                                  const SizedBox(height: AppSpacing.sm),
                                  SelectableText(
                                    state.address,
                                    style: AppTextStyles.address,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            GradientButton(
                              text: 'Copy Address',
                              onPressed: () {
                                _copyToClipboard(context, state.address);
                              },
                              width: double.infinity,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    // Security info
                    const GlassCard(
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Security Information',
                              style: AppTextStyles.h4,
                            ),
                            SizedBox(height: AppSpacing.sm),
                            Text(
                              '• Share this address to receive tokens',
                              style: AppTextStyles.body2,
                            ),
                            Text(
                              '• This address can be shared publicly',
                              style: AppTextStyles.body2,
                            ),
                            Text(
                              '• Each transaction will appear in your transaction history',
                              style: AppTextStyles.body2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is WalletLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Center(child: Text('Error loading wallet'));
            }
          },
        ),
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Address copied to clipboard!'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
