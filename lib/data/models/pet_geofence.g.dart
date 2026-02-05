// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_geofence.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PetGeofenceImpl _$$PetGeofenceImplFromJson(Map<String, dynamic> json) =>
    _$PetGeofenceImpl(
      id: json['id'] as String,
      petId: json['petId'] as String,
      geofenceId: json['geofenceId'] as String,
      assignedAt: DateTime.parse(json['assignedAt'] as String),
    );

Map<String, dynamic> _$$PetGeofenceImplToJson(_$PetGeofenceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'petId': instance.petId,
      'geofenceId': instance.geofenceId,
      'assignedAt': instance.assignedAt.toIso8601String(),
    };
