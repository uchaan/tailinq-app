import 'dart:async';
import '../models/device.dart';
import '../models/location.dart';
import '../sources/mock_data_source.dart';
import '../../domain/repositories/device_repository.dart';
import '../../core/constants/app_constants.dart';

class MockDeviceRepository implements DeviceRepository {
  final MockDataSource _dataSource = MockDataSource();
  final Map<String, Device> _devices = {};
  final Map<String, StreamController<Location>> _locationControllers = {};

  MockDeviceRepository() {
    _initDevices();
  }

  void _initDevices() {
    for (final device in _dataSource.getMockDevices()) {
      _devices[device.id] = device;
    }
  }

  @override
  Future<List<Device>> getDevices() async {
    return _devices.values.toList();
  }

  @override
  Future<Device?> getDevice(String id) async {
    return _devices[id];
  }

  @override
  Stream<Location> getLocationStream(String deviceId) {
    _locationControllers[deviceId]?.close();

    final controller = StreamController<Location>.broadcast();
    _locationControllers[deviceId] = controller;

    Timer.periodic(AppConstants.locationUpdateInterval, (timer) {
      if (controller.isClosed) {
        timer.cancel();
        return;
      }

      final device = _devices[deviceId];
      if (device != null && device.isLiveMode && device.lastLocation != null) {
        final newLocation =
            _dataSource.generateRandomLocation(device.lastLocation!);
        _devices[deviceId] = device.copyWith(lastLocation: newLocation);
        controller.add(newLocation);
      }
    });

    return controller.stream;
  }

  @override
  Future<void> toggleLiveMode(String deviceId, bool isLive) async {
    final device = _devices[deviceId];
    if (device != null) {
      _devices[deviceId] = device.copyWith(isLiveMode: isLive);
    }
  }

  void dispose() {
    for (final controller in _locationControllers.values) {
      controller.close();
    }
    _locationControllers.clear();
  }
}
