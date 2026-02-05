import 'package:freezed_annotation/freezed_annotation.dart';

part 'health_metric.freezed.dart';
part 'health_metric.g.dart';

enum HealthMetricType {
  activity,
  rest,
  eating,
  drinking,
}

@freezed
class DailyDataPoint with _$DailyDataPoint {
  const factory DailyDataPoint({
    required DateTime date,
    required double value,
  }) = _DailyDataPoint;

  factory DailyDataPoint.fromJson(Map<String, dynamic> json) =>
      _$DailyDataPointFromJson(json);
}

@freezed
class HealthMetric with _$HealthMetric {
  const factory HealthMetric({
    required String petId,
    required HealthMetricType type,
    required String unit,
    required double currentValue,
    required double changePercent,
    required List<DailyDataPoint> dailyData,
  }) = _HealthMetric;

  factory HealthMetric.fromJson(Map<String, dynamic> json) =>
      _$HealthMetricFromJson(json);
}
