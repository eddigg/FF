import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/node_dashboard_bloc.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/common_widgets.dart';

class PeerMonitoringSection extends StatelessWidget {
  const PeerMonitoringSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Peer Monitoring', style: AppTextStyles.h4),
            const SizedBox(height: AppSpacing.md),
            BlocBuilder<NodeDashboardBloc, NodeDashboardState>(
              builder: (context, state) {
                if (state is NodeDashboardLoaded) {
                  return Column(
                    children: [
                      _buildPeerInfoCard('Connected Peers', state.networkStats.totalValidators.toString()),
                      _buildPeerInfoCard('Network Hash Rate', state.networkStats.networkHashRate),
                      _buildPeerInfoCard('Average Block Time', state.networkStats.avgBlockTime),
                      _buildPeerInfoCard('Network Difficulty', state.networkStats.networkDifficulty),
                    ],
                  );
                } else if (state is NodeDashboardLoading) {
                  return const CircularProgressIndicator();
                } else {
                  return const Text('Error loading peer information');
                }
              },
            ),
            const SizedBox(height: AppSpacing.md),
            const Text('Peer Management', style: AppTextStyles.h4),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                GradientButton(text: 'Add Peer', onPressed: () {}),
                GradientButton(text: 'Remove Peer', onPressed: () {}),
                GradientButton(text: 'Ban Peer', onPressed: () {}),
                GradientButton(text: 'Refresh Peers', onPressed: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeerInfoCard(String title, String value) {
    return GlassCard(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.h5),
            const SizedBox(height: AppSpacing.sm),
            Text(value, style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}