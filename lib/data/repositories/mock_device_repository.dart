import 'dart:async';
import '../models/device.dart';
import '../models/location.dart';
import '../sources/mock_data_source.dart';
import '../services/location_simulator.dart';
import '../../domain/repositories/device_repository.dart';
import '../../core/constants/app_constants.dart';

class MockDeviceRepository implements DeviceRepository {
  final MockDataSource _dataSource = MockDataSource();
  final Map<String, Device> _devices = {};
  final Map<String, StreamController<Location>> _locationControllers = {};
  final Map<String, Timer> _locationTimers = {};

  // 시뮬레이터 (외부에서 주입 가능)
  LocationSimulator? _simulator;
  StreamSubscription<Location>? _simulatorSubscription;

  MockDeviceRepository() {
    _initDevices();
  }

  void _initDevices() {
    for (final device in _dataSource.getMockDevices()) {
      _devices[device.id] = device;
    }
  }

  /// 시뮬레이터 설정
  void setSimulator(LocationSimulator? simulator) {
    _simulatorSubscription?.cancel();
    _simulator = simulator;
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

    // 시뮬레이터가 있고 실행 중이면 시뮬레이터 사용
    if (_simulator != null && _simulator!.isRunning) {
      _simulatorSubscription?.cancel();
      _simulatorSubscription = _simulator!.locationStream.listen((location) {
        if (!controller.isClosed) {
          _devices[deviceId] = _devices[deviceId]!.copyWith(lastLocation: location);
          controller.add(location);
        }
      });
    } else {
      // 기존 랜덤 위치 생성 로직
      final timer = Timer.periodic(AppConstants.locationUpdateInterval, (timer) {
        if (controller.isClosed) {
          timer.cancel();
          return;
        }

        final device = _devices[deviceId];
        if (device != null && device.isLiveMode && device.lastLocation != null) {
          // 시뮬레이터가 활성화되어 있으면 시뮬레이터 위치 사용
          if (_simulator != null && _simulator!.isRunning) {
            final location = _simulator!.currentLocation;
            _devices[deviceId] = device.copyWith(lastLocation: location);
            controller.add(location);
          } else {
            // 기존 랜덤 로직
            final newLocation = _dataSource.generateRandomLocation(device.lastLocation!);
            _devices[deviceId] = device.copyWith(lastLocation: newLocation);
            controller.add(newLocation);
          }
        }
      });
      _locationTimers[deviceId] = timer;
    }

    return controller.stream;
  }

  /// 시뮬레이션 모드에서 위치 업데이트
  void updateLocationFromSimulator(String deviceId, Location location) {
    final device = _devices[deviceId];
    if (device != null) {
      _devices[deviceId] = device.copyWith(lastLocation: location);
      _locationControllers[deviceId]?.add(location);
    }
  }

  @override
  Future<void> toggleLiveMode(String deviceId, bool isLive) async {
    final device = _devices[deviceId];
    if (device != null) {
      _devices[deviceId] = device.copyWith(isLiveMode: isLive);
    }
  }

  void dispose() {
    _simulatorSubscription?.cancel();
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
