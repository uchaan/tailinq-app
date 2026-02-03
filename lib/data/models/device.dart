import 'package:freezed_annotation/freezed_annotation.dart';
import 'location.dart';

part 'device.freezed.dart';
part 'device.g.dart';

enum DeviceStatus {
  online,
  offline,
  lowBattery,
}

@freezed
class Device with _$Device {
  const factory Device({
    required String id,
    required String name,
    required int batteryLevel,
    required DeviceStatus status,
    required bool isLiveMode,
    String? imageUrl,
    @Default(100.0) double safeZoneRadius,
    Location? lastLocation,
  }) = _Device;

  factory Device.fromJson(Map<String, dynamic> json) => _$DeviceFromJson(json);
}
