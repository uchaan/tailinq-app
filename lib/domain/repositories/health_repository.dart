import '../../data/models/health_metric.dart';

abstract class HealthRepository {
  Future<List<HealthMetric>> getHealthMetrics(String petId);
  Future<HealthMetric> getHealthMetricDetail(
    String petId,
    HealthMetricType type, {
    int days = 30,
  });
}
