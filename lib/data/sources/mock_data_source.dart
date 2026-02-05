import 'dart:math';
import '../models/device.dart';
import '../models/location.dart';
import '../../core/constants/app_constants.dart';

class MockDataSource {
  final Random _random = Random();

  List<Device> getMockDevices() {
    return [
      Device(
        id: 'device-1',
        batteryLevel: 85,
        status: DeviceStatus.online,
        isLiveMode: false,
        petId: 'pet-1',
        safeZoneRadius: 100.0,
        lastLocation: Location(
          latitude: AppConstants.defaultLatitude,
          longitude: AppConstants.defaultLongitude,
          timestamp: DateTime.now(),
        ),
      ),
      Device(
        id: 'device-2',
        batteryLevel: 45,
        status: DeviceStatus.lowBattery,
        isLiveMode: false,
        petId: 'pet-2',
        safeZoneRadius: 150.0,
        lastLocation: Location(
          latitude: AppConstants.defaultLatitude + 0.0006,
          longitude: AppConstants.defaultLongitude + 0.0007,
          timestamp: DateTime.now(),
        ),
      ),
    ];
  }

  Location generateRandomLocation(Location baseLocation) {
    final latOffset = (_random.nextDouble() - 0.5) * 0.00005;
    final lngOffset = (_random.nextDouble() - 0.5) * 0.00005;

    return Location(
      latitude: baseLocation.latitude + latOffset,
      longitude: baseLocation.longitude + lngOffset,
      timestamp: DateTime.now(),
    );
  }
}
