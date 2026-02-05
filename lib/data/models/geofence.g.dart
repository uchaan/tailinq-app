// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geofence.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GeofenceImpl _$$GeofenceImplFromJson(Map<String, dynamic> json) =>
    _$GeofenceImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      radiusMeters: (json['radiusMeters'] as num).toDouble(),
      color: (json['color'] as num?)?.toInt() ?? 0xFF4CAF50,
    );

Map<String, dynamic> _$$GeofenceImplToJson(_$GeofenceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'radiusMeters': instance.radiusMeters,
      'color': instance.color,
    };
