import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/governance_bloc.dart';
import '../../data/models/proposal_model.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/common_widgets.dart';

class ProposalsSection extends StatefulWidget {
  const ProposalsSection({Key? key}) : super(key: key);

  @override
  State<ProposalsSection> createState() => _ProposalsSectionState();
}

class _ProposalsSectionState extends State<ProposalsSection> {
  final _proposalFormKey = GlobalKey<FormState>();
  final _voteFormKey = GlobalKey<FormState>();
  
  final _proposerController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _actionsController = TextEditingController();
  final _durationController = TextEditingController(text: '10');
  
  final _voteProposalIdController = TextEditingController();
  final _voterController = TextEditingController();
  final _weightController = TextEditingController(text: '1');
  
  String _choice = 'for';

  @override
  void dispose() {
    _proposerController.dispose();
    _descriptionController.dispose();
    _actionsController.dispose();
    _durationController.dispose();
    _voteProposalIdController.dispose();
    _voterController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _submitProposal() {
    if (_proposalFormKey.currentState?.validate() ?? false) {
      final proposer = _proposerController.text.trim();
      final description = _descriptionController.text.trim();
      final actions = _actionsController.text.trim();
      final duration = int.tryParse(_durationController.text.trim()) ?? 10;
      
      context.read<GovernanceBloc>().add(
        SubmitProposal(
          proposer: proposer,
          description: description,
          actions: actions,
          duration: duration,
        ),
      );
      
      // Clear form
      _proposerController.clear();
      _descriptionController.clear();
      _actionsController.clear();
      _durationController.text = '10';
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Proposal submitted successfully!')),
      );
    }
  }

  void _castVote() {
    if (_voteFormKey.currentState?.validate() ?? false) {
      final proposalID = _voteProposalIdController.text.trim();
      final voter = _voterController.text.trim();
      final weight = int.tryParse(_weightController.text.trim()) ?? 1;
      
      context.read<GovernanceBloc>().add(
        CastVote(
          proposalID: proposalID,
          voter: voter,
          choice: _choice,
          weight: weight,
        ),
      );
      
      // Clear form
      _voteProposalIdController.clear();
      _voterController.clear();
      _weightController.text = '1';
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vote cast successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Proposals', style: AppTextStyles.h4),
            const SizedBox(height: AppSpacing.md),
            BlocBuilder<GovernanceBloc, dynamic>(
              builder: (context, state) {
                if (state is GovernanceLoaded) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.proposals.length,
                    itemBuilder: (context, index) {
                      final proposal = state.proposals[index];
                      return GlassCard(
                        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: ListTile(
                          title: Text(proposal.description),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('ID: ${proposal.id}'),
                              Text('Votes For: ${proposal.votesFor}, Votes Against: ${proposal.votesAgainst}'),
                              Text('Start: ${proposal.startBlock}, End: ${proposal.endBlock}'),
                            ],
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                            decoration: BoxDecoration(
                              color: proposal.state == 'Voting' ? AppColors.success : AppColors.warning,
                              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                            ),
                            child: Text(proposal.state, style: const TextStyle(color: Colors.white, fontSize: 12)),
                          ),
                          onTap: () {
                            _showProposalDetails(context, proposal);
                          },
                        ),
                      );
                    },
                  );
                } else if (state is GovernanceLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is GovernanceError) {
                  return Text('Error: ${state.message}');
                } else {
                  return const Text('No data available');
                }
              },
            ),
            const SizedBox(height: AppSpacing.md),
            const Text('Submit Proposal', style: AppTextStyles.h5),
            const SizedBox(height: AppSpacing.sm),
            Form(
              key: _proposalFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _proposerController,
                    decoration: const InputDecoration(
                      labelText: 'Proposer Address',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value?.isEmpty ?? true ? 'Please enter proposer address' : null,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value?.isEmpty ?? true ? 'Please enter description' : null,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextFormField(
                    controller: _actionsController,
                    decoration: const InputDecoration(
                      labelText: 'Actions (JSON or text)',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value?.isEmpty ?? true ? 'Please enter actions' : null,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextFormField(
                    controller: _durationController,
                    decoration: const InputDecoration(
                      labelText: 'Voting Duration (blocks)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) => value?.isEmpty ?? true ? 'Please enter duration' : null,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  GradientButton(
                    text: 'Submit Proposal',
                    onPressed: _submitProposal,
                    gradient: AppColors.successGradient,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const Text('Vote on Proposal', style: AppTextStyles.h5),
            const SizedBox(height: AppSpacing.sm),
            Form(
              key: _voteFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _voteProposalIdController,
                    decoration: const InputDecoration(
                      labelText: 'Proposal ID',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value?.isEmpty ?? true ? 'Please enter proposal ID' : null,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextFormField(
                    controller: _voterController,
                    decoration: const InputDecoration(
                      labelText: 'Voter Address',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value?.isEmpty ?? true ? 'Please enter voter address' : null,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  DropdownButtonFormField<String>(
                    value: _choice,
                    decoration: const InputDecoration(
                      labelText: 'Choice',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'for', child: Text('For')),
                      DropdownMenuItem(value: 'against', child: Text('Against')),
                    ],
                    onChanged: (value) => setState(() => _choice = value ?? 'for'),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextFormField(
                    controller: _weightController,
                    decoration: const InputDecoration(
                      labelText: 'Voting Power (Weight)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) => value?.isEmpty ?? true ? 'Please enter weight' : null,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  GradientButton(
                    text: 'Cast Vote',
                    onPressed: _castVote,
                    gradient: AppColors.successGradient,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProposalDetails(BuildContext context, ProposalModel proposal) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Proposal Details', style: AppTextStyles.h4),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text('ID: ${proposal.id}', style: AppTextStyles.body1),
              const SizedBox(height: AppSpacing.sm),
              Text('Description: ${proposal.description}', style: AppTextStyles.body1),
              const SizedBox(height: AppSpacing.sm),

              Text('State: ${proposal.state}', style: AppTextStyles.body1),
              const SizedBox(height: AppSpacing.sm),
              Text('Votes For: ${proposal.votesFor}', style: AppTextStyles.body1),
              const SizedBox(height: AppSpacing.sm),
              Text('Votes Against: ${proposal.votesAgainst}', style: AppTextStyles.body1),
              const SizedBox(height: AppSpacing.sm),
              Text('Start Block: ${proposal.startBlock}', style: AppTextStyles.body1),
              const SizedBox(height: AppSpacing.sm),
              Text('End Block: ${proposal.endBlock}', style: AppTextStyles.body1),
              const SizedBox(height: AppSpacing.sm),

              GradientButton(
                text: 'Close',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
    );
  }

}
