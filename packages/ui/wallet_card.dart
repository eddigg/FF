// products/shared/ui/wallet_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/wallet_model.dart';
import '../../wallets/mobile/lib/blocs/wallet_bloc.dart';
import 'shared_button.dart';

class WalletCard extends StatefulWidget {
  const WalletCard({Key? key}) : super(key: key);

  @override
  _WalletCardState createState() => _WalletCardState();
}

class _WalletCardState extends State<WalletCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<WalletBloc, WalletState>(
      builder: (context, state) {
        return Card(
          elevation: 4,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${l10n.walletAddress}: ${state is WalletLoaded ? state.wallet.address : 'Loading...'}', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                if (_isExpanded || state is WalletLoaded) ...[
                  Text('${l10n.balance}: ${state is WalletLoaded ? state.wallet.balance : 0} ATLAS'),
                  SizedBox(height: 8),
                  Text('${l10n.transactions}: ${state is WalletLoaded ? state.wallet.transactions.length : 0}'),
                  SizedBox(height: 16),
                  SharedButton(
                    text: l10n.refreshBalance,
                    onPressed: () => context.read<WalletBloc>().add(RefreshBalance()),
                    isLoading: state is WalletLoading,
                  ),
                  SizedBox(height: 8),
                  SharedButton(
                    text: l10n.sendAtlas,
                    onPressed: () => context.read<WalletBloc>().add(SendTransaction('0xRecipient', 10.0)),
                  ),
                ],
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => setState(() => _isExpanded = !_isExpanded),
                  child: Text(_isExpanded ? 'Collapse' : 'Expand'),
                ),
                if (state is WalletLoading && !_isExpanded) Text(l10n.loading),
                if (state is WalletError) Text(state.message),
              ],
            ),
          ),
        );
      },
    );
  }
}
