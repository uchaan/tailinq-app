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
  final Map<String, Timer> _locationTimers = {};
  Location? _lastEmittedLocation;

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
    // 기존 스트림 정리
    _locationControllers[deviceId]?.close();
    _locationTimers[deviceId]?.cancel();

    final controller = StreamController<Location>.broadcast();
    _locationControllers[deviceId] = controller;

    // 주기적으로 현재 lastLocation을 emit (좌표 자체를 변경하지 않음)
    final timer = Timer.periodic(AppConstants.locationUpdateInterval, (timer) {
      if (controller.isClosed) {
        timer.cancel();
        return;
      }

      final device = _devices[deviceId];
      if (device != null && device.isLiveMode && device.lastLocation != null) {
        final location = device.lastLocation!;
        // 동일 좌표 중복 emit 방지
        if (_lastEmittedLocation == null ||
            _lastEmittedLocation!.latitude != location.latitude ||
            _lastEmittedLocation!.longitude != location.longitude) {
          _lastEmittedLocation = location;
          controller.add(location);
        }
      }
    });
    _locationTimers[deviceId] = timer;

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
    for (final timer in _locationTimers.values) {
      timer.cancel();
    }
    _locationControllers.clear();
    _locationTimers.clear();
  }
}
