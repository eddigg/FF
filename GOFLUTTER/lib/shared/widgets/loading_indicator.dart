import 'package:flutter/material.dart';
import '../themes/web_colors.dart';
import '../themes/web_gradients.dart';
import '../themes/web_shadows.dart';
import 'common_widgets.dart';

/// Loading indicator widget matching web loading patterns
class LoadingIndicator extends StatelessWidget {
  final String message;
  final bool showSkeleton;

  const LoadingIndicator({
    super.key,
    this.message = 'Loading...',
    this.showSkeleton = false,
  });

  @override
  Widget build(BuildContext context) {
    if (showSkeleton) {
      return _buildSkeletonLoading();
    }

    return _buildSpinnerLoading();
  }

  /// Build spinner loading indicator matching web patterns
  Widget _buildSpinnerLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Custom spinner with gradient colors matching web
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: WebGradients.buttonPrimary,
              shape: BoxShape.circle,
              boxShadow: WebShadows.card,
            ),
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(WebColors.textPrimary),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              color: WebColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  /// Build skeleton loading state matching web patterns
  Widget _buildSkeletonLoading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Skeleton header
        _buildSkeletonLine(widthFactor: 0.8, height: 24),
        const SizedBox(height: 12),

        // Skeleton content lines
        _buildSkeletonLine(widthFactor: 1.0, height: 16),
        const SizedBox(height: 8),
        _buildSkeletonLine(widthFactor: 0.9, height: 16),
        const SizedBox(height: 8),
        _buildSkeletonLine(widthFactor: 0.7, height: 16),
        const SizedBox(height: 16),

        // Skeleton card grid
        const Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _SkeletonCard(),
            _SkeletonCard(),
            _SkeletonCard(),
            _SkeletonCard(),
          ],
        ),
      ],
    );
  }

  /// Build a skeleton line placeholder
  Widget _buildSkeletonLine({
    required double widthFactor,
    required double height,
  }) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: WebGradients.cardBackground,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

/// Skeleton card widget for loading states
class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Skeleton icon placeholder
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: WebGradients.cardBackground,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 12),

            // Skeleton title placeholder
            Container(
              height: 20,
              width: 120,
              decoration: BoxDecoration(
                gradient: WebGradients.cardBackground,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),

            // Skeleton description placeholder
            Container(
              height: 14,
              width: 160,
              decoration: BoxDecoration(
                gradient: WebGradients.cardBackground,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),

            Container(
              height: 14,
              width: 100,
              decoration: BoxDecoration(
                gradient: WebGradients.cardBackground,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
