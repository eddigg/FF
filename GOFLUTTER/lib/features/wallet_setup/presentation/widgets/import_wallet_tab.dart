import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import '../bloc/wallet_setup_bloc.dart';

class ImportWalletTab extends StatefulWidget {
  const ImportWalletTab({super.key});

  @override
  State<ImportWalletTab> createState() => _ImportWalletTabState();
}

class _ImportWalletTabState extends State<ImportWalletTab> {
  int _selectedImportMethod = 0; // 0 for file, 1 for key
  final _privateKeyController = TextEditingController();
  final _importPasswordController = TextEditingController();
  String? _fileName;
  String? _filePath;

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null) {
        setState(() {
          _fileName = result.files.single.name;
          _filePath = result.files.single.path;
        });
      } else {
        // User canceled the picker
      }
    } catch (e) {
      // Handle exceptions
      print("File picking failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _WalletInfo(
          title: '📁 Import Wallet',
          description: 'Import an existing wallet using a JSON file or enter your private key. Make sure you have your wallet file ready.',
        ),
        const SizedBox(height: 20),
        _buildImportMethodSwitcher(),
        const SizedBox(height: 20),
        if (_selectedImportMethod == 0)
          _buildFileImportSection()
        else
          _buildKeyImportSection(),
        const SizedBox(height: 20),
        _FormGroup(
          label: 'Password (if encrypted)',
          child: TextField(
            controller: _importPasswordController,
            obscureText: true,
            decoration: _inputDecoration('Enter wallet password'),
          ),
        ),
        const SizedBox(height: 20),
        _PrimaryButton(
          text: '📥 Import Wallet',
          onPressed: () {
            // TODO: Implement BLoC event for file import
            context.read<WalletSetupBloc>().add(ImportWallet(
                  privateKey: _privateKeyController.text,
                  password: _importPasswordController.text,
                ));
          },
        ),
        const SizedBox(height: 20),
        BlocBuilder<WalletSetupBloc, WalletSetupState>(
          builder: (context, state) {
            if (state is WalletSetupLoading) {
              return const _LoadingIndicator(message: 'Importing wallet...');
            }
            if (state is WalletSetupSuccess) {
              // Navigate to dashboard after successful wallet import
              Future.delayed(const Duration(seconds: 2), () {
                if (context.mounted) {
                  context.go('/dashboard');
                }
              });
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

  Widget _buildImportMethodSwitcher() {
    return Row(
      children: [
        Expanded(
          child: _SecondaryButton(
            text: '📁 File',
            onPressed: () => setState(() => _selectedImportMethod = 0),
            isActive: _selectedImportMethod == 0,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _SecondaryButton(
            text: '🔑 Private Key',
            onPressed: () => setState(() => _selectedImportMethod = 1),
            isActive: _selectedImportMethod == 1,
          ),
        ),
      ],
    );
  }

  Widget _buildFileImportSection() {
    return _FormGroup(
      label: 'Upload Wallet File',
      child: GestureDetector(
        onTap: _pickFile,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
          ),
          child: Text(
            _fileName ?? '📁 Choose wallet file',
            textAlign: TextAlign.center,
            style: TextStyle(color: _fileName != null ? const Color(0xFF4299E1) : const Color(0xFF718096)),
          ),
        ),
      ),
    );
  }

  Widget _buildKeyImportSection() {
    return _FormGroup(
      label: 'Private Key',
      child: TextField(
        controller: _privateKeyController,
        maxLines: 4,
        decoration: _inputDecoration('Enter your private key'),
      ),
    );
  }
}

// Common widgets (could be moved to a shared file)

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
        border: const Border(left: BorderSide(color: Color(0xFF4299E1), width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Color(0xFF4A5568), fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          Text(description, style: const TextStyle(color: Color(0xFF718096), fontSize: 14, height: 1.5)),
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
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
          child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white)),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isActive;
  const _SecondaryButton({required this.text, required this.onPressed, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        backgroundColor: isActive ? const Color(0xFF3182CE) : const Color(0xFF6C757D),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
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
        Text(label, style: const TextStyle(color: Color(0xFF4A5568), fontWeight: FontWeight.w600, fontSize: 16)),
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
        border: Border.all(color: isError ? const Color(0xFFFEB2B2) : const Color(0xFF9AE6B4)),
      ),
      child: Text(
        message,
        style: TextStyle(color: isError ? const Color(0xFF742A2A) : const Color(0xFF22543D), fontWeight: FontWeight.w600),
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
          child: CircularProgressIndicator(strokeWidth: 3, valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4299E1))),
        ),
        const SizedBox(height: 10),
        Text(message, style: const TextStyle(color: Color(0xFF718096))),
      ],
    );
  }
}