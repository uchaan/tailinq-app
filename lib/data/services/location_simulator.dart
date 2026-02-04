import 'dart:async';
import 'dart:math';

import '../models/location.dart';

/// 시뮬레이션 시나리오 유형
enum SimulationScenario {
  idle('Idle', 'Resting at home'),
  walking('Walking', 'Taking a walk'),
  running('Running', 'Running around'),
  exploring('Exploring', 'Exploring the area'),
  returning('Returning', 'Going back home');

  final String label;
  final String description;

  const SimulationScenario(this.label, this.description);
}

/// 시뮬레이션 설정
class SimulationConfig {
  final double speedMetersPerSecond;
  final double directionChangeFrequency; // 0.0 ~ 1.0
  final double randomnessFactor; // 0.0 ~ 1.0

  const SimulationConfig({
    required this.speedMetersPerSecond,
    required this.directionChangeFrequency,
    required this.randomnessFactor,
  });

  static SimulationConfig forScenario(SimulationScenario scenario) {
    switch (scenario) {
      case SimulationScenario.idle:
        return const SimulationConfig(
          speedMetersPerSecond: 0.0,
          directionChangeFrequency: 0.0,
          randomnessFactor: 0.1,
        );
      case SimulationScenario.walking:
        return const SimulationConfig(
          speedMetersPerSecond: 1.2, // 약 4.3 km/h
          directionChangeFrequency: 0.1,
          randomnessFactor: 0.2,
        );
      case SimulationScenario.running:
        return const SimulationConfig(
          speedMetersPerSecond: 4.0, // 약 14.4 km/h
          directionChangeFrequency: 0.3,
          randomnessFactor: 0.4,
        );
      case SimulationScenario.exploring:
        return const SimulationConfig(
          speedMetersPerSecond: 0.8,
          directionChangeFrequency: 0.4,
          randomnessFactor: 0.6,
        );
      case SimulationScenario.returning:
        return const SimulationConfig(
          speedMetersPerSecond: 1.5,
          directionChangeFrequency: 0.05,
          randomnessFactor: 0.1,
        );
    }
  }
}

/// 펫 위치 시뮬레이터
class LocationSimulator {
  final Random _random = Random();

  Location _homeLocation;
  Location _currentLocation;
  SimulationScenario _scenario = SimulationScenario.idle;
  SimulationConfig _config = SimulationConfig.forScenario(SimulationScenario.idle);

  double _currentDirection = 0.0; // 라디안
  final List<Location> _waypoints = [];
  int _currentWaypointIndex = 0;
  bool _isReturningOnPath = false;

  Timer? _simulationTimer;
  final StreamController<Location> _locationController = StreamController<Location>.broadcast();

  bool _isRunning = false;

  // 위도/경도 1도당 미터 (대략적인 값)
  static const double _metersPerDegreeLat = 111320.0;
  static const double _metersPerDegreeLng = 111320.0 * 0.85; // 위도에 따라 다름, 한국 기준 약 85%

  LocationSimulator({
    required Location homeLocation,
  })  : _homeLocation = homeLocation,
        _currentLocation = homeLocation {
    _generateRandomWaypoints();
  }

  Location get currentLocation => _currentLocation;
  Location get homeLocation => _homeLocation;
  SimulationScenario get scenario => _scenario;
  bool get isRunning => _isRunning;
  Stream<Location> get locationStream => _locationController.stream;

  /// 시나리오 변경
  void setScenario(SimulationScenario scenario) {
    _scenario = scenario;
    _config = SimulationConfig.forScenario(scenario);

    if (scenario == SimulationScenario.returning) {
      _calculateDirectionToHome();
    } else if (scenario == SimulationScenario.walking) {
      _generateRandomWaypoints();
      _currentWaypointIndex = 0;
      _isReturningOnPath = false;
    }
  }

