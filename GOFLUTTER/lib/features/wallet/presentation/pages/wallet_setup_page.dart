
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/themes/web_colors.dart';
import '../../../../shared/themes/web_gradients.dart';
import '../../../../shared/themes/web_shadows.dart';
import '../../../../shared/themes/web_typography.dart';
import '../../../../shared/widgets/web_scaffold.dart';

class WalletSetupPage extends StatefulWidget {
  const WalletSetupPage({super.key});

  @override
  State<WalletSetupPage> createState() => _WalletSetupPageState();
}

class _WalletSetupPageState extends State<WalletSetupPage> {
  String _currentTab = 'create'; // 'create' or 'import'
  String _importMethod = 'file'; // 'file' or 'key'
  final TextEditingController _createPasswordController = TextEditingController();
  final TextEditingController _importPasswordController = TextEditingController();
  final TextEditingController _privateKeyController = TextEditingController();
  String? _selectedFileName;
  String? _statusMessage;
  bool _isLoading = false;

  void _switchTab(String tab) {
    setState(() {
      _currentTab = tab;
      _statusMessage = null; // Clear status message on tab switch
    });
  }

  void _showImportMethod(String method) {
    setState(() {
      _importMethod = method;
    });
  }

  void _handleFileSelect(String fileName) {
    setState(() {
      _selectedFileName = fileName;
    });
  }

