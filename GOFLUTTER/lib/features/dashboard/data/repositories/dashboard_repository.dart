
import '../models/dashboard_model.dart';

abstract class DashboardRepository {
  Future<DashboardModel> getDashboardData();
}
