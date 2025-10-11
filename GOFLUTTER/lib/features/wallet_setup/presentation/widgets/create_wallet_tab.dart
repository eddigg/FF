import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/wallet_setup_bloc.dart';

class CreateWalletTab extends StatelessWidget {
  const CreateWalletTab({super.key});

  @override
  Widget build(BuildContext context) {
    final passwordController = TextEditingController();

    return Column(
      children: [
        const _WalletInfo(
          title: '🔑 New Wallet',
          description: 'Create a new wallet to get started with ATLAS B.C.',
        ),
        const SizedBox(height: 20),
        _FormGroup(
          label: 'Password',
          child: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: _inputDecoration('Enter a strong password'),
          ),
        ),
        const SizedBox(height: 20),
        _PrimaryButton(
          text: '🔑 Create New Wallet',
          onPressed: () {
            context.read<WalletSetupBloc>().add(
              CreateWallet(password: passwordController.text),
            );
          },
        ),
        const SizedBox(height: 20),
        BlocConsumer<WalletSetupBloc, WalletSetupState>(
          listener: (context, state) {
            print('🔍 WalletSetup state changed: ${state.runtimeType}');
            if (state is WalletSetupSuccess) {
              print('✅ Wallet created successfully: ${state.message}');
              // Navigate to dashboard after successful wallet creation
              Future.delayed(const Duration(seconds: 2), () {
                if (context.mounted) {
                  context.go('/dashboard');
                }
              });
            } else if (state is WalletSetupError) {
              print('❌ Wallet creation failed: ${state.message}');
            }
          },
          builder: (context, state) {
            if (state is WalletSetupLoading) {
              return const _LoadingIndicator(
                message: 'Creating your wallet...',
              );
            }
            if (state is WalletSetupSuccess) {
              return Column(
                children: [
                  _StatusMessage(message: state.message, isError: false),
                  const SizedBox(height: 20),
                  const _LoadingIndicator(
                    message: 'Redirecting to dashboard...',
                  ),
                ],
              );
            }
            if (state is WalletSetupError) {
              return _StatusMessage(message: state.message, isError: true);
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}

// Duplicating helper widgets here for simplicity.
// In a real app, these would be in shared files.

InputDecoration _inputDecoration(String placeholder) {
  return InputDecoration(
    hintText: placeholder,
    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 2),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFF4299E1), width: 2),
    ),
  );
}

class _WalletInfo extends StatelessWidget {
  final String title;
  final String description;
  const _WalletInfo({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(8),
        border: const Border(
          left: BorderSide(color: Color(0xFF4299E1), width: 4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF4A5568),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
              color: Color(0xFF718096),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const _PrimaryButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style:
          ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            backgroundColor: const Color(0xFF4299E1), // Fallback
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0, // Handled by container
          ).copyWith(
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
          ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4299E1), Color(0xFF3182CE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
      ),
    );
  }
}

class _FormGroup extends StatelessWidget {
  final String label;
  final Widget child;
  const _FormGroup({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF4A5568),
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _StatusMessage extends StatelessWidget {
  final String message;
  final bool isError;
  const _StatusMessage({required this.message, required this.isError});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isError ? const Color(0xFFFED7D7) : const Color(0xFFC6F6D5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isError ? const Color(0xFFFEB2B2) : const Color(0xFF9AE6B4),
        ),
      ),
      child: Text(
        message,
        style: TextStyle(
          color: isError ? const Color(0xFF742A2A) : const Color(0xFF22543D),
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  final String message;
  const _LoadingIndicator({required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4299E1)),
          ),
        ),
        const SizedBox(height: 10),
        Text(message, style: const TextStyle(color: Color(0xFF718096))),
      ],
    );
  }
}