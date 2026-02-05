import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/health_metric.dart';
import '../../data/repositories/mock_health_repository.dart';
import 'pet_provider.dart';

final healthRepositoryProvider = Provider<MockHealthRepository>((ref) {
  return MockHealthRepository();
});

final healthMetricsProvider = FutureProvider<List<HealthMetric>>((ref) async {
  final petId = ref.watch(selectedPetIdProvider);
  if (petId == null) return [];
  final repository = ref.watch(healthRepositoryProvider);
  return repository.getHealthMetrics(petId);
});

final healthMetricDetailProvider =
    FutureProvider.family<HealthMetric?, HealthMetricType>(
        (ref, type) async {
  final petId = ref.watch(selectedPetIdProvider);
  if (petId == null) return null;
  final repository = ref.watch(healthRepositoryProvider);
  return repository.getHealthMetricDetail(petId, type);
});
