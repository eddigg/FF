import 'package:atlas_blockchain_flutter/features/health/domain/entities/health_status.dart';

abstract class HealthRepository {
  Future<HealthStatus> getHealthStatus();
  Future<List<Map<String, dynamic>>> getRecentBlocks();
  Future<List<String>> getPeers();
  Future<Map<String, dynamic>> getSystemMetrics();
}
