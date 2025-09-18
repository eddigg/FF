
import '../models/dashboard_model.dart';
import 'dashboard_repository.dart';
import '../data_sources/dashboard_api_client.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardApiClient apiClient;

  DashboardRepositoryImpl({required this.apiClient});

  @override
  Future<DashboardModel> getDashboardData() async {
    final data = await apiClient.fetchDashboardData();
    return DashboardModel.fromJson(data);
  }
}
