import 'package:flutter/material.dart';
import '../../../../shared/themes/app_colors.dart';
import 'package:go_router/go_router.dart';

class SendPage extends StatelessWidget {
  const SendPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Tokens'),
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
        child: const Padding(
          padding: EdgeInsets.all(AppSpacing.containerPadding),
          child: Column(
            children: [
              // This page is intentionally left empty as the functionality
              // is already implemented in the main wallet page
              // In a real app, this would contain the send transaction form
              Center(
                child: Text(
                  'Send functionality is available in the main Wallet page',
                  style: AppTextStyles.body1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
