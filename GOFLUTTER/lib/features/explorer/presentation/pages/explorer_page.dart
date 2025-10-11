import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart';
import '../../../../core/stubs/stub_blocs_clean.dart';
import '../widgets/block_list_item.dart';
import '../widgets/transaction_list_item.dart';
import '../widgets/search_bar.dart';
import 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart';
import 'package:atlas_blockchain_flutter/shared/widgets/web_scaffold.dart';

class ExplorerPage extends StatefulWidget {
  const ExplorerPage({super.key});

  @override
  State<ExplorerPage> createState() => _ExplorerPageState();
}

class _ExplorerPageState extends State<ExplorerPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExplorerBloc>().add(LoadRecentBlocks());
      context.read<ExplorerBloc>().add(StartAutoRefresh());
    });
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (!_tabController.indexIsChanging) return;
    if (_tabController.index == 1) {
      context.read<ExplorerBloc>().add(LoadRecentTransactions());
    } else {
      context.read<ExplorerBloc>().add(LoadRecentBlocks());
    }
  }

  @override
  void dispose() {
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
      body: Column(
        children: [
          const ExplorerSearchBar(),
          const SizedBox(height: 30),
          Expanded(
            child: GlassCard(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Latest Blocks'),
                      Tab(text: 'Latest Transactions'),
                    ],
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                    unselectedLabelColor: Colors.grey,
                    indicator: const UnderlineTabIndicator(
                      borderSide: BorderSide(
                        width: 3,
                        color: Color(0xFF4299E1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [_buildBlocksView(), _buildTransactionsView()],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlocksView() {
    return BlocBuilder<ExplorerBloc, ExplorerState>(
      builder: (context, state) {
        if (state.status == ExplorerStatus.loading && state.blocks.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == ExplorerStatus.failure) {
          return Center(
            child: Text(
              'Error: ${state.errorMessage}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        if (state.blocks.isEmpty) {
          return const Center(child: Text('No blocks found'));
        }
        return ListView.builder(
          itemCount: state.blocks.length,
          itemBuilder: (context, index) =>
              BlockListItem(block: state.blocks[index]),
        );
      },
    );
  }

  Widget _buildTransactionsView() {
    return BlocBuilder<ExplorerBloc, ExplorerState>(
      builder: (context, state) {
        if (state.status == ExplorerStatus.loading &&
            state.transactions.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == ExplorerStatus.failure) {
          return Center(
            child: Text(
              'Error: ${state.errorMessage}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        if (state.transactions.isEmpty) {
          return const Center(child: Text('No transactions found'));
        }
        return ListView.builder(
          itemCount: state.transactions.length,
          itemBuilder: (context, index) =>
              TransactionListItem(transaction: state.transactions[index]),
        );
      },
    );
  }
}
