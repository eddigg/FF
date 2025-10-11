import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/wallet_bloc.dart';
import '../../../../shared/themes/app_text_styles.dart';
import '../../../../shared/themes/app_colors.dart';
import 'package:go_router/go_router.dart';

// Temporary workaround for widget import issues
class GlassCard extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsets? margin;
  final EdgeInsets? padding;

  const GlassCard({Key? key, this.child, this.width, this.height, this.margin, this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      child: child,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
    );
  }
}

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final LinearGradient? gradient;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final IconData? icon;

  const GradientButton({Key? key, required this.text, this.onPressed, this.gradient,
                       this.padding, this.width, this.height, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: onPressed != null ? (gradient ?? LinearGradient(
          colors: [Colors.blue, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )) : null,
        color: onPressed == null ? Colors.grey : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) Icon(icon, color: Colors.white),
          if (icon != null) const SizedBox(width: 8),
          Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class ReceivePage extends StatelessWidget {
  const ReceivePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receive Tokens'),
        backgroundColor: const Color(0xFF111827), // Using direct color instead of AppColors.background
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
        child: BlocBuilder<WalletBloc, WalletState>(
          builder: (context, state) {
            if (state is WalletLoaded) {
              return Padding(
                padding: const EdgeInsets.all(20.0), // AppSpacing.containerPadding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GlassCard(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0), // AppSpacing.lg
                        child: Column(
                          children: [
                          Text(
                            'Receive Tokens',
                            style: AppTextStyles.h3,
                          ),
                            const SizedBox(height: 24.0), // AppSpacing.lg
                            // QR Code placeholder
                            Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.0), // AppSpacing.radiusMd
                                border: Border.all(color: Colors.grey),
                              ),
                              child: const Center(
                                child: Text(
                                  'QR Code\n(Placeholder)',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.body2,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24.0), // AppSpacing.lg
                            // Address display
                            Container(
                              padding: const EdgeInsets.all(16.0), // AppSpacing.md
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.0), // AppSpacing.radiusMd
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    'Your Wallet Address',
                                    style: AppTextStyles.body1,
                                  ),
                                  const SizedBox(height: 8.0), // AppSpacing.sm
                                  SelectableText(
                                    state.address,
                                    style: AppTextStyles.address,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16.0), // AppSpacing.md
                            GradientButton(
                              text: 'Copy Address',
                              onPressed: () {
                                _copyToClipboard(context, state.address);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24.0), // AppSpacing.lg
                    // Security info
                    GlassCard(
                      child: Padding(
                        padding: EdgeInsets.all(16.0), // AppSpacing.md
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Security Information',
                              style: AppTextStyles.h4,
                            ),
                            SizedBox(height: 8.0), // AppSpacing.sm
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