  /// 홈 위치 설정
  void setHomeLocation(Location location) {
    _homeLocation = location;
    _currentLocation = location;
    _generateRandomWaypoints();
  }

  /// 랜덤 웨이포인트 생성 (산책 경로)
  void _generateRandomWaypoints() {
    _waypoints.clear();

    // 홈 위치 기준으로 5~8개의 웨이포인트 생성
    final waypointCount = 5 + _random.nextInt(4);
    var baseDirection = _random.nextDouble() * 2 * pi;

    Location lastPoint = _homeLocation;

    for (int i = 0; i < waypointCount; i++) {
      // 방향을 조금씩 변경하면서 경로 생성
      baseDirection += (_random.nextDouble() - 0.5) * pi / 2;

      // 거리: 30~80m
      final distance = 30 + _random.nextDouble() * 50;

      final latOffset = (distance * cos(baseDirection)) / _metersPerDegreeLat;
      final lngOffset = (distance * sin(baseDirection)) / _metersPerDegreeLng;

      final newPoint = Location(
        latitude: lastPoint.latitude + latOffset,
        longitude: lastPoint.longitude + lngOffset,
        timestamp: DateTime.now(),
      );

      _waypoints.add(newPoint);
      lastPoint = newPoint;
    }

    // 마지막에 홈으로 돌아오는 포인트 추가
    _waypoints.add(_homeLocation);
  }

  /// 홈 방향 계산
  void _calculateDirectionToHome() {
    final latDiff = _homeLocation.latitude - _currentLocation.latitude;
    final lngDiff = _homeLocation.longitude - _currentLocation.longitude;
    _currentDirection = atan2(lngDiff * _metersPerDegreeLng, latDiff * _metersPerDegreeLat);
  }

