import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/contracts_bloc.dart';
import '../../data/models/contract_example_model.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/custom_widgets.dart';

class ContractExamplesSection extends StatelessWidget {
  const ContractExamplesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const EnhancedGlassCard(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Contract Examples', style: AppTextStyles.h4),
            SizedBox(height: AppSpacing.md),
            Text('Examples are available through the Load Example button in the deployment section.', style: AppTextStyles.body2),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleCard(BuildContext context, ContractExampleModel example) {
    return EnhancedGlassCard(
      child: ListTile(
        title: Text(example.name, style: AppTextStyles.h5),
        subtitle: Text(example.description, style: AppTextStyles.body2),
        onTap: () {
          // Send event to BLoC to load example
          context.read<ContractsBloc>().add(LoadExampleContract(example: example));
        },
      ),
    );
  }


}