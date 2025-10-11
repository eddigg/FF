import 'package:equatable/equatable.dart';

/// Model for network architecture data
class NetworkArchitectureModel extends Equatable {
  final NodeTypes nodeTypes;
  final P2PProtocol p2pProtocol;
  final ConsensusMechanism consensusMechanism;
  final NetworkTopology networkTopology;
  final SecurityFeatures securityFeatures;

  const NetworkArchitectureModel({
    required this.nodeTypes,
    required this.p2pProtocol,
    required this.consensusMechanism,
    required this.networkTopology,
    required this.securityFeatures,
  });

  @override
  List<Object> get props => [
        nodeTypes,
        p2pProtocol,
        consensusMechanism,
        networkTopology,
        securityFeatures,
      ];

  factory NetworkArchitectureModel.fromJson(Map<String, dynamic> json) {
    return NetworkArchitectureModel(
      nodeTypes: NodeTypes.fromJson(json['nodeTypes'] as Map<String, dynamic>),
      p2pProtocol:
          P2PProtocol.fromJson(json['p2pProtocol'] as Map<String, dynamic>),
      consensusMechanism: ConsensusMechanism.fromJson(
          json['consensusMechanism'] as Map<String, dynamic>),
      networkTopology: NetworkTopology.fromJson(
          json['networkTopology'] as Map<String, dynamic>),
      securityFeatures: SecurityFeatures.fromJson(
          json['securityFeatures'] as Map<String, dynamic>),
    );
  }

  /// Create a default/empty instance
  factory NetworkArchitectureModel.empty() {
    return NetworkArchitectureModel(
      nodeTypes: NodeTypes.empty(),
      p2pProtocol: P2PProtocol.empty(),
      consensusMechanism: ConsensusMechanism.empty(),
      networkTopology: NetworkTopology.empty(),
      securityFeatures: SecurityFeatures.empty(),
    );
  }
}

/// Node types information
class NodeTypes extends Equatable {
  final ValidatorInfo validators;
  final ObserverInfo observers;
  final FullNodeInfo fullNodes;

  const NodeTypes({
    required this.validators,
    required this.observers,
    required this.fullNodes,
  });

  @override
  List<Object> get props => [validators, observers, fullNodes];

  factory NodeTypes.fromJson(Map<String, dynamic> json) {
    return NodeTypes(
      validators:
          ValidatorInfo.fromJson(json['validators'] as Map<String, dynamic>),
      observers:
          ObserverInfo.fromJson(json['observers'] as Map<String, dynamic>),
      fullNodes:
          FullNodeInfo.fromJson(json['fullNodes'] as Map<String, dynamic>),
    );
  }

  factory NodeTypes.empty() {
    return NodeTypes(
      validators: ValidatorInfo.empty(),
      observers: ObserverInfo.empty(),
      fullNodes: FullNodeInfo.empty(),
    );
  }
}

/// Validator information
class ValidatorInfo extends Equatable {
  final int count;
  final int active;
  final int totalStake;
  final int minStake;
  final String description;

  const ValidatorInfo({
    required this.count,
    required this.active,
    required this.totalStake,
    required this.minStake,
    required this.description,
  });

  @override
  List<Object> get props => [count, active, totalStake, minStake, description];

  factory ValidatorInfo.fromJson(Map<String, dynamic> json) {
    return ValidatorInfo(
      count: json['count'] as int? ?? 0,
      active: json['active'] as int? ?? 0,
      totalStake: json['totalStake'] as int? ?? 0,
      minStake: json['minStake'] as int? ?? 0,
      description: json['description'] as String? ?? '',
    );
  }

  factory ValidatorInfo.empty() {
    return ValidatorInfo(
      count: 0,
      active: 0,
      totalStake: 0,
      minStake: 0,
      description: 'No data available',
    );
  }
}

/// Observer information
class ObserverInfo extends Equatable {
  final int count;
  final String description;

  const ObserverInfo({
    required this.count,
    required this.description,
  });

  @override
  List<Object> get props => [count, description];

  factory ObserverInfo.fromJson(Map<String, dynamic> json) {
    return ObserverInfo(
      count: json['count'] as int? ?? 0,
      description: json['description'] as String? ?? '',
    );
  }