  Future<void> _pickWalletFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null && result.files.isNotEmpty) {
      _handleFileSelect(result.files.single.name);
    } else {
      // User canceled the picker or an error occurred
      _showStatus('File selection cancelled or failed', isError: true);
    }
  }

  void _createWallet() async {
    final password = _createPasswordController.text;

    if (password.isEmpty) {
      _showStatus('Please enter a password', isError: true);
      return;
    }
    if (password.length < 8) {
      _showStatus('Password must be at least 8 characters long', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = null;
    });

    // Simulate wallet creation
    await Future.delayed(const Duration(seconds: 2));

    // In a real app, this would involve actual wallet creation logic
    // and then navigating to the dashboard.
    _showStatus('Wallet created successfully! Redirecting to dashboard...', isError: false);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      context.go('/dashboard'); // Assuming '/dashboard' is your dashboard route
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _importWallet() async {
    final password = _importPasswordController.text;

    if (_importMethod == 'file' && _selectedFileName == null) {
      _showStatus('Please select a wallet file', isError: true);
      return;
    }
    if (_importMethod == 'key' && _privateKeyController.text.isEmpty) {
      _showStatus('Please enter your private key', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = null;
    });

    // Simulate wallet import
    await Future.delayed(const Duration(seconds: 2));

    // In a real app, this would involve actual wallet import logic
    // and then navigating to the dashboard.
    _showStatus('Wallet imported successfully! Redirecting to dashboard...', isError: false);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      context.go('/dashboard'); // Assuming '/dashboard' is your dashboard route
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showStatus(String message, {required bool isError}) {
    setState(() {
      _statusMessage = message;
      // You might want to store isError as well to change the status message color
    });
  }

  @override
  void dispose() {
    _createPasswordController.dispose();
    _importPasswordController.dispose();
    _privateKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebScaffold(
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: WebColors.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: WebShadows.card,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: WebColors.textSecondary,
                  onPressed: () {
                    context.go('/intro'); // Assuming '/intro' is your intro route
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '🔐 Wallet Setup',
                style: WebTypography.h1.copyWith(color: WebColors.textPrimary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Set up your wallet to access ATLAS B.C.',
                style: WebTypography.subtitle.copyWith(color: WebColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  color: WebColors.formBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _switchTab('create'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                          decoration: BoxDecoration(
                            color: _currentTab == 'create' ? WebColors.surface : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: _currentTab == 'create' ? WebShadows.cardHover : null,
                          ),
                          child: Text(
                            'Create New',
                            textAlign: TextAlign.center,
                            style: WebTypography.body1.copyWith(
                              fontWeight: FontWeight.w600,
                              color: _currentTab == 'create' ? WebColors.primary : WebColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _switchTab('import'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                          decoration: BoxDecoration(
                            color: _currentTab == 'import' ? WebColors.surface : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: _currentTab == 'import' ? WebShadows.cardHover : null,
                          ),
                          child: Text(
                            'Import Existing',
                            textAlign: TextAlign.center,
                            style: WebTypography.body1.copyWith(
                              fontWeight: FontWeight.w600,
                              color: _currentTab == 'import' ? WebColors.primary : WebColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              if (_currentTab == 'create')
                _buildCreateWalletTab(),
              if (_currentTab == 'import')
                _buildImportWalletTab(),
              if (_statusMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: _buildStatusMessage(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreateWalletTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: WebColors.formBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border(left: BorderSide(color: WebColors.primary, width: 4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🔑 New Wallet',
                style: WebTypography.h4.copyWith(color: WebColors.textPrimary),
              ),
              const SizedBox(height: 10),
              Text(
                'Create a new wallet to get started with ATLAS B.C.',
                style: WebTypography.body2.copyWith(color: WebColors.textSecondary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Password',
          style: WebTypography.body1.copyWith(color: WebColors.textPrimary, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _createPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Enter a strong password',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: WebColors.formBorder, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: WebColors.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: WebGradients.buttonPrimary,
            borderRadius: BorderRadius.all(Radius.circular(8)),
            boxShadow: WebShadows.button,
          ),
          child: ElevatedButton(
            onPressed: _isLoading ? null : _createWallet,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent, // Make button background transparent
              shadowColor: Colors.transparent, // Remove shadow from ElevatedButton
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: WebColors.surface,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    '🔑 Create New Wallet',
                    style: WebTypography.button.copyWith(color: WebColors.surface),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildImportWalletTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: WebColors.formBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border(left: BorderSide(color: WebColors.primary, width: 4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '📁 Import Wallet',
                style: WebTypography.h4.copyWith(color: WebColors.textPrimary),
              ),
              const SizedBox(height: 10),
              Text(
                'Import an existing wallet using a JSON file or enter your private key. Make sure you have your wallet file ready.',
                style: WebTypography.body2.copyWith(color: WebColors.textSecondary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Import Method',
          style: WebTypography.body1.copyWith(color: WebColors.textPrimary, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: _importMethod == 'file' ? WebGradients.buttonSecondary : null,
                  color: _importMethod == 'file' ? null : WebColors.buttonSecondary,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: _importMethod == 'file' ? WebShadows.button : null,
                ),
                child: ElevatedButton(
                  onPressed: () => _showImportMethod('file'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    '📁 File',
                    style: WebTypography.button.copyWith(color: WebColors.surface),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: _importMethod == 'key' ? WebGradients.buttonSecondary : null,
                  color: _importMethod == 'key' ? null : WebColors.buttonSecondary,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: _importMethod == 'key' ? WebShadows.button : null,
                ),
                child: ElevatedButton(
                  onPressed: () => _showImportMethod('key'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    '🔑 Private Key',
                    style: WebTypography.button.copyWith(color: WebColors.surface),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (_importMethod == 'file')
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Upload Wallet File',
                style: WebTypography.body1.copyWith(color: WebColors.textPrimary, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  _pickWalletFile();
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _selectedFileName != null ? WebColors.primary : WebColors.formBorder,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _selectedFileName != null ? '📁 Selected: $_selectedFileName' : '📁 Choose wallet file or drag and drop here',
                    textAlign: TextAlign.center,
                    style: WebTypography.body1.copyWith(color: WebColors.textSecondary),
                  ),
                ),
              ),
            ],
          ),
        if (_importMethod == 'key')
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Private Key',
                style: WebTypography.body1.copyWith(color: WebColors.textPrimary, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _privateKeyController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Enter your private key',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: WebColors.formBorder, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: WebColors.primary, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
              ),
            ],
          ),
        const SizedBox(height: 20),
        Text(
          'Password (if encrypted)',
          style: WebTypography.body1.copyWith(color: WebColors.textPrimary, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _importPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Enter wallet password if encrypted',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: WebColors.formBorder, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: WebColors.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: WebGradients.buttonPrimary,
            borderRadius: BorderRadius.circular(8),
            boxShadow: WebShadows.button,
          ),
          child: ElevatedButton(
            onPressed: _isLoading ? null : _importWallet,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: WebColors.surface,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    '📥 Import Wallet',
                    style: WebTypography.button.copyWith(color: WebColors.surface),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusMessage() {
    if (_statusMessage == null) return const SizedBox.shrink();

    bool isError = _statusMessage!.contains('error') || _statusMessage!.contains('failed');
    Color backgroundColor = isError ? WebColors.statusErrorBackground : WebColors.statusSuccessBackground;
    Color textColor = isError ? WebColors.statusErrorText : WebColors.statusSuccessText;
    Color borderColor = isError ? WebColors.statusErrorBorder : WebColors.statusSuccessBorder;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.check_circle_outline,
            color: textColor,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _statusMessage!,
              style: WebTypography.body2.copyWith(color: textColor, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
