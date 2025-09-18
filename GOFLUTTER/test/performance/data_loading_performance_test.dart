import 'package:flutter_test/flutter_test.dart';
import 'package:atlas_blockchain_flutter/features/dashboard/data/models/network_architecture_model.dart';
import 'package:atlas_blockchain_flutter/features/node_dashboard/data/models/node_metrics_model.dart';
import 'dart:convert';

void main() {
  group('Data Loading Performance Tests', () {
    test('Network architecture data parsing performance', () {
      // Sample JSON data similar to what would come from the API
      final jsonString = '''
      {
        "nodeTypes": {
          "validators": {
            "count": 100,
            "active": 95,
            "totalStake": 5000000,
            "minStake": 10000,
            "description": "Validator nodes secure the network"
          },
          "observers": {
            "count": 50,
            "description": "Observer nodes monitor network activity"
          },
          "fullNodes": {
            "count": 200,
            "description": "Full nodes maintain complete blockchain copy"
          }
        },
        "p2pProtocol": {
          "type": "Custom P2P",
          "version": "2.1",
          "discovery": "Kademlia DHT",
          "transport": "TCP/WebSocket",
          "description": "Custom P2P protocol for efficient data transmission"
        },
        "consensusMechanism": {
          "type": "Hybrid PoS + pBFT",
          "blockTime": "2.1s",
          "finality": "1-2 blocks",
          "description": "Hybrid consensus combining Proof of Stake and Byzantine Fault Tolerance"
        },
        "networkTopology": {
          "type": "Hierarchical",
          "connections": "Dynamic mesh",
          "maxPeers": 50,
          "description": "Hierarchical network structure with specialized node clusters"
        },
        "securityFeatures": {
          "encryption": "AES-256",
          "authentication": "Multi-factor",
          "rateLimiting": "Adaptive",
          "slashing": "Enabled",
          "description": "Multi-layered security with encryption, authentication, and monitoring"
        }
      }
      ''';

      // Measure parsing performance
      final stopwatch = Stopwatch()..start();
      
      // Parse the JSON 1000 times to get a good performance measurement
      for (int i = 0; i < 1000; i++) {
        final jsonMap = jsonDecode(jsonString);
        NetworkArchitectureModel.fromJson(jsonMap);
      }
      
      stopwatch.stop();
      
      // Expect parsing to be fast (less than 250ms for 1000 iterations)
      expect(stopwatch.elapsedMilliseconds, lessThan(250));
      
      // Print the actual time for reference
      print('NetworkArchitectureModel parsing time for 1000 iterations: ${stopwatch.elapsedMilliseconds}ms');
    });

    test('Node metrics data parsing performance', () {
      // Sample JSON data for node metrics
      final jsonString = '''
      {
        "uptime": "99.7%",
        "blocksProduced": 12500,
        "transactionsProcessed": 85000
      }
      ''';

      // Measure parsing performance
      final stopwatch = Stopwatch()..start();
      
      // Parse the JSON 1000 times to get a good performance measurement
      for (int i = 0; i < 1000; i++) {
        final jsonMap = jsonDecode(jsonString);
        NodeMetricsModel.fromJson(jsonMap);
      }
      
      stopwatch.stop();
      
      // Expect parsing to be fast (less than 50ms for 1000 iterations)
      expect(stopwatch.elapsedMilliseconds, lessThan(50));
      
      // Print the actual time for reference
      print('NodeMetricsModel parsing time for 1000 iterations: ${stopwatch.elapsedMilliseconds}ms');
    });

    test('Large data set parsing performance', () {
      // Create a larger JSON structure to test performance with more data
      final largeJson = {
        'nodeTypes': {
          'validators': {
            'count': 100,
            'active': 95,
            'totalStake': 5000000,
            'minStake': 10000,
            'description': 'Validator nodes secure the network'
          },
          'observers': {
            'count': 50,
            'description': List.generate(50, (index) => 'Observer node type $index').join(', ')
          },
          'fullNodes': {
            'count': 200,
            'description': 'Full nodes maintain complete blockchain copy'
          }
        },
        'p2pProtocol': {
          'type': 'Custom P2P',
          'version': '2.1',
          'discovery': 'Kademlia DHT',
          'transport': 'TCP/WebSocket',
          'description': 'Custom P2P protocol for efficient data transmission'
        },
        'consensusMechanism': {
          'type': 'Hybrid PoS + pBFT',
          'blockTime': '2.1s',
          'finality': '1-2 blocks',
          'description': 'Hybrid consensus combining Proof of Stake and Byzantine Fault Tolerance'
        },
        'networkTopology': {
          'type': 'Hierarchical',
          'connections': 'Dynamic mesh',
          'maxPeers': 50,
          'description': 'Hierarchical network structure with specialized node clusters'
        },
        'securityFeatures': {
          'encryption': 'AES-256',
          'authentication': 'Multi-factor',
          'rateLimiting': 'Adaptive',
          'slashing': 'Enabled',
          'description': 'Multi-layered security with encryption, authentication, and monitoring'
        }
      };

      final jsonString = jsonEncode(largeJson);

      // Measure parsing performance
      final stopwatch = Stopwatch()..start();
      
      // Parse the JSON 100 times to get a good performance measurement
      for (int i = 0; i < 100; i++) {
        final jsonMap = jsonDecode(jsonString);
        NetworkArchitectureModel.fromJson(jsonMap);
      }
      
      stopwatch.stop();
      
      // Expect parsing to be reasonable even with larger data (less than 200ms for 100 iterations)
      expect(stopwatch.elapsedMilliseconds, lessThan(200));
      
      // Print the actual time for reference
      print('Large NetworkArchitectureModel parsing time for 100 iterations: ${stopwatch.elapsedMilliseconds}ms');
    });
  });
}