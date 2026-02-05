// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_metric.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DailyDataPointImpl _$$DailyDataPointImplFromJson(Map<String, dynamic> json) =>
    _$DailyDataPointImpl(
      date: DateTime.parse(json['date'] as String),
      value: (json['value'] as num).toDouble(),
    );

Map<String, dynamic> _$$DailyDataPointImplToJson(
  _$DailyDataPointImpl instance,
) => <String, dynamic>{
  'date': instance.date.toIso8601String(),
  'value': instance.value,
};

_$HealthMetricImpl _$$HealthMetricImplFromJson(Map<String, dynamic> json) =>
    _$HealthMetricImpl(
      petId: json['petId'] as String,
      type: $enumDecode(_$HealthMetricTypeEnumMap, json['type']),
      unit: json['unit'] as String,
      currentValue: (json['currentValue'] as num).toDouble(),
      changePercent: (json['changePercent'] as num).toDouble(),
      dailyData: (json['dailyData'] as List<dynamic>)
          .map((e) => DailyDataPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$HealthMetricImplToJson(_$HealthMetricImpl instance) =>
    <String, dynamic>{
      'petId': instance.petId,
      'type': _$HealthMetricTypeEnumMap[instance.type]!,
      'unit': instance.unit,
      'currentValue': instance.currentValue,
      'changePercent': instance.changePercent,
      'dailyData': instance.dailyData,
    };

const _$HealthMetricTypeEnumMap = {
  HealthMetricType.activity: 'activity',
  HealthMetricType.rest: 'rest',
  HealthMetricType.eating: 'eating',
  HealthMetricType.drinking: 'drinking',
};
