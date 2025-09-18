import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/glass_card.dart' as glass_card;
import '../../../../shared/widgets/common_widgets.dart';
import '../bloc/governance_bloc.dart';

class CreateProposalPage extends StatefulWidget {
  const CreateProposalPage({Key? key}) : super(key: key);

  @override
  State<CreateProposalPage> createState() => _CreateProposalPageState();
}

class _CreateProposalPageState extends State<CreateProposalPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _actionTypeController = TextEditingController();
  final _actionTargetController = TextEditingController();
  final _actionDescriptionController = TextEditingController();
  final _actionImpactController = TextEditingController();
  
  String _selectedCategory = 'technical';
  String _selectedImpact = 'medium';
  
  final List<Map<String, String>> _actions = [];
  
  final List<String> _categories = [
    'technical',
    'defi',
    'social',
    'economic',
    'platform',
    'treasury'
  ];
  
  final List<String> _impacts = ['low', 'medium', 'high', 'critical'];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _actionTypeController.dispose();
    _actionTargetController.dispose();
    _actionDescriptionController.dispose();
    _actionImpactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.containerPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProposalForm(),
                        const SizedBox(height: AppSpacing.lg),
                        _buildActionsSection(),
                        const SizedBox(height: AppSpacing.lg),
                        _buildSubmitButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => AppColors.cardGradient.createShader(bounds),
          child: Text(
            'Create Proposal',
            style: AppTextStyles.h2.copyWith(
              color: Colors.white,
              fontSize: 32,
            ),
          ),
        ),
        GradientButton(
          text: 'Back',
          icon: Icons.arrow_back,
          onPressed: () => context.go('/governance'),
        ),
      ],
    );
  }

  Widget _buildProposalForm() {
    return glass_card.GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Proposal Details',
            style: AppTextStyles.h4.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          
          // Title
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Title',
              labelStyle: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
              filled: true,
              fillColor: AppColors.backgroundLight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                borderSide: BorderSide.none,
              ),
            ),
            style: AppTextStyles.body1.copyWith(color: AppColors.textPrimary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              if (value.length < 10) {
                return 'Title must be at least 10 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.md),
          
          // Description
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'Description',
              labelStyle: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
              filled: true,
              fillColor: AppColors.backgroundLight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                borderSide: BorderSide.none,
              ),
            ),
            style: AppTextStyles.body1.copyWith(color: AppColors.textPrimary),
            maxLines: 5,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a description';
              }
              if (value.length < 50) {
                return 'Description must be at least 50 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.md),
          
          // Category
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: InputDecoration(
              labelText: 'Category',
              labelStyle: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
              filled: true,
              fillColor: AppColors.backgroundLight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                borderSide: BorderSide.none,
              ),
            ),
            style: AppTextStyles.body1.copyWith(color: AppColors.textPrimary),
            items: _categories.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category.toUpperCase()),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedCategory = newValue;
                });
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a category';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionsSection() {
    return glass_card.GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Proposed Actions',
            style: AppTextStyles.h4.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          
          // Action form
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.backgroundLight.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              border: Border.all(
                color: AppColors.backgroundMid,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // Action Type
                TextFormField(
                  controller: _actionTypeController,
                  decoration: InputDecoration(
                    labelText: 'Action Type',
                    labelStyle: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                    filled: true,
                    fillColor: AppColors.backgroundLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: AppTextStyles.body1.copyWith(color: AppColors.textPrimary),
                ),
                const SizedBox(height: AppSpacing.sm),
                
                // Action Target
                TextFormField(
                  controller: _actionTargetController,
                  decoration: InputDecoration(
                    labelText: 'Target',
                    labelStyle: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                    filled: true,
                    fillColor: AppColors.backgroundLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: AppTextStyles.body1.copyWith(color: AppColors.textPrimary),
                ),
                const SizedBox(height: AppSpacing.sm),
                
                // Action Description
                TextFormField(
                  controller: _actionDescriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                    filled: true,
                    fillColor: AppColors.backgroundLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: AppTextStyles.body1.copyWith(color: AppColors.textPrimary),
                  maxLines: 2,
                ),
                const SizedBox(height: AppSpacing.sm),
                
                // Action Impact
                DropdownButtonFormField<String>(
                  value: _selectedImpact,
                  decoration: InputDecoration(
                    labelText: 'Impact',
                    labelStyle: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                    filled: true,
                    fillColor: AppColors.backgroundLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: AppTextStyles.body1.copyWith(color: AppColors.textPrimary),
                  items: _impacts.map((String impact) {
                    return DropdownMenuItem<String>(
                      value: impact,
                      child: Text(impact.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedImpact = newValue;
                      });
                    }
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                
                // Add Action Button
                GradientButton(
                  text: 'Add Action',
                  onPressed: _addAction,
                  height: 36,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppSpacing.md),
          
          // Added Actions List
          if (_actions.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              'Added Actions',
              style: AppTextStyles.body1.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ..._actions.asMap().entries.map((entry) {
              final index = entry.key;
              final action = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  border: Border.all(
                    color: AppColors.backgroundMid,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            action['type'] ?? '',
                            style: AppTextStyles.body2.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            action['description'] ?? '',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: AppColors.error, size: 20),
                      onPressed: () => _removeAction(index),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return glass_card.GlassCard(
      child: Column(
        children: [
          BlocConsumer<GovernanceBloc, dynamic>(
            listener: (context, state) {
              if (state is ProposalCreated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Proposal created successfully!',
                      style: AppTextStyles.body2.copyWith(color: Colors.white),
                    ),
                    backgroundColor: AppColors.success,
                  ),
                );
                context.go('/governance');
              } else if (state is GovernanceError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Error: ${state.message}',
                      style: AppTextStyles.body2.copyWith(color: Colors.white),
                    ),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            builder: (context, state) {
              return GradientButton(
                text: state is GovernanceLoading ? 'Creating...' : 'Create Proposal',
                onPressed: state is GovernanceLoading ? null : _submitProposal,
                isLoading: state is GovernanceLoading,
              );
            },
          ),
        ],
      ),
    );
  }

  void _addAction() {
    if (_actionTypeController.text.isNotEmpty) {
      setState(() {
        _actions.add({
          'type': _actionTypeController.text,
          'target': _actionTargetController.text,
          'description': _actionDescriptionController.text,
          'impact': _selectedImpact,
        });
        
        // Clear form fields
        _actionTypeController.clear();
        _actionTargetController.clear();
        _actionDescriptionController.clear();
        _selectedImpact = 'medium';
      });
    }
  }

  void _removeAction(int index) {
    setState(() {
      _actions.removeAt(index);
    });
  }

  void _submitProposal() {
    if (_formKey.currentState!.validate()) {
      if (_actions.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please add at least one action',
              style: AppTextStyles.body2.copyWith(color: Colors.white),
            ),
            backgroundColor: AppColors.warning,
          ),
        );
        return;
      }

      // For now, we'll just submit a simple proposal using the existing SubmitProposal event
      context.read<GovernanceBloc>().add(
            SubmitProposal(
              proposer: 'current_user_address', // This should be the actual user's address
              description: '${_titleController.text}: ${_descriptionController.text}',
              actions: 'Proposal actions', // Simplified for now
              duration: 100, // Default duration
            ),
          );
    }
  }
}