  factory ObserverInfo.empty() {
    return ObserverInfo(
      count: 0,
      description: 'No data available',
    );
  }
}

/// Full node information
class FullNodeInfo extends Equatable {
  final int count;
  final String description;

  const FullNodeInfo({
    required this.count,
    required this.description,
  });

  @override
  List<Object> get props => [count, description];

  factory FullNodeInfo.fromJson(Map<String, dynamic> json) {
    return FullNodeInfo(
      count: json['count'] as int? ?? 0,
      description: json['description'] as String? ?? '',
    );
  }

  factory FullNodeInfo.empty() {
    return FullNodeInfo(
      count: 0,
      description: 'No data available',
    );
  }
}

/// P2P protocol information
class P2PProtocol extends Equatable {
  final String type;
  final String version;
  final String discovery;
  final String transport;
  final String description;

  const P2PProtocol({
    required this.type,
    required this.version,
    required this.discovery,
    required this.transport,
    required this.description,
  });

  @override
  List<Object> get props => [type, version, discovery, transport, description];

  factory P2PProtocol.fromJson(Map<String, dynamic> json) {
    return P2PProtocol(
      type: json['type'] as String? ?? '',
      version: json['version'] as String? ?? '',
      discovery: json['discovery'] as String? ?? '',
      transport: json['transport'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  factory P2PProtocol.empty() {
    return P2PProtocol(
      type: 'Unknown',
      version: '0.0',
      discovery: 'Unknown',
      transport: 'Unknown',
      description: 'No data available',
    );
  }
}

/// Consensus mechanism information
class ConsensusMechanism extends Equatable {
  final String type;
  final String blockTime;
  final String finality;
  final String description;

  const ConsensusMechanism({
    required this.type,
    required this.blockTime,
    required this.finality,
    required this.description,
  });

  @override
  List<Object> get props => [type, blockTime, finality, description];

  factory ConsensusMechanism.fromJson(Map<String, dynamic> json) {
    return ConsensusMechanism(
      type: json['type'] as String? ?? '',
      blockTime: json['blockTime'] as String? ?? '',
      finality: json['finality'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  factory ConsensusMechanism.empty() {
    return ConsensusMechanism(
      type: 'Unknown',
      blockTime: '0s',
      finality: 'Unknown',
      description: 'No data available',
    );
  }
}

/// Network topology information
class NetworkTopology extends Equatable {
  final String type;
  final String connections;
  final int maxPeers;
  final String description;

  const NetworkTopology({
    required this.type,
    required this.connections,
    required this.maxPeers,
    required this.description,
  });

  @override
  List<Object> get props => [type, connections, maxPeers, description];

  factory NetworkTopology.fromJson(Map<String, dynamic> json) {
    return NetworkTopology(
      type: json['type'] as String? ?? '',
      connections: json['connections'] as String? ?? '',
      maxPeers: json['maxPeers'] as int? ?? 0,
      description: json['description'] as String? ?? '',
    );
  }

  factory NetworkTopology.empty() {
    return NetworkTopology(
      type: 'Unknown',
      connections: 'Unknown',
      maxPeers: 0,
      description: 'No data available',
    );
  }
}

/// Security features information
class SecurityFeatures extends Equatable {
  final String encryption;
  final String authentication;
  final String rateLimiting;
  final String slashing;
  final String description;

  const SecurityFeatures({
    required this.encryption,
    required this.authentication,
    required this.rateLimiting,
    required this.slashing,
    required this.description,
  });

  @override
  List<Object> get props =>
      [encryption, authentication, rateLimiting, slashing, description];

  factory SecurityFeatures.fromJson(Map<String, dynamic> json) {
    return SecurityFeatures(
      encryption: json['encryption'] as String? ?? '',
      authentication: json['authentication'] as String? ?? '',
      rateLimiting: json['rateLimiting'] as String? ?? '',
      slashing: json['slashing'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  factory SecurityFeatures.empty() {
    return SecurityFeatures(
      encryption: 'Unknown',
      authentication: 'Unknown',
      rateLimiting: 'Unknown',
      slashing: 'Unknown',
      description: 'No data available',
    );
  }
}
