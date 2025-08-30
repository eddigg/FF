import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cercaend/backend/api_client.dart';
import 'package:cercaend/backend/models/status_model.dart';
import 'package:cercaend/flutter_flow/flutter_flow_theme.dart';

class StatusDisplayWidget extends StatefulWidget {
  const StatusDisplayWidget({Key? key}) : super(key: key);

  @override
  _StatusDisplayWidgetState createState() => _StatusDisplayWidgetState();
}

class _StatusDisplayWidgetState extends State<StatusDisplayWidget> {
  late Future<AppStatus> _statusFuture;
  final ApiClient _apiClient = ApiClient(http.Client());

  @override
  void initState() {
    super.initState();
    _statusFuture = _apiClient.getStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder<AppStatus>(
        future: _statusFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('ATLAS Sync Error: ${snapshot.error}', style: TextStyle(color: Colors.red));
          } else if (snapshot.hasData) {
            return Text('ATLAS Block Height: ${snapshot.data!.blockHeight}', style: FlutterFlowTheme.of(context).titleMedium);
          } else {
            return Text('No status data from ATLAS');
          }
        },
      ),
    );
  }
}
