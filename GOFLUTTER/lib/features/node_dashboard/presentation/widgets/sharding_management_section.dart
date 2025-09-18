import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/node_dashboard_bloc.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/common_widgets.dart';

class ShardingManagementSection extends StatelessWidget {
  const ShardingManagementSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Sharding Management', style: AppTextStyles.h4),
            const SizedBox(height: AppSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildShardingCard(
                    'Shard Overview',
                    [
                      GradientButton(
                        text: '🔄 Refresh Status',
                        onPressed: () {
                          // TODO: Implement refresh sharding status
                        },
                        gradient: AppColors.secondaryGradient,
                        width: double.infinity,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      BlocBuilder<NodeDashboardBloc, NodeDashboardState>(
                        builder: (context, state) {
                          if (state is NodeDashboardLoaded) {
                            return Text(
                              state.shardingInfo.shardOverview,
                              style: AppTextStyles.body2,
                            );
                          } else {
                            return const Text('Loading...');
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _buildShardingCard(
                    'Validator Assignment',
                    [
                      _buildTextField('Validator Address', '0x...'),
                      const SizedBox(height: AppSpacing.sm),
                      _buildDropdown('Shard ID', ['Shard 0', 'Shard 1', 'Shard 2', 'Shard 3']),
                      const SizedBox(height: AppSpacing.sm),
                      GradientButton(
                        text: '👤 Assign Validator',
                        onPressed: () {
                          // TODO: Implement assign validator
                        },
                        width: double.infinity,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildShardingCard(
                    'Cross-Shard Transactions',
                    [
                      _buildDropdown('Source Shard', ['Shard 0', 'Shard 1', 'Shard 2', 'Shard 3']),
                      const SizedBox(height: AppSpacing.sm),
                      _buildDropdown('Target Shard', ['Shard 1', 'Shard 2', 'Shard 3', 'Shard 0']),
                      const SizedBox(height: AppSpacing.sm),
                      _buildTextField('Transaction Data (JSON)', '{"amount": 100, "recipient": "0x..."}', maxLines: 3),
                      const SizedBox(height: AppSpacing.sm),
                      GradientButton(
                        text: '🔗 Create Cross-Shard TX',
                        onPressed: () {
                          // TODO: Implement create cross-shard transaction
                        },
                        width: double.infinity,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _buildShardingCard(
                    'Shard Statistics',
                    [
                      GradientButton(
                        text: '🔍 Get Shard Info',
                        onPressed: () {
                          // TODO: Implement get shard info
                        },
                        width: double.infinity,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _buildDropdown('Shard ID', ['Shard 0', 'Shard 1', 'Shard 2', 'Shard 3']),
                      const SizedBox(height: AppSpacing.sm),
                      GradientButton(
                        text: '📊 Load Statistics',
                        onPressed: () {
                          // TODO: Implement load statistics
                        },
                        width: double.infinity,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShardingCard(String title, List<Widget> children) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.h5.copyWith(color: AppColors.primary)),
            const SizedBox(height: AppSpacing.sm),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      style: AppTextStyles.body1,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(color: AppColors.border, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(color: AppColors.border, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(color: AppColors.border, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(color: AppColors.border, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item, style: AppTextStyles.body1),
        );
      }).toList(),
      onChanged: (String? newValue) {
        // TODO: Handle dropdown change
      },
    );
  }
}