import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/explorer_bloc.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/widgets/common_widgets.dart';
import '../../../../shared/widgets/custom_widgets.dart';

class ExplorerSearchBar extends StatefulWidget {
  const ExplorerSearchBar({Key? key}) : super(key: key);

  @override
  _ExplorerSearchBarState createState() => _ExplorerSearchBarState();
}

class _ExplorerSearchBarState extends State<ExplorerSearchBar> {
  final _textController = TextEditingController();
  SearchType _searchType = SearchType.blockHash;

  @override
  Widget build(BuildContext context) {
    return EnhancedGlassCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            // Search type selector
            Row(
              children: [
                const Text('Search by:', style: AppTextStyles.body2),
                const SizedBox(width: AppSpacing.sm),
                DropdownButton<SearchType>(
                  value: _searchType,
                  items: const [
                    DropdownMenuItem(
                      value: SearchType.blockHash,
                      child: Text('Block Hash', style: AppTextStyles.body2),
                    ),
                    DropdownMenuItem(
                      value: SearchType.blockNumber,
                      child: Text('Block Number', style: AppTextStyles.body2),
                    ),
                    DropdownMenuItem(
                      value: SearchType.address,
                      child: Text('Address', style: AppTextStyles.body2),
                    ),
                  ],
                  onChanged: (SearchType? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _searchType = newValue;
                      });
                    }
                  },
                  underline: Container(),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _textController,
              style: AppTextStyles.body1,
              decoration: InputDecoration(
                hintText: _getHintText(),
                hintStyle: AppTextStyles.body1.copyWith(color: AppColors.textMuted),
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
              onSubmitted: (value) {
                _performSearch(context);
              },
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GradientButton(
                  text: 'Search',
                  onPressed: () {
                    _performSearch(context);
                  },
                ),
                const SizedBox(width: AppSpacing.sm),
                GradientButton(
                  text: 'Clear',
                  onPressed: () {
                    _textController.clear();
                    context.read<ExplorerBloc>().add(LoadRecentBlocks());
                  },
                  gradient: AppColors.warningGradient,
                ),
                const SizedBox(width: AppSpacing.sm),
                GradientButton(
                  text: 'Refresh',
                  onPressed: () {
                    context.read<ExplorerBloc>().add(RefreshData());
                  },
                  gradient: AppColors.infoGradient,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getHintText() {
    switch (_searchType) {
      case SearchType.blockHash:
        return 'Enter block hash...';
      case SearchType.blockNumber:
        return 'Enter block number...';
      case SearchType.address:
        return 'Enter address...';
    }
  }

  void _performSearch(BuildContext context) {
    final query = _textController.text.trim();
    if (query.isEmpty) return;

    switch (_searchType) {
      case SearchType.blockHash:
        context.read<ExplorerBloc>().add(SearchByHash(query));
        break;
      case SearchType.blockNumber:
        final blockNumber = int.tryParse(query);
        if (blockNumber != null) {
          context.read<ExplorerBloc>().add(SearchByBlockNumber(blockNumber));
        } else {
          // Show error
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please enter a valid block number'),
              backgroundColor: AppColors.error,
            ),
          );
        }
        break;
      case SearchType.address:
        context.read<ExplorerBloc>().add(SearchByAddress(query));
        break;
    }
  }
}

enum SearchType { blockHash, blockNumber, address }