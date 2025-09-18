import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/explorer_bloc.dart';
import '../widgets/block_list_item.dart';
import '../widgets/transaction_list_item.dart';
import '../widgets/search_bar.dart';
import '../../../../shared/themes/web_colors.dart';
import '../../../../shared/widgets/web_scaffold.dart';

class ExplorerPage extends StatefulWidget {
  const ExplorerPage({Key? key}) : super(key: key);

  @override
  State<ExplorerPage> createState() => _ExplorerPageState();
}

class _ExplorerPageState extends State<ExplorerPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExplorerBloc>().add(LoadRecentBlocks());
      // Start auto-refresh
      context.read<ExplorerBloc>().add(StartAutoRefresh());
    });
    
    // Add listener to load transactions when switching to the transactions tab
    _tabController.addListener(_handleTabSelection);
  }
  
  void _handleTabSelection() {
    if (_tabController.index == 1 && _tabController.indexIsChanging) {
      // Transactions tab is selected
      context.read<ExplorerBloc>().add(LoadRecentTransactions());
    } else if (_tabController.index == 0 && _tabController.indexIsChanging) {
      // Blocks tab is selected
      context.read<ExplorerBloc>().add(LoadRecentBlocks());
    }
  }

  @override
  void dispose() {
    // Stop auto-refresh
    context.read<ExplorerBloc>().add(StopAutoRefresh());
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebScaffold(
      title: 'Blockchain Explorer',
      showBackButton: true,
      bottom: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: 'Blocks'),
          Tab(text: 'Transactions'),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            context.read<ExplorerBloc>().add(RefreshData());
          },
        ),
      ],
      child: Column(
        children: [
          const ExplorerSearchBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBlocksView(),
                _buildTransactionsView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlocksView() {
    return BlocBuilder<ExplorerBloc, ExplorerState>(
      builder: (context, state) {
        if (state is ExplorerLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ExplorerLoaded) {
          if (state.blocks.isEmpty) {
            return const Center(child: Text('No blocks found'));
          }
          return ListView.builder(
            itemCount: state.blocks.length,
            itemBuilder: (context, index) {
              return BlockListItem(block: state.blocks[index]);
            },
          );
        } else if (state is ExplorerError) {
          return Center(
            child: Text(
              'Error: ${state.message}',
              style: TextStyle(color: WebColors.error),
            ),
          );
        }
        return const Center(child: Text('Search for a block'));
      },
    );
  }

  Widget _buildTransactionsView() {
    return BlocBuilder<ExplorerBloc, ExplorerState>(
      builder: (context, state) {
        if (state is ExplorerLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ExplorerLoaded) {
          if (state.transactions.isEmpty) {
            return const Center(child: Text('No transactions found'));
          }
          return ListView.builder(
            itemCount: state.transactions.length,
            itemBuilder: (context, index) {
              return TransactionListItem(transaction: state.transactions[index]);
            },
          );
        } else if (state is ExplorerError) {
          return Center(
            child: Text(
              'Error: ${state.message}',
              style: TextStyle(color: WebColors.error),
            ),
          );
        }
        return const Center(child: Text('Search for a transaction'));
      },
    );
  }
}