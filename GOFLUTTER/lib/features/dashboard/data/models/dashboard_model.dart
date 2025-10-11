import 'package:equatable/equatable.dart';

class DashboardModel extends Equatable {
  final int blockCount;
  final int transactionCount;
  final List<dynamic> recentBlocks;
  final int peerCount;
  final String nodeStatus;
  final double networkLatency;
  final Map<String, dynamic> networkArchitecture;

  const DashboardModel({
    required this.blockCount,
    required this.transactionCount,
    required this.recentBlocks,
    required this.peerCount,
    required this.nodeStatus,
    required this.networkLatency,
    required this.networkArchitecture,
  });

  @override
  List<Object> get props => [
        blockCount,
        transactionCount,
        recentBlocks,
        peerCount,
        nodeStatus,
        networkLatency,
        networkArchitecture,
      ];

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      blockCount: json['blockCount'] ?? 0,
      transactionCount: json['transactionCount'] ?? 0,
      recentBlocks: json['recentBlocks'] is List ? json['recentBlocks'] : [],
      peerCount: json['peerCount'] ?? 0,
      nodeStatus: json['nodeStatus'] ?? 'unknown',
      networkLatency: (json['networkLatency'] ?? 0.0).toDouble(),
      networkArchitecture: json['networkArchitecture'] is Map<String, dynamic>
          ? json['networkArchitecture']
          : {
              'nodeTypes': {
                'validators': {'count': 0, 'active': 0, 'description': 'No data'},
                'observers': {'count': 0, 'description': 'No data'},
                'fullNodes': {'count': 0, 'description': 'No data'},
              },
              'p2pProtocol': {
                'type': 'Unknown',
                'version': '0.0',
                'discovery': 'Unknown',
                'transport': 'Unknown',
                'description': 'No data available',
              },
              'consensusMechanism': {
                'type': 'Unknown',
                'blockTime': '0s',
                'finality': 'Unknown',
                'description': 'No data available',
              },
              'networkTopology': {
                'type': 'Unknown',
                'maxPeers': 0,
                'connections': 'Unknown',
                'description': 'No data available',
              },
              'securityFeatures': {
                'encryption': 'Unknown',
                'authentication': 'Unknown',
                'rateLimiting': 'Unknown',
                'slashing': 'Unknown',
                'description': 'No data available',
              },
            },
    );
  }
}
