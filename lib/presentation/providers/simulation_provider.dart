import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/location.dart';
import '../../data/services/location_simulator.dart';
import '../../core/constants/app_constants.dart';

/// 시뮬레이션 상태
class SimulationState {
  final bool isEnabled;
  final bool isRunning;
  final SimulationScenario scenario;
  final Location? currentLocation;

  const SimulationState({
    this.isEnabled = false,
    this.isRunning = false,
    this.scenario = SimulationScenario.idle,
    this.currentLocation,
  });

  SimulationState copyWith({
    bool? isEnabled,
    bool? isRunning,
    SimulationScenario? scenario,
    Location? currentLocation,
  }) {
    return SimulationState(
      isEnabled: isEnabled ?? this.isEnabled,
      isRunning: isRunning ?? this.isRunning,
      scenario: scenario ?? this.scenario,
      currentLocation: currentLocation ?? this.currentLocation,
    );
  }
}

/// 시뮬레이션 Notifier
class SimulationNotifier extends StateNotifier<SimulationState> {
  LocationSimulator? _simulator;

  SimulationNotifier() : super(const SimulationState());

  LocationSimulator get simulator {
    _simulator ??= LocationSimulator(
      homeLocation: Location(
        latitude: AppConstants.defaultLatitude,
        longitude: AppConstants.defaultLongitude,
        timestamp: DateTime.now(),
      ),
    );
    return _simulator!;
  }

  /// 시뮬레이션 활성화/비활성화
  void toggleEnabled() {
    if (state.isEnabled) {
      // 비활성화
      simulator.stop();
      state = state.copyWith(
        isEnabled: false,
        isRunning: false,
        scenario: SimulationScenario.idle,
      );
    } else {
      // 활성화
      state = state.copyWith(isEnabled: true);
    }
  }

  /// 시뮬레이션 시작/일시정지
  void toggleRunning() {
    if (!state.isEnabled) return;

    if (state.isRunning) {
      simulator.pause();
      state = state.copyWith(isRunning: false);
    } else {
      simulator.start();
      state = state.copyWith(isRunning: true);
    }
  }

  /// 시나리오 변경
  void setScenario(SimulationScenario scenario) {
    simulator.setScenario(scenario);
    state = state.copyWith(scenario: scenario);
  }

  /// 홈 위치 설정
  void setHomeLocation(Location location) {
    simulator.setHomeLocation(location);
  }

  /// 현재 위치 업데이트 (내부 호출용)
  void updateCurrentLocation(Location location) {
    state = state.copyWith(currentLocation: location);
  }

  @override
  void dispose() {
    _simulator?.dispose();
    super.dispose();
  }
}

/// 시뮬레이션 Provider
final simulationProvider =
    StateNotifierProvider<SimulationNotifier, SimulationState>((ref) {
  final notifier = SimulationNotifier();
  ref.onDispose(() => notifier.dispose());
  return notifier;
});

/// 시뮬레이션 위치 스트림 Provider
final simulationLocationStreamProvider = StreamProvider<Location?>((ref) {
  final simulationState = ref.watch(simulationProvider);
  final notifier = ref.read(simulationProvider.notifier);

  if (!simulationState.isEnabled || !simulationState.isRunning) {
    return Stream.value(null);
  }

  return notifier.simulator.locationStream.map((location) {
    // 상태 업데이트
    notifier.updateCurrentLocation(location);
    return location;
  });
});
