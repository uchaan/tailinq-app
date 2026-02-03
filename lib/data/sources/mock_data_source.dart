import 'dart:math';
import '../models/device.dart';
import '../models/location.dart';
import '../../core/constants/app_constants.dart';

class MockDataSource {
  final Random _random = Random();

  List<Device> getMockDevices() {
    return [
      Device(
        id: '1',
        name: 'Max',
        batteryLevel: 85,
        status: DeviceStatus.online,
        isLiveMode: false,
        imageUrl: null,
        safeZoneRadius: 100.0,
        lastLocation: Location(
          latitude: AppConstants.defaultLatitude,
          longitude: AppConstants.defaultLongitude,
          timestamp: DateTime.now(),
        ),
      ),
      Device(
        id: '2',
        name: 'Bella',
        batteryLevel: 45,
        status: DeviceStatus.lowBattery,
        isLiveMode: false,
        imageUrl: null,
        safeZoneRadius: 150.0,
        lastLocation: Location(
          latitude: AppConstants.defaultLatitude + 0.002,
          longitude: AppConstants.defaultLongitude + 0.002,
          timestamp: DateTime.now(),
        ),
      ),
    ];
  }

  Location generateRandomLocation(Location baseLocation) {
    final latOffset = (_random.nextDouble() - 0.5) * 0.001;
    final lngOffset = (_random.nextDouble() - 0.5) * 0.001;

    return Location(
      latitude: baseLocation.latitude + latOffset,
      longitude: baseLocation.longitude + lngOffset,
      timestamp: DateTime.now(),
    );
  }
}
