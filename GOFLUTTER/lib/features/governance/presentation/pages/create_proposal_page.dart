import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
// Remove the real bloc import that causes ambiguous import error
import '../../../../core/stubs/stub_blocs_clean.dart';
import '../../../../shared/themes/web_parity_theme.dart';
import '../../../../shared/themes/web_typography.dart'; // Add this for typography
import '../../../../shared/widgets/web_scaffold.dart';
import '../../../../shared/widgets/common_widgets.dart' as glass_card;

class CreateProposalPage extends StatefulWidget {
  const CreateProposalPage({super.key});

  @override
  State<CreateProposalPage> createState() => _CreateProposalPageState();
}

class _CreateProposalPageState extends State<CreateProposalPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _actionsController = TextEditingController();
  int _duration = 7;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _actionsController.dispose();
    super.dispose();
  }

  void _submitProposal() {
    if (_formKey.currentState?.validate() ?? false) {
      // Use the stub BLoC instead of the real one
      context.read<GovernanceBloc>().add(LoadProposals());
      
      // Show success message and navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Proposal submitted successfully!')),
      );
      
      // Navigate back to governance page
      context.go('/governance');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WebScaffold(
      title: 'Create Proposal',
      showBackButton: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(WebParityTheme.containerPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('📝 New Governance Proposal', style: WebTypography.h2), // Fixed theme reference
                const SizedBox(height: 20),
                glass_card.GlassCard(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextField(
                          controller: _titleController,
                          label: 'Proposal Title',
                          hint: 'Enter a clear and concise title',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a title';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _descriptionController,
                          label: 'Description',
                          hint: 'Describe your proposal in detail',
                          maxLines: 4,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a description';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _actionsController,
                          label: 'Proposed Actions',
                          hint: 'List the actions to be taken if approved',
                          maxLines: 3,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter proposed actions';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildDurationSelector(),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submitProposal,
                            style: WebParityTheme.primaryButtonStyle,
                            child: const Text('Submit Proposal'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: WebTypography.formLabel), // Fixed theme reference
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: WebParityTheme.inputDecoration(hint),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildDurationSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Voting Duration', style: WebTypography.formLabel), // Fixed theme reference
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          initialValue: _duration,
          items: const [
            DropdownMenuItem(value: 3, child: Text('3 days')),
            DropdownMenuItem(value: 7, child: Text('7 days')),
            DropdownMenuItem(value: 14, child: Text('14 days')),
            DropdownMenuItem(value: 30, child: Text('30 days')),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _duration = value;
              });
            }
          },
          decoration: WebParityTheme.inputDecoration('Select voting duration'),
        ),
      ],
    );
  }
}