import 'package:freezed_annotation/freezed_annotation.dart';

part 'geofence.freezed.dart';
part 'geofence.g.dart';

@freezed
class Geofence with _$Geofence {
  const factory Geofence({
    required String id,
    required String name,
    required double latitude,
    required double longitude,
    required double radiusMeters,
    @Default(0xFF4CAF50) int color,
  }) = _Geofence;

  factory Geofence.fromJson(Map<String, dynamic> json) =>
      _$GeofenceFromJson(json);
}
