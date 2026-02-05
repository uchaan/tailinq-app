import 'dart:math';

import '../models/health_metric.dart';
import '../../domain/repositories/health_repository.dart';

class MockHealthRepository implements HealthRepository {
  // Baselines per pet species type
  static const _dogBaselines = {
    HealthMetricType.activity: 28000.0, // steps/day
    HealthMetricType.rest: 12.5, // hours/day
    HealthMetricType.eating: 3.2, // events/day
    HealthMetricType.drinking: 8.5, // events/day
  };

  static const _catBaselines = {
    HealthMetricType.activity: 8500.0,
    HealthMetricType.rest: 16.0,
    HealthMetricType.eating: 5.8,
    HealthMetricType.drinking: 12.0,
  };

  static const _variance = {
    HealthMetricType.activity: 0.15,
    HealthMetricType.rest: 0.08,
    HealthMetricType.eating: 0.12,
    HealthMetricType.drinking: 0.10,
  };

  static const _units = {
    HealthMetricType.activity: 'steps/day',
    HealthMetricType.rest: 'hours/day',
    HealthMetricType.eating: 'events/day',
    HealthMetricType.drinking: 'events/day',
  };

  Map<String, Map<HealthMetricType, double>> get _petBaselines => {
        'pet-1': _dogBaselines,
        'pet-2': _catBaselines,
      };

  @override
  Future<List<HealthMetric>> getHealthMetrics(String petId) async {
    final baselines = _petBaselines[petId] ?? _dogBaselines;
    final metrics = <HealthMetric>[];

    // Use a new seeded Random per petId for consistency
    final seed = petId.hashCode + 42;
    final rng = Random(seed);

    for (final type in HealthMetricType.values) {
      final baseline = baselines[type]!;
      final varianceFactor = _variance[type]!;
      final unit = _units[type]!;

      final today = DateTime.now();
      final dailyData = <DailyDataPoint>[];

      for (int i = 6; i >= 0; i--) {
        final date = today.subtract(Duration(days: i));
        final offset = (rng.nextDouble() * 2 - 1) * varianceFactor;
        final value = baseline * (1 + offset);
        dailyData.add(DailyDataPoint(
          date: DateTime(date.year, date.month, date.day),
          value: double.parse(value.toStringAsFixed(1)),
        ));
      }

      final currentValue = dailyData.last.value;
      final previousAvg = dailyData
              .sublist(0, 6)
              .map((d) => d.value)
              .reduce((a, b) => a + b) /
          6;
      final changePercent = ((currentValue - previousAvg) / previousAvg) * 100;

      metrics.add(HealthMetric(
        petId: petId,
        type: type,
        unit: unit,
        currentValue: currentValue,
        changePercent: double.parse(changePercent.toStringAsFixed(1)),
        dailyData: dailyData,
      ));
    }

    return metrics;
  }

  @override
  Future<HealthMetric> getHealthMetricDetail(
    String petId,
    HealthMetricType type, {
    int days = 30,
  }) async {
    final baselines = _petBaselines[petId] ?? _dogBaselines;
    final baseline = baselines[type]!;
    final varianceFactor = _variance[type]!;
    final unit = _units[type]!;

    // Use a different seed from getHealthMetrics for independent data series
    final seed = petId.hashCode + type.index * 100 + 99;
    final rng = Random(seed);

    final today = DateTime.now();
    final dailyData = <DailyDataPoint>[];

    for (int i = days - 1; i >= 0; i--) {
      final date = today.subtract(Duration(days: i));
      final offset = (rng.nextDouble() * 2 - 1) * varianceFactor;
      final value = baseline * (1 + offset);
      dailyData.add(DailyDataPoint(
        date: DateTime(date.year, date.month, date.day),
        value: double.parse(value.toStringAsFixed(1)),
      ));
    }

    final currentValue = dailyData.last.value;
    final previousAvg = dailyData
            .sublist(0, days - 1)
            .map((d) => d.value)
            .reduce((a, b) => a + b) /
        (days - 1);
    final changePercent =
        ((currentValue - previousAvg) / previousAvg) * 100;

    return HealthMetric(
      petId: petId,
      type: type,
      unit: unit,
      currentValue: currentValue,
      changePercent: double.parse(changePercent.toStringAsFixed(1)),
      dailyData: dailyData,
    );
  }
}
