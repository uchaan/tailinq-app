import 'package:freezed_annotation/freezed_annotation.dart';

part 'pet_geofence.freezed.dart';
part 'pet_geofence.g.dart';

@freezed
class PetGeofence with _$PetGeofence {
  const factory PetGeofence({
    required String id,
    required String petId,
    required String geofenceId,
    required DateTime assignedAt,
  }) = _PetGeofence;

  factory PetGeofence.fromJson(Map<String, dynamic> json) =>
      _$PetGeofenceFromJson(json);
}
