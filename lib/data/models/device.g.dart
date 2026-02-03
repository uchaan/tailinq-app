// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DeviceImpl _$$DeviceImplFromJson(Map<String, dynamic> json) => _$DeviceImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  batteryLevel: (json['batteryLevel'] as num).toInt(),
  status: $enumDecode(_$DeviceStatusEnumMap, json['status']),
  isLiveMode: json['isLiveMode'] as bool,
  imageUrl: json['imageUrl'] as String?,
  safeZoneRadius: (json['safeZoneRadius'] as num?)?.toDouble() ?? 100.0,
  lastLocation: json['lastLocation'] == null
      ? null
      : Location.fromJson(json['lastLocation'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$DeviceImplToJson(_$DeviceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'batteryLevel': instance.batteryLevel,
      'status': _$DeviceStatusEnumMap[instance.status]!,
      'isLiveMode': instance.isLiveMode,
      'imageUrl': instance.imageUrl,
      'safeZoneRadius': instance.safeZoneRadius,
      'lastLocation': instance.lastLocation,
    };

const _$DeviceStatusEnumMap = {
  DeviceStatus.online: 'online',
  DeviceStatus.offline: 'offline',
  DeviceStatus.lowBattery: 'lowBattery',
};