  /// 시뮬레이션 시작
  void start() {
    if (_isRunning) return;
    _isRunning = true;

    // 1초마다 위치 업데이트
    _simulationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateLocation();
    });
  }

  /// 시뮬레이션 일시정지
  void pause() {
    _simulationTimer?.cancel();
    _simulationTimer = null;
    _isRunning = false;
  }

  /// 시뮬레이션 정지 및 초기화
  void stop() {
    pause();
    _currentLocation = _homeLocation;
    _scenario = SimulationScenario.idle;
    _config = SimulationConfig.forScenario(SimulationScenario.idle);
    _locationController.add(_currentLocation);
  }

  /// 위치 업데이트
  void _updateLocation() {
    switch (_scenario) {
      case SimulationScenario.idle:
        _updateIdle();
        break;
      case SimulationScenario.walking:
        _updateWalking();
        break;
      case SimulationScenario.running:
        _updateRunning();
        break;
      case SimulationScenario.exploring:
        _updateExploring();
        break;
      case SimulationScenario.returning:
        _updateReturning();
        break;
    }

    _locationController.add(_currentLocation);
  }

  /// Idle: 미세한 움직임만
  void _updateIdle() {
    final jitter = _config.randomnessFactor * 0.00001; // 매우 작은 움직임
    _currentLocation = Location(
      latitude: _currentLocation.latitude + (_random.nextDouble() - 0.5) * jitter,
      longitude: _currentLocation.longitude + (_random.nextDouble() - 0.5) * jitter,
      timestamp: DateTime.now(),
    );
  }

  /// Walking: 웨이포인트 따라 이동
  void _updateWalking() {
    if (_waypoints.isEmpty) {
      _generateRandomWaypoints();
      return;
    }

    final targetWaypoint = _waypoints[_currentWaypointIndex];
    final distanceToTarget = _calculateDistance(_currentLocation, targetWaypoint);

    // 목표 웨이포인트 도달 시 다음으로
    if (distanceToTarget < 5) {
      if (_isReturningOnPath) {
        _currentWaypointIndex--;
        if (_currentWaypointIndex < 0) {
          _isReturningOnPath = false;
          _currentWaypointIndex = 0;
          _generateRandomWaypoints(); // 새 경로 생성
        }
      } else {
        _currentWaypointIndex++;
        if (_currentWaypointIndex >= _waypoints.length) {
          _isReturningOnPath = true;
          _currentWaypointIndex = _waypoints.length - 2;
        }
      }
      return;
    }

    // 웨이포인트 방향으로 이동
    _moveTowards(targetWaypoint, _config.speedMetersPerSecond);
  }

  /// Running: 빠르고 불규칙한 이동
  void _updateRunning() {
    // 방향 자주 변경
    if (_random.nextDouble() < _config.directionChangeFrequency) {
      _currentDirection += (_random.nextDouble() - 0.5) * pi;
    }

    // 홈에서 너무 멀어지면 방향 조정 (최대 200m)
    final distanceFromHome = _calculateDistance(_currentLocation, _homeLocation);
    if (distanceFromHome > 200) {
      _calculateDirectionToHome();
    }

    _moveInDirection(_currentDirection, _config.speedMetersPerSecond);
  }

  /// Exploring: 천천히 무작위 탐험
  void _updateExploring() {
    // 간헐적으로 방향 변경
    if (_random.nextDouble() < _config.directionChangeFrequency) {
      _currentDirection += (_random.nextDouble() - 0.5) * pi * 0.5;
    }

    // 홈에서 너무 멀어지면 방향 조정 (최대 150m)
    final distanceFromHome = _calculateDistance(_currentLocation, _homeLocation);
    if (distanceFromHome > 150) {
      _calculateDirectionToHome();
      _currentDirection = _currentDirection + (_random.nextDouble() - 0.5) * pi * 0.3;
    }

    _moveInDirection(_currentDirection, _config.speedMetersPerSecond);
  }

  /// Returning: 홈으로 직선 복귀
  void _updateReturning() {
    final distanceToHome = _calculateDistance(_currentLocation, _homeLocation);

    // 홈 도착 시 idle로 전환
    if (distanceToHome < 3) {
      _currentLocation = _homeLocation;
      setScenario(SimulationScenario.idle);
      return;
    }

    _calculateDirectionToHome();
    _moveInDirection(_currentDirection, _config.speedMetersPerSecond);
  }

  /// 특정 방향으로 이동
  void _moveInDirection(double direction, double speedMps) {
    // 속도에 약간의 랜덤성 추가
    final actualSpeed = speedMps * (1 + (_random.nextDouble() - 0.5) * _config.randomnessFactor);

    final latOffset = (actualSpeed * cos(direction)) / _metersPerDegreeLat;
    final lngOffset = (actualSpeed * sin(direction)) / _metersPerDegreeLng;

    _currentLocation = Location(
      latitude: _currentLocation.latitude + latOffset,
      longitude: _currentLocation.longitude + lngOffset,
      timestamp: DateTime.now(),
    );
  }

  /// 목표 지점을 향해 이동
  void _moveTowards(Location target, double speedMps) {
    final latDiff = target.latitude - _currentLocation.latitude;
    final lngDiff = target.longitude - _currentLocation.longitude;
    final direction = atan2(lngDiff * _metersPerDegreeLng, latDiff * _metersPerDegreeLat);

    // 약간의 방향 흔들림 추가
    final jitteredDirection = direction + (_random.nextDouble() - 0.5) * 0.2;

    _moveInDirection(jitteredDirection, speedMps);
  }

  /// 두 위치 간 거리 계산 (미터)
  double _calculateDistance(Location a, Location b) {
    final latDiff = (b.latitude - a.latitude) * _metersPerDegreeLat;
    final lngDiff = (b.longitude - a.longitude) * _metersPerDegreeLng;
    return sqrt(latDiff * latDiff + lngDiff * lngDiff);
  }

  /// 리소스 정리
  void dispose() {
    _simulationTimer?.cancel();
    _locationController.close();
  }
}
