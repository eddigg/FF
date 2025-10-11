import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/dashboard_bloc.dart';
import '../../../../shared/widgets/web_button.dart';
import '../../../../shared/widgets/status_indicator.dart';
import '../../../../shared/themes/web_parity_theme.dart';
import '../../../../shared/themes/web_colors.dart';
import '../../../../shared/themes/web_typography.dart';

/// Node selector widget matching web functionality
class NodeSelector extends StatefulWidget {
  const NodeSelector({Key? key}) : super(key: key);

  @override
  State<NodeSelector> createState() => _NodeSelectorState();
}

class _NodeSelectorState extends State<NodeSelector> {
  // Available ports matching web implementation
  final List<int> _ports = [8080, 8081, 8082, 8083];
  
  // Current selected port
  int _selectedPort = 8081;

  @override
  void initState() {
    super.initState();
    _loadSelectedPort();
  }

  /// Load the selected port from shared preferences
  Future<void> _loadSelectedPort() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPort = prefs.getInt('selectedNodePort') ?? 8081;
    setState(() {
      _selectedPort = savedPort;
    });
  }

  /// Save the selected port to shared preferences
  Future<void> _saveSelectedPort(int port) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedNodePort', port);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(WebParityTheme.navBarPadding),
      decoration: BoxDecoration(
        color: WebColors.surfaceOpaque,
        borderRadius: BorderRadius.circular(WebParityTheme.radiusXl),
        border: Border.all(
          color: WebColors.borderCard,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Status indicator with animated pulse effect
          Expanded(
            flex: 3,
            child: StatusIndicator(
              status: StatusType.online,
              customLabel: 'Node $_selectedPort',
            ),
          ),
          // Port selection buttons
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: _ports.map((port) {
                return Padding(
                  padding: const EdgeInsets.only(left: WebParityTheme.spacingXs),
                  child: WebButton(
                    text: port.toString(),
                    variant: port == _selectedPort
                        ? WebButtonVariant.success
                        : WebButtonVariant.primary,
                    width: 35, // Fixed width to prevent overflow
                    height: 25, // Smaller height
                    onPressed: () {
                      // Update the selected port locally
                      setState(() {
                        _selectedPort = port;
                      });
                      
                      // Save to shared preferences
                      _saveSelectedPort(port);
                      
                      // Dispatch event to BLoC to update API client and refresh data
                      context.read<DashboardBloc>().add(ChangeNode(port));
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
